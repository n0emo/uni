#import "@preview/touying:0.7.4": *

== Особенности WASM

#v(1.5em)

#grid(
  columns: 2,
  row-gutter: 1em,
  column-gutter: 1em,
  fill: rgb(230, 240, 230),
  inset: 0.5em,
  [
    #align(center)[*WebAssembly*]
    - Портативный
    - Безопасный
    - Низкоуровневый
    - Эффективный
  ],
  [
    #align(center)[*WASI*]
    - Стандартизированный
    - Системный интерфейс \ (сеть, ФС, время)
    - Модель возможностей (capabilities)
  ],

  [
    #align(center)[*Компонентная модель*]
    - Канонический ABI
    - Сложные типы значений
    - Понятие мира (world)
    - Композиция компонентов
  ],
  [
    #align(center)[*WIT*]
    - Язык описания интерфейса (IDL)
    - Определяет миры и интерфейсы
    - Генерация привязок \ (wit-bindgen)
  ],
)
