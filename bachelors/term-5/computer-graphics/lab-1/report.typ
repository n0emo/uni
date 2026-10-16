#import "../common.typ": *

#show: report.with(number: "1", title: "Вывод на экран графического примитива")

== Цель работы

Получить теоретические и практические навыки работы по базовой работе с API WebGPU и выводу на экран
графических примитивов.

== Задание

Вывести на экран свою фамилию и инициалы, состоящие из графических примитивов (линии, точки,
прямоугольники).

== Введение

Несмотря на то, что изначально WebGPU предназначался для работы в браузере и использованию на языках
программирования JavaScript/TypeScript, с ним вполне можно работать на системных языках общего
назначения, таких как C++ или Rust и выполнять иинструкции как в браузере, так и в нативном
приложении. Поддержку таких языков в браузере позволяет обеспечить *WebAssembly* (WASM) -- это
современный "портативный" ассемблер, или _байт-код_, выполняемый движком браузера. На сегодяшний
день наиболее полную поддержку WASM предлагает *LLVM* и компиляторы на его базе (например Clang для
C++ или rustc). Более подробно эти моменты будут описаны в курсовом проекте.

Для дальнейшей реализации всех работ были выбраны *Rust* и *wgpu*. Rust является статически
типизированным системным языком общего назначения. Он имеет множество сходств с С++:

- Компиляция в нативный код обеспечивает высокую производительность
- Достаточно низкоуровневый для разработки операционных системны
- Достаточно высокоуровневый для разработки пользовательских программ любой сложности
- Автоматическое управление памятью посредством RAII

Но есть и различия между этими языками:

- ООП обеспечивается не классами и наследованием, а структурами и типажами
- Вместо исключений используется Result -- способ вернуть ошибку в качестве результата выполнения
  функции
- Полностью безопасный, но допускающий возможность явно использовать небезопасный код

Выбор Rust значительно облегчит организацию работы графических приложений не меняя уровень
абстракции. В свою очередь wgpu -- реализация WebGPU, используемая в Firefox и Servo и так же
написанная на Rust. И хотя она имеет полноценные привязки для языка С, для первого качество API
библиотеки выше. wgpu позволяет компилировать программу как в WASM для запуска в браузере, так и в
нативный код.

== Ход работы

Перед тем, как вывести на экран фамилию из примитивов, необходимо её составить. В данной работе в
качестве "строительного материала" выбраны треугольники. В этом случае необходимо создать массив
вершин, по 3 вершины на каждый треугольник. В отличие от OpenGL, WebGPU не предоставляет никаких
способов "просто" загрузить вершины в видеокарту. Первым делом необходимо самому описать что такое
вершина. Для этого объявлена _структура_:

```rust
#[repr(C)]
#[derive(Clone, Copy, bytemuck::Pod, bytemuck::Zeroable)]
pub struct Vertex {
    pub pos: [f32; 3],
    pub col: [f32; 3],
}
```

В этой структуре определено 2 поля: позиция и цвет вершины, представляющие из себя вектор из трех
элементов f32. Обратите внимание, что тип `[f32; 3]` соответствует типу `std::array<float, 3>` из
C++. Теперь требуется описать для WebGPU как такая структура располагается в памяти, поскольку
видеокарта ничего не знает про структуры Rust. Это представлено в _блоке реализации_ Vertex:

```rust
impl Vertex {
    const ATTRIBUTES: &'static [VertexAttribute] =
        &wgpu::vertex_attr_array![0 => Float32x3, 1 => Float32x3];

    pub fn layout() -> VertexBufferLayout<'static> {
        VertexBufferLayout {
            array_stride: mem::size_of::<Vertex>() as wgpu::BufferAddress,
            step_mode: VertexStepMode::Vertex,
            attributes: Self::ATTRIBUTES,
        }
    }
}
```

Обратите внимание, что функция-член структуры layout (в Rust это именуется _методом_) не имеет
никаких параметров, в том числе неявных (как this в С++). Поэтому layout является _ассоциированной
функцией_ Vertex.

Теперь, когда существует представление вершин для видеокарты, можно составить массив таких вершин
для отрисовки. Для простоты в данной работе он будет храниться в статической области памяти в
контейнере Vec -- прямом аналоге std::vector из C++. Поскольку _безопасный_ Rust запрещает
глобальные переменные, и при этом Vec не является константным, для инициализации массива вершин
используется lazy_static. Он позволяет инициализировать статические константы во время выполнения
программы при первом обращении к ним.

```rust
lazy_static! {
    pub static ref VERTICES: Vec<Vertex> = make_vertices();
}
```

