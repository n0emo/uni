#import "../common.typ": *
#let (render,) = notebook(path("lab.ipynb"), handlers: (path: (x, ..args) => path(x)))
#show: report.with(
  number: "5",
  title: "Реализация алгоритма нечёткого вывода Мамдани",
  variant: "8",
)
#render()
