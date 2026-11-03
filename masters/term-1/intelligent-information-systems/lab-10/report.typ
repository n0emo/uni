#import "../common.typ": *

#let (render,) = notebook(
  path("lab.ipynb"),
  handlers: (path: (x, ..args) => path(x)),
)

#show: report.with(
  number: "10",
  title: "ИНС Хэмминга. Распознавание образов",
)

#render()
