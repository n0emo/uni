#import "../common.typ": *

#let (render,) = notebook(
  path("lab.ipynb"),
  handlers: (path: (x, ..args) => path(x)),
)

#show: report.with(
  number: "2",
  title: "Моделирование и анализ топологий сетей межсоединений",
)

#render()
