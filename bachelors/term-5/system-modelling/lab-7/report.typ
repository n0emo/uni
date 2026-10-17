#import "../common.typ": *

#show: report.with(number: "7", title: "Диаграмма вариантов использования")

== Ход работы

#figure(
  caption: [Диаграмма вариантов использования информационной системы жилищного агентства],
  rotate(-90deg, reflow: true, image("./assets/use-case.svg", width: 22cm)),
) <fig-use-case>
