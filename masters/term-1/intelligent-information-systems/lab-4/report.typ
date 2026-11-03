#import "../common.typ": *

#let (render,) = notebook(
  path("lab.ipynb"),
  handlers: (path: (x, ..args) => path(x)),
)

#show: report.with(
  number: "4",
  title: "Нечёткая модель и база правил оценки ИБП",
  variant: "8",
)

#render()

= Исходный код модели

#raw(read("fuzzy.py"), lang: "python")
