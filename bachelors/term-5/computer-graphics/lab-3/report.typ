ФЕДЕРАЛЬНОЕ АГЕНСТВО ЖЕЛЕЗНОДОРОЖНОГО ТРАНСПОРТА

Федеральное государственное бюджетное образовательное учреждение высшего
образования

«ПЕТЕРБУРГСКИЙ ГОСУДАРСТВЕННЫЙ УНИВЕРСИТЕТ ПУТЕЙ СООБЩЕНИЯ Императора
Александра I»

Кафедра «Информационные и вычислительные системы»

Дисциплина «Компьютерная графика»

#strong[ОТЧЁТ]

#strong[ПО ЛАБОРАТОРНЫМ РАБОТАМ № 3-5]

#strong[«Реализация динамической трёхмерной сцены»]

#figure(
  align(center)[#table(
    columns: 2,
    align: (auto,auto,),
    [Выполнил студент

    Факультет: АИТ

    Группа: ИВБ-211

    ], [Шефнер А.],
    [Проверил:

    Доцент кафедры

    «Информационные и вычислительные

    системы

    ], [Проурзин О.В.],
  )]
  , kind: table
  )

#strong[Санкт-Петербург]

#strong[2024]

Оценочный лист результатов ЛР №3-5

Ф.И.О. студента: #emph[Шефнер А.]

Группа \_\_\_\_\_\_\_\_\_\_\_\_\_#emph[ИВБ-211]\_\_\_\_\_\_\_\_\_\_\_\_

Профессор кафедры

«Информационные и вычислительные

системы»#strong[ «\_\_» \_\_\_\_\_\_\_\_\_\_2024 г. Проурзин О.В. ]

#strong[Цель]

Получить теоретические и практические навыки работы по базовой работе с
трёхмерными сценами в WebGPU.

#strong[Задание]

Вывести на экран свои инициалы в виде объемного изображения#strong[,
]которое должно перемещаться по экрану. Добавить эффект освещенной
поверхности, реализующей диффузное (зеркальное) отражение света.
Реализовать наложение текстур на поверхность объекта.

#strong[Введение]

В данной работе был реализован механизм камеры для возможности просмотра
сцены с разных углов (и тем самым перемещать изображение по экрану).
Было применено инстанциирование для формирования целой сцены из
множества кубов. В программу добавлен Z-буфер для автоматической
сортировки фрагментов по глубине. На языке шейдеров WGSL было
реализовано диффузное освещение. В память была загружена текстура и с
помощью шейдера помещена на сцену. По каждому аспекту выполнения работы
представлен отдельный раздел.

#strong[Камера]

Камера в данной работе представляет из себя классическую трёхмерную
камеру. Каждый кадр на основе её параметров формируется проекционная
матрица, которая далее записывается в буфер видеопамяти и доступна в
шейдере. Для математических расчётов используется библиотека cgmath,
которая расситана на систему координат OpenGL, поэтому требуется
дополнительное преобразование матрицы в формат, подходящий для WebGPU.

pub struct CameraParams {

pub eye: Point3\<f32\>,

pub target: Point3\<f32\>,

pub up: Vector3\<f32\>,

pub fovy: Deg\<f32\>,

pub aspect: f32,

pub znear: f32,

pub zfar: f32,

}

impl CameraParams {

\#\[rustfmt::skip\]

pub const OPENGL\_TO\_WGPU\_MATRIX: Matrix4\<f32\> = Matrix4::new(

1.0, 0.0, 0.0, 0.0,

0.0, 1.0, 0.0, 0.0,

0.0, 0.0, 0.5, 0.5,

0.0, 0.0, 0.0, 1.0,

);

pub fn compute\_view\_projection\_matrix(&self) -\> \[\[f32; 4\]; 4\] {

let view = Matrix4::look\_at\_rh(self.eye, self.target, self.up);

let proj = perspective(self.fovy, self.aspect, self.znear, self.zfar);

let matrix = Self::OPENGL\_TO\_WGPU\_MATRIX \* proj \* view;

matrix.into()

}

}

Далее камера используется в вершинном шейдере для вычисления позиции
вершины на экране.

\@vertex

fn vs\_main(

vertex: Vertex,

) -\> VertexOutput {

var out: VertexOutput;

out.pos = camera.view\_proj \* vec4\<f32\>(vertex.pos, 1.0);

return out;

}

#strong[Инстанциирование]

Загружать в буфер видеопамяти вершины каждого куба, который необходимо
нарисовать, весьма расточительно. В данной работе для каждого куба
меняется лишь их положение в пространстве без учёта вращения. Вместо 24
вершин с координатой и (для следующих пунктов работы) координаты
текстуры и вектора нормали, достаточно хранить лишь один вектор -- сдвиг
куба в пространстве

\#\[repr(C)\]

\#\[derive(Clone, Copy, bytemuck::Pod, bytemuck::Zeroable)\]

pub struct Instance {

pub pos: \[f32; 3\],

}

Это позволяет значительно сэкономить память и ускорить отрисовку. Можно
реализовать формирование буфера инстансов, позиции которых, применённые
к кубам, сформируют объёмную фамилию.

