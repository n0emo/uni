ФЕДЕРАЛЬНОЕ АГЕНСТВО ЖЕЛЕЗНОДОРОЖНОГО ТРАНСПОРТА

Федеральное государственное бюджетное образовательное учреждение высшего
образования

«ПЕТЕРБУРГСКИЙ ГОСУДАРСТВЕННЫЙ УНИВЕРСИТЕТ ПУТЕЙ СООБЩЕНИЯ Императора
Александра I»

Кафедра «Информационные и вычислительные системы»

Дисциплина «Компьютерная графика»

#strong[ОТЧЁТ]

#strong[ПО ЛАБОРАТОРНОЙ РАБОТЕ № 1]

#strong[«Вывод на экран графического примитива»]

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

Оценочный лист результатов ЛР № 1

Ф.И.О. студента: #emph[Шефнер А.]

Группа \_\_\_\_\_\_\_\_\_\_\_\_\_#emph[ИВБ-211]\_\_\_\_\_\_\_\_\_\_\_\_

Профессор кафедры

«Информационные и вычислительные

системы»#strong[ «\_\_» \_\_\_\_\_\_\_\_\_\_2024 г. Проурзин О.В. ]

#strong[Цель]

Получить теоретические и практические навыки работы по базовой работе с
API WebGPU и выводу на экран графических примитивов.

#strong[Задание]

Вывести на экран свою фамилию и инициалы, состоящие из графических
примитивов (линии, точки, прямоугольники).

#strong[Введение]

Несмотря на то, что изначально WebGPU предназначался для работы в
браузере и использованию на языках программирования
JavaScript/TypeScript, с ним вполне можно работать на системных языках
общего назначения, таких как C++ или Rust и выполнять иинструкции как в
браузере, так и в нативном приложении. Поддержку таких языков в браузере
позволяет обеспечить #strong[WebAssembly] (WASM) -- это современный
“портативный” ассемблер, или #emph[байт-код], выполняемый движком
браузера. На сегодяшний день наиболее полную поддержку WASM предлагает
#strong[LLVM] и компиляторы на его базе (например Clang для C++ или
rustc). Более подробно эти моменты будут описаны в курсовом проекте.

Для дальнейшей реализации всех работ были выбраны #strong[Rust] и
#strong[wgpu]. Rust является статически типизированным системным языком
общего назначения. Он имеет множество сходств с С++:

- - Компиляция в нативный код обеспечивает высокую производительность
  - Достаточно низкоуровневый для разработки операционных системны
  - Достаточно высокоуровневый для разработки пользовательских программ
    любой сложности
  - Автоматическое управление памятью посредством RAII

Но есть и различия между этими языками:

- - ООП обеспечивается не классами и наследованием, а структурами и
    типажами
  - Вместо исключений используется Result -- способ вернуть ошибку в
    качестве результата выполнения функции
  - Полностью безопасный, но допускающий возможность явно использовать
    небезопасный код

Выбор Rust значительно облегчит организацию работы графических
приложений не меняя уровень абстракции. В свою очередь wgpu --
реализация WebGPU, используемая в Firefox и Servo и так же написанная на
Rust. И хотя она имеет полноценные привязки для языка С, для первого
качество API библиотеки выше. wgpu позволяет компилировать программу как
в WASM для запуска в браузере, так и в нативный код.

#strong[Ход работы]

Перед тем, как вывести на экран фамилию из примитивов, необходимо её
составить. В данной работе в качестве “строительного материала” выбраны
треугольники. В этом случае необходимо создать массив вершин, по 3
вершины на каждый треугольник. В отличие от OpenGL, WebGPU не
предоставляет никаких способов “просто” загрузить вершины в видеокарту.
Первым делом необходимо самому описать что такое вершина. Для этого
объявлена #emph[структура]:

\#\[repr(C)\]

\#\[derive(Clone, Copy, bytemuck::Pod, bytemuck::Zeroable)\]

