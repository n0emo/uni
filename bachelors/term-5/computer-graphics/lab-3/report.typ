#import "../common.typ": *

#show: report.with(number: "3–5", title: "Реализация динамической трёхмерной сцены")

== Цель работы

Получить теоретические и практические навыки работы по базовой работе с трёхмерными сценами в
WebGPU.

== Задание

Вывести на экран свои инициалы в виде объемного изображения, которое должно перемещаться по экрану.
Добавить эффект освещенной поверхности, реализующей диффузное (зеркальное) отражение света.
Реализовать наложение текстур на поверхность объекта.

== Введение

В данной работе был реализован механизм камеры для возможности просмотра сцены с разных углов (и тем
самым перемещать изображение по экрану). Было применено инстанциирование для формирования целой
сцены из множества кубов. В программу добавлен Z-буфер для автоматической сортировки фрагментов по
глубине. На языке шейдеров WGSL было реализовано диффузное освещение. В память была загружена
текстура и с помощью шейдера помещена на сцену. По каждому аспекту выполнения работы представлен
отдельный раздел.

== Камера

Камера в данной работе представляет собой классическую трёхмерную камеру. Каждый кадр на основе её
параметров формируется проекционная матрица, которая далее записывается в буфер видеопамяти и
доступна в шейдере. Для математических расчётов используется библиотека cgmath, которая рассчитана
на систему координат OpenGL, поэтому требуется дополнительное преобразование матрицы в формат,
подходящий для WebGPU.

```rust
pub struct CameraParams {
    pub eye: Point3<f32>,
    pub target: Point3<f32>,
    pub up: Vector3<f32>,
    pub fovy: Deg<f32>,
    pub aspect: f32,
    pub znear: f32,
    pub zfar: f32,
}

impl CameraParams {
    #[rustfmt::skip]
    pub const OPENGL_TO_WGPU_MATRIX: Matrix4<f32> = Matrix4::new(
        1.0, 0.0, 0.0, 0.0,
        0.0, 1.0, 0.0, 0.0,
        0.0, 0.0, 0.5, 0.5,
        0.0, 0.0, 0.0, 1.0,
    );

    pub fn compute_view_projection_matrix(&self) -> [[f32; 4]; 4] {
        let view = Matrix4::look_at_rh(self.eye, self.target, self.up);
        let proj = perspective(self.fovy, self.aspect, self.znear, self.zfar);
        let matrix = Self::OPENGL_TO_WGPU_MATRIX * proj * view;
        matrix.into()
    }
}
```

Далее камера используется в вершинном шейдере для вычисления позиции вершины на экране.

```wgsl
@vertex
fn vs_main(
    in: VertexInput,
) -> VertexOutput {
    var out: VertexOutput;

    out.position = camera.view_proj * vec4<f32>(in.position, 1.0);

    return out;
}
```

== Инстанциирование

Загружать в буфер видеопамяти вершины каждого куба, который необходимо нарисовать, весьма
расточительно. В данной работе для каждого куба меняется лишь их положение в пространстве без учёта
вращения. Вместо 24 вершин с координатой и (для следующих пунктов работы) координаты текстуры и
вектора нормали, достаточно хранить лишь один вектор -- сдвиг куба в пространстве:

```rust
#[repr(C)]
#[derive(Clone, Copy, bytemuck::Pod, bytemuck::Zeroable)]
pub struct Instance {
    pub pos: [f32; 3],
}
```

Это позволяет значительно сэкономить память и ускорить отрисовку. Можно реализовать формирование
буфера инстансов, позиции которых, применённые к кубам, сформируют объёмную фамилию.

```rust
pub fn make_surname_instances() -> Vec<Instance> {
    let matrix = &[
        b"# # #                      ",
        b"# # #                      ",
        b"# # # ### ##### # # ### ###",
        b"# # # #   # # # # # #   # #",
        b"# # # ### ##### ### ### ###",
        b"# # # #     #   # # #   #  ",
        b"##### ###   #   # # ### #  ",
    ];

    let w = matrix[0].len() as f32;
    let h = matrix.len() as f32;

    #[rustfmt::skip]
    let mut instances = Vec::new();

    for (y, row) in matrix.iter().enumerate() {
        for (x, elem) in row.iter().enumerate() {
            match elem {
                b' ' => {}
                b'#' => {
                    let x = x as f32 * 2.0;
                    let y = y as f32 * 2.0;
                    instances.push(Instance {
                        pos: [x - w, h - y, 0.0],
                    });
                }
                _ => unreachable!(),
            }
        }
    }

    instances
}
```