pub fn make\_surname\_instances() -\> Vec\<Instance\> {

let matrix = &\[

b\"\# \# \# \",

b\"\# \# \# \",

b\"\# \# \# \#\#\# \#\#\#\#\# \# \# \#\#\# \#\#\#\",

b\"\# \# \# \# \# \# \# \# \# \# \# \#\",

b\"\# \# \# \#\#\# \#\#\#\#\# \#\#\# \#\#\# \#\#\#\",

b\"\# \# \# \# \# \# \# \# \# \",

b\"\#\#\#\#\# \#\#\# \# \# \# \#\#\# \# \",

\];

let w = matrix\[0\].len() as f32;

let h = matrix.len() as f32;

\#\[rustfmt::skip\]

let mut instances = Vec::new();

for (y, row) in matrix.iter().enumerate() {

for (x, elem) in row.iter().enumerate() {

match elem {

b\' \' =\> {}

b\'\#\' =\> {

let x = x as f32 \* 2.0;

let y = y as f32 \* 2.0;

instances.push(Instance {

pos: \[x - w, h - y, 0.0\],

});

}

\_ =\> unreachable!(),

}

}

}

instances

}

#strong[Z-буфер]

При текущей реализации явно заметен весьма неприятный \ эффект -- задние
грани куба, которые не должны быть видны, отрисовываются поверх
передних. Это происходит потому что видеокарте совершенно не важно в
каком порядке отрисовывать примитивы. Для решения этой приблемы в работу
добавлен Z-буфер, или “Текстура глубины” в терминологии WebGPU.

Для использования текстуры глубины сперва требуется её создать. Для
начала следует сделать структуру, хранящую в себе необходимые компоненты
структуры.

pub struct Texture {

\#\[allow(unused)\]

pub texture: wgpu::Texture,

pub view: wgpu::TextureView,

pub sampler: wgpu::Sampler,

}

Теперь можно написать код для создании текстуры глубины

