#import "../common.typ": *

#let (render,) = notebook(
  path("lab.ipynb"),
  handlers: (path: (x, ..args) => path(x)),
)

#show: report.with(
  number: "4",
  title: "Исследование архитектурных способов повышения производительности вычислительных систем",
)

#render()