== Z-буфер

При текущей реализации явно заметен весьма неприятный эффект -- задние грани куба, которые не должны
быть видны, отрисовываются поверх передних. Это происходит потому, что видеокарте совершенно не
важно, в каком порядке отрисовывать примитивы. Для решения этой проблемы в работу добавлен Z-буфер,
или "Текстура глубины" в терминологии WebGPU.

Для использования текстуры глубины сперва требуется её создать. Для начала следует сделать
структуру, хранящую в себе необходимые компоненты текстуры.

```rust
pub struct Texture {
    #[allow(unused)]
    pub texture: wgpu::Texture,
    pub view: wgpu::TextureView,
    pub sampler: wgpu::Sampler,
}
```

Теперь можно написать код для создания текстуры глубины:

```rust
impl Texture {
    pub const DEPTH_FORMAT: TextureFormat = TextureFormat::Depth32Float;

    pub fn create_depth_texture(width: u32, height: u32, device: &Device) -> Self {
        let texture = device.create_texture(&TextureDescriptor {
            label: Some("Depth Texture"),
            size: Extent3d {
                width,
                height,
                depth_or_array_layers: 1,
            },
            mip_level_count: 1,
            sample_count: 1,
            dimension: TextureDimension::D2,
            format: Self::DEPTH_FORMAT,
            usage: TextureUsages::RENDER_ATTACHMENT | TextureUsages::TEXTURE_BINDING,
            view_formats: &[],
        });

        let view = texture.create_view(&TextureViewDescriptor::default());

        let sampler = device.create_sampler(&SamplerDescriptor {
            address_mode_u: AddressMode::ClampToEdge,
            address_mode_v: AddressMode::ClampToEdge,
            address_mode_w: AddressMode::ClampToEdge,
            mag_filter: FilterMode::Linear,
            min_filter: FilterMode::Linear,
            mipmap_filter: FilterMode::Nearest,
            lod_min_clamp: 0.0,
            lod_max_clamp: 100.0,
            compare: Some(CompareFunction::LessEqual),
            ..Default::default()
        });

        Self {
            texture,
            view,
            sampler,
        }
    }
}
```

Остаётся лишь указать правильные настройки для RenderPipeline и RenderPass. Настройки depth_stencil
у пайплайн примут следующий вид:

```rust
depth_stencil: Some(DepthStencilState {
    format: texture::Texture::DEPTH_FORMAT,
    depth_write_enabled: true,
    depth_compare: CompareFunction::Less,
    stencil: StencilState::default(),
    bias: DepthBiasState::default(),
}),
```

А при создании RenderPass следует добавить приложение depth_stencil_attachment:

```rust
depth_stencil_attachment: Some(wgpu::RenderPassDepthStencilAttachment {
    view: &depth_texture.view,
    depth_ops: Some(wgpu::Operations {
        load: wgpu::LoadOp::Clear(1.0),
        store: wgpu::StoreOp::Store,
    }),
    stencil_ops: None,
}),
```

== Диффузное освещение

Как было показано ранее, для каждой вершины куба в буфере хранится её нормаль. Это позволяет понять,
под каким углом свет будет падать на поверхность, формируемую данной вершиной. Уровень освещения
напрямую зависит от этого угла. Эта зависимость в расчёте выражается в виде скалярного произведения
нормали и вектора направления света. Это можно рассчитать во фрагментном шейдере, благодаря чему и
получится эффект диффузного освещения.

```wgsl
@fragment
fn fs_main(
    in: VertexOutput,
) -> @location(0) vec4<f32> {
    let basecolor = vec4<f32>(1.0);

    let light_dir = normalize(light.position - in.world_position);

    let diffuse_strength = max(dot(in.normal, light_dir), 0.0);
    let diffuse_color = light.color * diffuse_strength;

    let ambient = 0.1;
    let light = diffuse_color + ambient;

    return vec4<f32>(basecolor.xyz * light, basecolor.w);
}
```