pub struct Vertex {

pub pos: \[f32; 3\],

pub col: \[f32; 3\],

}

В этой структуре определено 2 поля: позиция и цвет вершины,
представляющие из себя вектор из трех элементов f32. Обратите внимание,
что тип \[f32; 3\] соответствует типу std::array\<float, 3\> из C++.
Теперь требуется описать для WebGPU как такая структура располагается в
памяти, поскольку видеокарта ничего не знает про структуры Rust. Это
представлено в #emph[блоке реализации] Vertex:

impl Vertex {

const ATTRIBUTES: &\'static \[VertexAttribute\] =

&wgpu::vertex\_attr\_array!\[0 =\> Float32x3, 1 =\> Float32x3\];

pub fn layout() -\> VertexBufferLayout\<\'static\> {

VertexBufferLayout {

array\_stride: mem::size\_of::\<Vertex\>() as wgpu::BufferAddress,

step\_mode: VertexStepMode::Vertex,

attributes: Self::ATTRIBUTES,

}

}

}

Обратите внимание, что функция-член структуры layout (в Rust это
именуется #emph[методом]) не имеет никаких параметров, в том числе
неявных (как this в С++). Поэтому layout является #emph[ассоциированной
функцией] Vertex.

Теперь, когда существует представление вершин для видеокарты, можно
составить массив таких вершин для отрисовки. Для простоты в данной
работе он будет храниться в статической области памяти в контейнере Vec
-- прямом аналоге std::vector из C++. Поскольку #emph[безопасный] Rust
запрещает глобальные переменные, и при этом Vec не является константным,
для инициализации массива вершин используется lazy\_static. Он позволяет
инициализировать статические константы во время выполнения программы при
первом обращении к ним.

lazy\_static! {

pub static ref VERTICES: Vec\<Vertex\> = make\_vertices();

}

Для инициализации используется функция make\_vertices, её реализация
представлена в следующем листинге:

fn make\_vertices() -\> Vec\<Vertex\> {

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

let xsize = 1.9 / w;

let ysize = 1.4 / h;

let mut vertices = Vec::\<Vertex\>::new();

for (y, row) in matrix.iter().enumerate() {

for (x, elem) in row.iter().enumerate() {

match elem {

b\' \' =\> {}

b\'\#\' =\> {

let x = (x as f32 + 1.0) \* xsize - 1.025;

let y = 0.65 - (y as f32 + 1.0) \* ysize;

let col: \[f32; 3\] = \[0.9, 0.1, 0.2\];

let top\_right = Vertex {

pos: \[x + xsize, y + ysize, 0.0\],

col,

};

let top\_left = Vertex {

pos: \[x, y + ysize, 0.0\],

col,

};

let bottom\_left = Vertex {

pos: \[x, y, 0.0\],

col,

};

let bottom\_right = Vertex {

pos: \[x + xsize, y, 0.0\],

col,

};

vertices.extend(&\[

top\_right,

top\_left,

bottom\_left,

top\_right,

bottom\_left,

bottom\_right,

\])

}

\_ =\> unreachable!(),

}

}

}

vertices

}

В данной реализации использован не самый эффективный способ хранения
вершин, но зато позволяющий значительно ускорить время разработки
графического изображения. В функции составлена #emph[BitMap] матрица,
определяющая изображение, и далее программным образом на основе её
содержания добавляются вершины -- там, где матрица “закрашена”, то есть
поставлен знак “\#”.

Теперь, когда есть массив вершин, можно начать работу с WebGPU. Для
данной и последующих работ была создана абстракция создания приложения в
лице типажа framework::Application. Для его реализации необходимо
реализовать #emph[методы] init и render, котоые будут инициализировать
структуру и рендерить изображение соответственно. Прямо сейчас нет
никакой необходимости в полях структуры или init, поэтому сразу будет
представлен render. Первым делом следуюет попробовать вывести на экран
сплошной цвет. Для этого необходимо создать #emph[Render Pass]:

