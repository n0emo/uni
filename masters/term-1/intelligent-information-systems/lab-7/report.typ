#import "../common.typ": *

#let (render,) = notebook(
  path("lab.ipynb"),
  handlers: (path: (x, ..args) => path(x)),
)

#show: report.with(
  number: "7",
  title: "Нейросетевой аппроксиматор функции 3-х переменных",
)

#render()
