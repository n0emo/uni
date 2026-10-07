#import "../common.typ": *

#let (render,) = notebook(
  path("lab.ipynb"),
  handlers: (path: (x, ..args) => path(x)),
)

#show: report.with(
  number: "3",
  title: "Исследование процессорных архитектур класса SIMD",
)

#render()