Для инициализации используется функция make_vertices, её реализация представлена в следующем
листинге:

```rust
fn make_vertices() -> Vec<Vertex> {
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
    let xsize = 1.9 / w;
    let ysize = 1.4 / h;

    let mut vertices = Vec::<Vertex>::new();

    for (y, row) in matrix.iter().enumerate() {
        for (x, elem) in row.iter().enumerate() {
            match elem {
                b' ' => {}
                b'#' => {
                    let x = (x as f32 + 1.0) * xsize - 1.025;
                    let y = 0.65 - (y as f32 + 1.0) * ysize;
                    let col: [f32; 3] = [0.9, 0.1, 0.2];

                    let top_right = Vertex {
                        pos: [x + xsize, y + ysize, 0.0],
                        col,
                    };
                    let top_left = Vertex {
                        pos: [x, y + ysize, 0.0],
                        col,
                    };
                    let bottom_left = Vertex {
                        pos: [x, y, 0.0],
                        col,
                    };
                    let bottom_right = Vertex {
                        pos: [x + xsize, y, 0.0],
                        col,
                    };

                    vertices.extend(&[
                        top_right,
                        top_left,
                        bottom_left,
                        top_right,
                        bottom_left,
                        bottom_right,
                    ])
                }
                _ => unreachable!(),
            }
        }
    }

    vertices
}
```

В данной реализации использован не самый эффективный способ хранения вершин, но зато позволяющий
значительно ускорить время разработки графического изображения. В функции составлена _BitMap_
матрица, определяющая изображение, и далее программным образом на основе её содержания добавляются
вершины -- там, где матрица "закрашена", то есть поставлен знак "\#".

Теперь, когда есть массив вершин, можно начать работу с WebGPU. Для данной и последующих работ была
создана абстракция создания приложения в лице типажа framework::Application. Для его реализации
необходимо реализовать _методы_ init и render, котоые будут инициализировать структуру и рендерить
изображение соответственно. Прямо сейчас нет никакой необходимости в полях структуры или init,
поэтому сразу будет представлен render. Первым делом следуюет попробовать вывести на экран сплошной
цвет. Для этого необходимо создать _Render Pass_:

```rust
fn render(
    &mut self,
    view: &TextureView,
    _dt: f32,
    WgpuContext {
        instance: _,
        adapter: _,
        device,
        queue,
    }: &WgpuContext,
) {
    let mut encoder = device.create_command_encoder(&CommandEncoderDescriptor {
        label: Some("Render Encoder"),
    });

    let mut rpass = encoder.begin_render_pass(&RenderPassDescriptor {
        label: Some("Render Pass"),
        color_attachments: &[Some(wgpu::RenderPassColorAttachment {
            view,
            resolve_target: None,
            ops: Operations {
                load: wgpu::LoadOp::Clear(wgpu::Color {
                    r: 0.1,
                    g: 0.1,
                    b: 0.1,
                    a: 1.0,
                }),
                store: wgpu::StoreOp::Store,
            },
        })],
        depth_stencil_attachment: None,
        timestamp_writes: None,
        occlusion_query_set: None,
    });

    drop(rpass);

    queue.submit(std::iter::once(encoder.finish()));
}
```

Процесс создания Render Pass во многом похож на аналогичный процесс из графического API *Metal* от
Apple. Необходимо создать _Command Encoder_, который будет кодировать команды, составленные на
процессоре, в инструкции для видеокарты. Далее с помощью энкодера можно создать и сам Render Pass. В
представленной выше функции создаётся Render Pass с одной операцией -- очисткой поверхности сплошным
цветом. После завершения работы ним его необходимо освободить, что запишет финальный вариант рендер
пасса в энкодер. Для этого используется функция drop, аналогичная ключевому слову delete из С++. Она
вызовет _деструктор_ структуры и освободит память. В конце необходимо загрузить полученный набор
команд графического процессора в очередь команд. Таким образом можно наконец увидеть первое
изображение (см. рисунок~@fig-clear)

#figure(
  caption: "Окно браузера с графической поверхностью, на которую выведен сплошной серый цвет",
  image("./assets/clear-color.png", width: 90%),
) <fig-clear>

Теперь, когда есть Render Pass, всё ещё нет возможности наконец вывести вершины на экран. Необходимо
написать _шейдер_ -- мини-программу, выполняемую графическим процессором. Для WebGPU наиболее
предпочтительным языком написания шейдеров является *WGSL*. Код шейдера представлен в следующем
листинге:

#code-file(read("./src/shader.wgsl"), name: "shader.wgsl")

