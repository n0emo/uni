#import "../common.typ": *

#show: report.with(number: "2", title: "Использование стандартных объектов WebGPU")

== Цель работы

Получить теоретические и практические навыки работы по базовой работе с трёхмерными объектами в
WebGPU.

== Задание

Вывести на экран объект предметной области (локомотив, самолет, вертолет, автомобиль, ракета),
составленный из стандартных объемных объектов WebGPU. Позиционирование стандартных объектов
реализовать с использованием матричных функций.

== Введение

Поскольку сам по себе wgpu не предоставляет никаких стандартных примитивов, было принято решение
освоить формирование трёхмерных объектов самостоятельно. В качестве дополнительного задания выбрано
использование индексного буфера для отрисовки фигуры. В данной работе будет выведен на экран
повёрнутый цветной трёхмерный куб. Для осуществления математических расчётов в зависимости добавлена
библиотека cgmath.

== Ход работы

Для начала следует определить структуру куба, которая будет хранить в себе информацию о его вершинах
и индексах:

```rust
#[derive(Debug)]
pub struct Cube {
    pub vertices: Vec<Vertex>,
    pub indices: Vec<u16>,
}
```

Теперь можно создать функцию, которая будет формировать куб для отрисовки:

```rust
fn make_cube() -> Cube {
    todo!()
}
```

Оставим реализацию этой функции на потом. Она будет использована для формирования статического куба:

```rust
lazy_static! {
    pub static ref CUBE: Cube = make_cube();
}
```

Теперь необходимо обновить код отрисовки. Необходимо создать индексный буфер и установить его при
отрисовке. В методе инициализации приложения код формирования буферов изменён на следующий:

```rust
let vertex_buf = device.create_buffer_init(&BufferInitDescriptor {
    label: Some("3D Object Vertex Buffer"),
    contents: bytemuck::cast_slice(&CUBE.vertices),
    usage: wgpu::BufferUsages::VERTEX,
});

let index_buf = device.create_buffer_init(&BufferInitDescriptor {
    label: Some("3D Object Index Buffer"),
    contents: bytemuck::cast_slice(&CUBE.indices),
    usage: wgpu::BufferUsages::INDEX,
});

Self {
    pipeline,
    vertex_buf,
    index_buf,
}
```

А код отрисовки в методе render изменён следующим образом соответственно:

```rust
rpass.set_pipeline(&self.pipeline);
rpass.set_vertex_buffer(0, self.vertex_buf.slice(..));
rpass.set_index_buffer(self.index_buf.slice(..), wgpu::IndexFormat::Uint16);
let len = CUBE.indices.len() as u32;
rpass.draw_indexed(0..len, 0, 0..1);
```

Обратите внимание, что вместо draw используется draw_indexed, который принимает в себя диапазон
индексного (не вершинного!) буфера. Осталось лишь сформировать сам куб. Вернёмся в функцию make_cube
и первым делом сформируем массив из 8 вершин куба в виде векторов cgmath:

```rust
#[rustfmt::skip]
let vertices = [
    vec3(-1.0, -1.0, -1.0),
    vec3( 1.0, -1.0, -1.0),
    vec3(-1.0,  1.0, -1.0),
    vec3( 1.0,  1.0, -1.0),
    vec3(-1.0, -1.0,  1.0),
    vec3( 1.0, -1.0,  1.0),
    vec3(-1.0,  1.0,  1.0),
    vec3( 1.0,  1.0,  1.0),
]
.into_iter()
.map(|v| v * 0.2)
.map(|v| {
    Basis3::from_axis_angle(vec3(1.0, 1.0, 1.0).normalize(), Rad(PI * 0.2)).rotate_vector(v)
})
.map(|v| vec3(v.x, v.y, v.z.clamp(0.0, 1.0)));
```

В этом коде видим массив из 8 вершин и применение к нему трёх операций:

- Умножение векторов вершин на скаляр 0.2 для уменьшения куба.
- Вращение куба вокруг всех трёх осей на 0.2 Пи.
- Ограничение z-координаты каждой вершины в пределах $[0.0; 1.0]$, поскольку по умолчанию WebGPU
  рисует вершины только в этих пределах.

Следующим шагом было бы неплохо покрасить вершины и преобразовать их в структуры Vertex. Для этого
сформирован массив цветов также в виде векторов и использована операция функционального
программирования zip:

```rust
let colors = [
    vec3(1.0, 0.2, 0.2),
    vec3(0.2, 1.0, 0.2),
    vec3(0.2, 0.2, 1.0),
    vec3(1.0, 0.2, 1.0),
    vec3(1.0, 0.3, 0.2),
    vec3(1.0, 1.0, 0.5),
    vec3(0.4, 0.2, 1.0),
    vec3(0.5, 0.2, 0.5),
];

let vertices = vertices
    .zip(colors.into_iter().cycle())
    .map(|(v, c)| Vertex {
        pos: v.into(),
        col: c.into(),
    })
    .collect();
```

Последним действием будет формирование массива индексов. Обратите внимание, что каждую вершину
необходимо задавать против часовой стрелки, поскольку так указано в настройках Pipeline.

```rust
#[rustfmt::skip]
let indices = vec![
    0, 2, 1, 1, 2, 3, // front
    1, 3, 5, 5, 3, 7, // right
    4, 6, 0, 0, 6, 2, // left
    4, 5, 6, 6, 5, 7, // back
    0, 1, 4, 4, 1, 5, // bottom
    2, 6, 7, 7, 3, 2, // top
];
```

Остаётся вернуть из функции куб, составленный из его компонентов:

```rust
Cube { vertices, indices }
```

Теперь мы можем увидеть результат на экране, представленный на рисунке~@fig-cube.

#figure(
  caption: "Демонстрация работы приложения (трёхмерный куб)",
  image("./assets/result-cube.png", width: 90%),
) <fig-cube>

Пока не реализованы освещение и Z-сортировка, нагляднее будет увидеть куб, нарисованный линиями, а
не закрашенными треугольниками. Для этого необходимо запросить у адаптера устройство с функцией
POLYGON_MODE_LINE. Для этого добавлена реализация соответствующего метода типажа
framework::Application:

```rust
fn required_features() -> wgpu::Features {
    wgpu::Features::POLYGON_MODE_LINE
}
```

Также в настройки примитивов Pipeline необходимо установить режим отрисовки линий:

```rust
primitive: PrimitiveState {
    topology: wgpu::PrimitiveTopology::TriangleList,
    strip_index_format: None,
    front_face: wgpu::FrontFace::Ccw,
    cull_mode: Some(wgpu::Face::Back),
    polygon_mode: wgpu::PolygonMode::Line, // Отрисовка линий
    unclipped_depth: false,
    conservative: false,
},
```

Результат представлен на рисунке~@fig-wireframe. Обратите внимание, что отрисовку линий поддерживают
только нативные платформы, поэтому показан скриншот приложения для MacOS.

#figure(
  caption: "Демонстрация трёхмерного куба, отрисованного линиями",
  image("./assets/result-wireframe.png", width: 90%),
) <fig-wireframe>

== Вывод

В ходе работы были приобретены теоретические и практические навыки по базовой работе с трёхмерными
объектами в WebGPU. Было реализовано приложение, выводящее трёхмерный куб.

#appendixes[
  = Исходный текст программы

  #code-file(read("./src/main.rs"), name: "main.rs")
  #code-file(read("./src/lib.rs"), name: "lib.rs")
  #code-file(read("./src/model.rs"), name: "model.rs")
  #code-file(read("./src/app.rs"), name: "app.rs")
  #code-file(read("./src/shader.wgsl"), name: "shader.wgsl")
]