fn render(

&mut self,

view: &TextureView,

WgpuContext {

instance: \_,

adapter: \_,

device,

queue,

}: &WgpuContext,

) {

let mut encoder =
device.create\_command\_encoder(&CommandEncoderDescriptor {

label: Some(\"Render Encoder\"),

});

let mut rpass = encoder.begin\_render\_pass(&RenderPassDescriptor {

label: Some(\"Render Pass\"),

color\_attachments: &\[Some(wgpu::RenderPassColorAttachment {

view,

resolve\_target: None,

ops: Operations {

load: wgpu::LoadOp::Clear(wgpu::Color {

r: 0.1,

g: 0.1,

b: 0.1,

a: 1.0,

}),

store: wgpu::StoreOp::Store,

},

})\],

depth\_stencil\_attachment: None,

timestamp\_writes: None,

occlusion\_query\_set: None,

});

drop(rpass);

queue.submit(std::iter::once(encoder.finish()));

}

Процесс создания Render Pass во многом похож на аналогичный процесс из
графического API #strong[Metal] от Apple. Необходимо создать
#emph[Command Encoder], который будет кодировать команды, составленные
на процессоре, в инструкции для видеокарты. Далее с помощью энкодера
можно создать и сам Render Pass. В представленной выше функции создаётся
Render Pass с одной операцией -- очисткой поверхности сплошным цветом.
После завершения работы ним его необходимо освободить, что запишет
финальный вариант рендер пасса в энкодер. Для этого используется функция
drop, аналогичная ключевому слову delete из С++. Она вызовет
#emph[деструктор] структуры и освободит память. В конце необходимо
загрузить полученный набор команд графического процессора в очередь
команд. Таким образом можно наконец увидеть первое изображение (см. рис.
1)

#box(image("lab-1/assets/Pictures/1000000100000FE000000A40B432C21E.png", height: 4.2744in, width: 6.6209in))

Рисунок 1 -- окно браузера с графической поверхностью, на которую
выведен сплошной серый цвет.

Теперь, когда есть Render Pass, всё ещё нет возможности наконец вывести
вершины на экран. Необходимо написать #emph[шейдер] -- мини-программу,
выполняемую графическим процессором. Для WebGPU наиболее
предпочтительным языком написания шейдеров является #strong[WGSL]. Код
шейдера представлен в следующем листинге:

struct Vertex {

\@location(0) pos: vec3\<f32\>,

\@location(1) col: vec3\<f32\>,

}

struct VertexOutput {

\@builtin(position) pos: vec4\<f32\>,

\@location(1) color: vec3\<f32\>,

};

\@vertex

fn vs\_main(

vertex: Vertex,

) -\> VertexOutput {

var out: VertexOutput;

out.pos = vec4\<f32\>(vertex.pos, 1.0);

out.color = vertex.col;

return out;

}

\@fragment

fn fs\_main(

in: VertexOutput

) -\> \@location(0) vec4\<f32\> {

let x = in.color.x \* (1.0 - 0.35 \* sin(0.01 \* in.pos.x / in.pos.w));

let y = in.color.y \* (1.0 - 0.35 \* cos(0.02 \* in.pos.y / in.pos.w));

let z = in.color.z;

let color = vec3\<f32\>(x, y, z);

return vec4\<f32\>(color, 1.0);

}

Синтаксис WGSL во многом похож на синтаксис языка Rust. В данном шейдере
есть 2 входные точки -- #strong[vs\_main] и #strong[fs\_main]. Они
являются входными точками #emph[вершинного] и #emph[фрагментного]
шейдеров соответственно. Первый говорит куда расположить вершину на
экране, а второй -- какого цвета будет каждый отдельный пиксель в
пределах фигуры. Для более интересного оттенка цвета красный и зелёный
каналы цвета домножаются на функцию, зависящую от координат фрагмента.

Теперь можно загрузить шейдер и создать #emph[Render Pipeline] и
#emph[вершинный буфер]. Для этого необходимо добавить поля для хранения
пайплайн и ссылки на буфер видеокарты в структуре Application.

pub struct Application {

pipeline: RenderPipeline,

vertex\_buf: wgpu::Buffer,

}

А также реализовать ассоциированную функцию типажа
framework::Application -- init.

fn init(

config: &SurfaceConfiguration,

WgpuContext {

instance: \_,

adapter: \_,

device,

queue: \_,

}: &WgpuContext,

) -\> Self {

let shader =
device.create\_shader\_module(include\_wgsl!(\"shader.wgsl\"));

let pipeline = device.create\_render\_pipeline(&RenderPipelineDescriptor
{

label: Some(\"Render Pipeline\"),

layout: Some(

&device.create\_pipeline\_layout(&wgpu::PipelineLayoutDescriptor {

label: Some(\"Pipeline Layout\"),

bind\_group\_layouts: &\[\],

push\_constant\_ranges: &\[\],

}),

),

vertex: wgpu::VertexState {

module: &shader,

entry\_point: Some(\"vs\_main\"),

buffers: &\[Vertex::layout()\],

compilation\_options: PipelineCompilationOptions::default(),

},

fragment: Some(wgpu::FragmentState {

module: &shader,

entry\_point: Some(\"fs\_main\"),

compilation\_options: PipelineCompilationOptions::default(),

targets: &\[Some(wgpu::ColorTargetState {

format: config.view\_formats\[0\],

blend: Some(wgpu::BlendState::ALPHA\_BLENDING),

write\_mask: wgpu::ColorWrites::ALL,

})\],

}),

primitive: PrimitiveState {

topology: wgpu::PrimitiveTopology::TriangleList,

strip\_index\_format: None,

front\_face: wgpu::FrontFace::Ccw,

cull\_mode: Some(wgpu::Face::Back),

polygon\_mode: wgpu::PolygonMode::Fill,

unclipped\_depth: false,

conservative: false,

},

multisample: MultisampleState {

count: 1,

mask: !0,

alpha\_to\_coverage\_enabled: false,

},

depth\_stencil: None,

multiview: None,

cache: None,

});

let vertex\_buf = device.create\_buffer\_init(&BufferInitDescriptor {

label: Some(\"Surname Vertex Buffer\"),

contents: bytemuck::cast\_slice(&VERTICES),

usage: wgpu::BufferUsages::VERTEX,

});

Self {

pipeline,

vertex\_buf,

}

}

Всё, что остаёся -- в методе render добавить вызов функций установки
пайплайн и вершинного буфера и отрисовки вершин перед вызовом
drop(rpass).

rpass.set\_pipeline(&self.pipeline);

rpass.set\_vertex\_buffer(0, self.vertex\_buf.slice(..));

let len = VERTICES.len() as u32;

rpass.draw(0..len, 0..1);

Наконец на рисунке 2 можно увидеть результат отрисовки вершин.

#box(image("lab-1/assets/Pictures/1000000100000FE000000A40854C00C8.png", height: 4.2744in, width: 6.6209in))

Рисунок 2 -- демонстрация вывода фамилии с помощью графических
примитивов -- треугольников.

Как было сказано ранее, приложение может быть скомпилировано в нативный
код (см. рис. 3) Более подробно как это сделано будет описано в курсовом
проекте.

#box(image("lab-1/assets/Pictures/1000000100000720000005C842776A01.png", height: 5.3717in, width: 6.6209in))

Рисунок 3 -- демонстрация работы нативного приложения

#strong[Вывод]

В ходе работы были приобретены теоретические и практические навыки по
базовой работе с API WebGPU и выводу на экран графических примитивов. В
результате разработана программа, отрисосывающая фамилию автора с
помощью графического процессора.