Синтаксис WGSL во многом похож на синтаксис языка Rust. В данном шейдере есть 2 входные точки --
*vs_main* и *fs_main*. Они являются входными точками _вершинного_ и _фрагментного_ шейдеров
соответственно. Первый говорит куда расположить вершину на экране, а второй -- какого цвета будет
каждый отдельный пиксель в пределах фигуры. Для более интересного оттенка цвета красный и зелёный
каналы цвета домножаются на функцию, зависящую от координат фрагмента.

Теперь можно загрузить шейдер и создать _Render Pipeline_ и _вершинный буфер_. Для этого необходимо
добавить поля для хранения пайплайн и ссылки на буфер видеокарты в структуре Application.

```rust
pub struct Application {
    pipeline: RenderPipeline,
    vertex_buf: wgpu::Buffer,
}
```

А также реализовать ассоциированную функцию типажа framework::Application -- init.

```rust
fn init(
    config: &SurfaceConfiguration,
    WgpuContext {
        instance: _,
        adapter: _,
        device,
        queue: _,
    }: &WgpuContext,
) -> Self {
    let shader = device.create_shader_module(include_wgsl!("shader.wgsl"));

    let pipeline = device.create_render_pipeline(&RenderPipelineDescriptor {
        label: Some("Render Pipeline"),
        layout: Some(
            &device.create_pipeline_layout(&wgpu::PipelineLayoutDescriptor {
                label: Some("Pipeline Layout"),
                bind_group_layouts: &[],
                push_constant_ranges: &[],
            }),
        ),
        vertex: wgpu::VertexState {
            module: &shader,
            entry_point: Some("vs_main"),
            buffers: &[Vertex::layout()],
            compilation_options: PipelineCompilationOptions::default(),
        },
        fragment: Some(wgpu::FragmentState {
            module: &shader,
            entry_point: Some("fs_main"),
            compilation_options: PipelineCompilationOptions::default(),
            targets: &[Some(wgpu::ColorTargetState {
                format: config.view_formats[0],
                blend: Some(wgpu::BlendState::ALPHA_BLENDING),
                write_mask: wgpu::ColorWrites::ALL,
            })],
        }),
        primitive: PrimitiveState {
            topology: wgpu::PrimitiveTopology::TriangleList,
            strip_index_format: None,
            front_face: wgpu::FrontFace::Ccw,
            cull_mode: Some(wgpu::Face::Back),
            polygon_mode: wgpu::PolygonMode::Fill,
            unclipped_depth: false,
            conservative: false,
        },
        multisample: MultisampleState {
            count: 1,
            mask: !0,
            alpha_to_coverage_enabled: false,
        },
        depth_stencil: None,
        multiview: None,
        cache: None,
    });

    let vertex_buf = device.create_buffer_init(&BufferInitDescriptor {
        label: Some("Surname Vertex Buffer"),
        contents: bytemuck::cast_slice(&VERTICES),
        usage: wgpu::BufferUsages::VERTEX,
    });

    Self {
        pipeline,
        vertex_buf,
    }
}
```

Всё, что остаёся -- в методе render добавить вызов функций установки пайплайн и вершинного буфера и
отрисовки вершин перед вызовом drop(rpass).

```rust
rpass.set_pipeline(&self.pipeline);
rpass.set_vertex_buffer(0, self.vertex_buf.slice(..));
let len = VERTICES.len() as u32;
rpass.draw(0..len, 0..1);
```

Наконец на рисунке~@fig-result можно увидеть результат отрисовки вершин.

#figure(
  caption: "Демонстрация вывода фамилии с помощью графических примитивов – треугольников",
  image("./assets/result-web.png", width: 90%),
) <fig-result>

Как было сказано ранее, приложение может быть скомпилировано в нативный код (см.
рисунок~@fig-native) Более подробно как это сделано будет описано в курсовом проекте.

#figure(
  caption: "Демонстрация работы нативного приложения",
  image("./assets/result-native.png", width: 90%),
) <fig-native>

== Вывод

В ходе работы были приобретены теоретические и практические навыки по базовой работе с API WebGPU и
выводу на экран графических примитивов. В результате разработана программа, отрисосывающая фамилию
автора с помощью графического процессора.

#appendixes[
  = Исходный текст программы

  #code-file(read("./src/main.rs"), name: "main.rs")
  #code-file(read("./src/lib.rs"), name: "lib.rs")
  #code-file(read("./src/model.rs"), name: "model.rs")
  #code-file(read("./src/app.rs"), name: "app.rs")
]
