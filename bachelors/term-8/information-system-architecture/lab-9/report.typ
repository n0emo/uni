#import "../common.typ": *

#let (render,) = notebook(
  path("lab.ipynb"),
  handlers: (path: (x, ..args) => path(x)),
)

#show: report.with(
  number: "9",
  title: "Расчёт показателей надёжности, производительности и эффективности использования систем хранения данных на основе RAID-массивов",
)

#render()
