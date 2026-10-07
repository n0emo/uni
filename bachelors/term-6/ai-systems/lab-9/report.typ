#import "../common.typ": *

#let (render,) = notebook(
  path("lab.ipynb"),
  handlers: (path: (x, ..args) => path(x)),
)

#show: report.with(
  number: "9",
  title: "ИНС Хопфилда. Задача о назначениях",
)

#render()