impl Texture {

pub const DEPTH\_FORMAT: TextureFormat = TextureFormat::Depth32Float;

pub fn create\_depth\_texture(width: u32, height: u32, device: &Device)
\-\> Self {

let texture = device.create\_texture(&TextureDescriptor {

label: Some(\"Depth Texture\"),

size: Extent3d {

width,

height,

depth\_or\_array\_layers: 1,

},

mip\_level\_count: 1,

sample\_count: 1,

dimension: TextureDimension::D2,

format: Self::DEPTH\_FORMAT,

usage: TextureUsages::RENDER\_ATTACHMENT |
TextureUsages::TEXTURE\_BINDING,

view\_formats: &\[\],

});

let view = texture.create\_view(&TextureViewDescriptor::default());

let sampler = device.create\_sampler(&SamplerDescriptor {

address\_mode\_u: AddressMode::ClampToEdge,

address\_mode\_v: AddressMode::ClampToEdge,

address\_mode\_w: AddressMode::ClampToEdge,

mag\_filter: FilterMode::Linear,

min\_filter: FilterMode::Linear,

mipmap\_filter: FilterMode::Nearest,

lod\_min\_clamp: 0.0,

lod\_max\_clamp: 100.0,

compare: Some(CompareFunction::LessEqual),

\..Default::default()

});

Self {

texture,

view,

sampler,

}

}

}

Остаётся лишь указать правильные настройки для RenderPipeline и
RenderPass. Настройки depth\_stencil у пайплайн примут следующий вид:

depth\_stencil: Some(DepthStencilState {

format: texture::Texture::DEPTH\_FORMAT,

depth\_write\_enabled: true,

depth\_compare: CompareFunction::Less,

stencil: StencilState::default(),

bias: DepthBiasState::default(),

}),

А при создании RenderPass следует добавить приложение
depth\_stencil\_attachment:

depth\_stencil\_attachment: Some(wgpu::RenderPassDepthStencilAttachment
{

view: &depth\_texture.view,

depth\_ops: Some(wgpu::Operations {

load: wgpu::LoadOp::Clear(1.0),

store: wgpu::StoreOp::Store,

}),

stencil\_ops: None,

}),

#strong[Диффузное освещение]

Как было показано ранее, для каждой вершины куба в буфере хранится её
нормаль. Это позволяет понять, под каким углом свет будет падать на
поверхность, формируемую данной вершиной. Уровень освещения напрямую
зависит от этого угла. Эта зависимость в рассчёте выражается в виде
скалярного произведения нормали и вектора направления света. Это можно
рассчитать во фрагментном шейдере, благодаря чему и получится эффект
диффузного освещения.

\@fragment

fn fs\_main(

in: VertexOutput,

) -\> \@location(0) vec4\<f32\> {

let basecolor = vec4\<f32\>(1.0);

let light\_dir = normalize(light.position - in.world\_pos);

let diffuse\_strength = max(dot(in.normal, light\_dir), 0.0);

let diffuse\_color = light.color \* diffuse\_strength;

let ambient = 0.1;

let light = diffuse\_color + ambient;

return vec4\<f32\>(basecolor.xyz \* light, basecolor.w);

}

#strong[Наложение текстуры]

Наложение текстуры в WebGPU выполняется достаточно просто. В данной
работе применена текстура, показанная на рисунке 1.

#box(image("lab-3/assets/Pictures/100000010000010000000100F204CDAA.png", height: 2.2882in, width: 2.2882in))

Рисунок 1 -- текстура ткани в сетку

Первым делом требуется загрузить текстуру в буфер видеопамяти. Для этого
в блоке реализации ранее созданной структуры Texture реализована
ассоциированная функция.

pub fn from\_bytes(bytes: &\[u8\], ctx: &WgpuContext) -\>
anyhow::Result\<Self\> {

let image = image::load\_from\_memory(bytes)?.to\_rgba8();

let dimensions = image.dimensions();

let size = Extent3d {

width: dimensions.0,

height: dimensions.1,

depth\_or\_array\_layers: 1,

};

let texture = ctx.device.create\_texture(&TextureDescriptor {

label: Some(\"Fabric Basecolor\"),

size,

mip\_level\_count: 1,

sample\_count: 1,

dimension: TextureDimension::D2,

format: TextureFormat::Rgba8UnormSrgb,

usage: TextureUsages::TEXTURE\_BINDING

| TextureUsages::COPY\_DST

| TextureUsages::RENDER\_ATTACHMENT,

view\_formats: &\[\],

});

ctx.queue.write\_texture(

wgpu::ImageCopyTextureBase {

texture: &texture,

mip\_level: 0,

origin: wgpu::Origin3d::ZERO,

aspect: wgpu::TextureAspect::All,

},

&image,

wgpu::ImageDataLayout {

offset: 0,

bytes\_per\_row: Some(4 \* dimensions.0),

rows\_per\_image: Some(dimensions.1),

},

size,

);

let view = texture.create\_view(&TextureViewDescriptor::default());

let sampler = ctx.device.create\_sampler(&SamplerDescriptor {

address\_mode\_u: AddressMode::Repeat,

address\_mode\_v: AddressMode::Repeat,

address\_mode\_w: AddressMode::Repeat,

mag\_filter: FilterMode::Linear,

min\_filter: FilterMode::Linear,

mipmap\_filter: FilterMode::Nearest,

\..Default::default()

});

Ok(Self {

texture,

view,

sampler,

})

}

После привязки структуры она становится доступной в шейдере. Функция
textureSample позволяет получить отдельный фрагмент структуры для
указанных координат. Полный код шейдера с учётом инстанциирования,
освещения и текстурирования представлен далее:

struct Vertex {

\@location(0) pos: vec3\<f32\>,

\@location(1) tex\_coords: vec2\<f32\>,

\@location(2) normal: vec3\<f32\>,

}

struct Instance {

\@location(3) pos: vec3\<f32\>,

}

struct VertexOutput {

\@builtin(position) pos: vec4\<f32\>,

\@location(0) tex\_coords: vec2\<f32\>,

\@location(1) world\_pos: vec3\<f32\>,

\@location(2) normal: vec3\<f32\>,

}

struct CameraUniform {

view\_proj: mat4x4\<f32\>,

}

struct Light {

position: vec3\<f32\>,

color: vec3\<f32\>,

}

\@group(0) \@binding(0)

var basecolor\_texture: texture\_2d\<f32\>;

\@group(0) \@binding(1)

var basecolor\_sampler: sampler;

\@group(1) \@binding(0)

var\<uniform\> camera: CameraUniform;

\@group(2) \@binding(0)

var\<uniform\> light: Light;

\@vertex

fn vs\_main(

vertex: Vertex,

instance: Instance,

) -\> VertexOutput {

var out: VertexOutput;

out.tex\_coords = vertex.tex\_coords;

out.world\_pos = vertex.pos + instance.pos;

out.pos = camera.view\_proj \* vec4\<f32\>(vertex.pos + instance.pos,
1.0);

out.normal = vertex.normal;

return out;

}

\@fragment

fn fs\_main(

in: VertexOutput,

) -\> \@location(0) vec4\<f32\> {

let basecolor = textureSample(basecolor\_texture, basecolor\_sampler,
in.tex\_coords);

let light\_dir = normalize(light.position - in.world\_pos);

let diffuse\_strength = max(dot(in.normal, light\_dir), 0.0);

let diffuse\_color = light.color \* diffuse\_strength;

let ambient = 0.1;

let light = diffuse\_color + ambient;

return vec4\<f32\>(basecolor.xyz \* light, basecolor.w);

}

#strong[Демонстрация работы приложения]

#box(image("lab-3/assets/Pictures/10000001000005E0000003E8D5ED3938.png", height: 4.3189in, width: 6.4957in))#box(image("lab-3/assets/Pictures/10000001000005E0000003E8B43E1CA8.png", height: 4.3189in, width: 6.4957in))

#strong[Вывод]

Были получены практические и теоретические навыки реализации трёхмерных
сцен на WebGPU. Были реализованы механизм камеры, \ Z-сортировка
фрагментов, инстанциирование, диффузное освещение и текстурирование.
