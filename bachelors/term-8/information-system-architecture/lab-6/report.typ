#import "../common.typ": *

#let (render,) = notebook(
  path("lab.ipynb"),
  handlers: (path: (x, ..args) => path(x)),
)

#show: report.with(
  number: "6",
  title: "Моделирование и расчёт характеристик параллельных программ",
)

#render()