== Наложение текстуры

Наложение текстуры в WebGPU выполняется достаточно просто. В данной работе применена текстура,
показанная на рисунке~@fig-texture.

#figure(
  caption: "Текстура ткани в сетку",
  image("./res/fabric_basecolor.png", width: 40%),
) <fig-texture>

Первым делом требуется загрузить текстуру в буфер видеопамяти. Для этого в блоке реализации ранее
созданной структуры Texture реализована ассоциированная функция.

```rust
pub fn from_bytes(bytes: &[u8], ctx: &WgpuContext) -> anyhow::Result<Self> {
    let image = image::load_from_memory(bytes)?.to_rgba8();

    let dimensions = image.dimensions();
    let size = Extent3d {
        width: dimensions.0,
        height: dimensions.1,
        depth_or_array_layers: 1,
    };

    let texture = ctx.device.create_texture(&TextureDescriptor {
        label: Some("Fabric Basecolor"),
        size,
        mip_level_count: 1,
        sample_count: 1,
        dimension: TextureDimension::D2,
        format: TextureFormat::Rgba8UnormSrgb,
        usage: TextureUsages::TEXTURE_BINDING
            | TextureUsages::COPY_DST
            | TextureUsages::RENDER_ATTACHMENT,
        view_formats: &[],
    });

    ctx.queue.write_texture(
        wgpu::ImageCopyTextureBase {
            texture: &texture,
            mip_level: 0,
            origin: wgpu::Origin3d::ZERO,
            aspect: wgpu::TextureAspect::All,
        },
        &image,
        wgpu::ImageDataLayout {
            offset: 0,
            bytes_per_row: Some(4 * dimensions.0),
            rows_per_image: Some(dimensions.1),
        },
        size,
    );

    let view = texture.create_view(&TextureViewDescriptor::default());
    let sampler = ctx.device.create_sampler(&SamplerDescriptor {
        address_mode_u: AddressMode::Repeat,
        address_mode_v: AddressMode::Repeat,
        address_mode_w: AddressMode::Repeat,
        mag_filter: FilterMode::Linear,
        min_filter: FilterMode::Linear,
        mipmap_filter: FilterMode::Nearest,
        ..Default::default()
    });

    Ok(Self {
        texture,
        view,
        sampler,
    })
}
```

После привязки текстуры она становится доступной в шейдере. Функция textureSample позволяет получить
отдельный фрагмент текстуры для указанных координат. Полный код шейдера с учётом инстанциирования,
освещения и текстурирования представлен далее:

#code-file(read("./src/shader.wgsl"), name: "shader.wgsl")

== Демонстрация работы приложения

#figure(
  caption: "Демонстрация работы приложения",
  grid(
    columns: 2,
    gutter: 1em,
    image("./assets/demo-1.png"), image("./assets/demo-2.png"),
  ),
)

== Вывод

Были получены практические и теоретические навыки реализации трёхмерных сцен на WebGPU. Были
реализованы механизм камеры, Z-сортировка фрагментов, инстанциирование, диффузное освещение и
текстурирование.

#appendixes[
  = Исходный текст программы

  #code-file(read("./src/main.rs"), name: "main.rs")
  #code-file(read("./src/lib.rs"), name: "lib.rs")
  #code-file(read("./src/app.rs"), name: "app.rs")
  #code-file(read("./src/render.rs"), name: "render.rs")
  #code-file(read("./src/camera.rs"), name: "camera.rs")
  #code-file(read("./src/instance.rs"), name: "instance.rs")
  #code-file(read("./src/model.rs"), name: "model.rs")
  #code-file(read("./src/material.rs"), name: "material.rs")
  #code-file(read("./src/texture.rs"), name: "texture.rs")
  #code-file(read("./src/light.rs"), name: "light.rs")
  #code-file(read("./src/color.rs"), name: "color.rs")
  #code-file(read("./src/light.wgsl"), name: "light.wgsl")
]
