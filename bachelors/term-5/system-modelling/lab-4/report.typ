#import "../common.typ": *

#show: report.with(number: "4", title: "Имитационное моделирование СМО на языке высокого уровня")

== Цель работы

Целью лабораторного занятия является закрепление теоретических основ имитационного моделирования
систем массового обслуживания и приобретение практических навыков разработки имитационных моделей
типовых систем на языках высокого уровня.

== Исходные данные

H2/M/1

== Структурная схема алгоритма

#figure(
  caption: [Структурная схема алгоритма],
  image("./assets/flowchart.png", height: 60%),
) <fig-flowchart>

== Исходный текст программы

#code-file(read("./src/index.html"), name: "index.html")

#code-file(read("./src/index.css"), name: "index.css")

#code-file(read("./src/index.js"), name: "index.js")

== Результаты моделирования

#figure(
  caption: [Результат моделирования, запуск 1],
  image("./assets/result-1.png", width: 60%),
) <fig-result-1>

#figure(
  caption: [Результат моделирования, запуск 2],
  image("./assets/result-2.png", width: 60%),
) <fig-result-2>

#figure(
  caption: [Результат моделирования, запуск 3],
  image("./assets/result-3.png", width: 60%),
) <fig-result-3>

#figure(
  caption: [Результат моделирования, запуск 4],
  image("./assets/result-4.png", width: 60%),
) <fig-result-4>

#figure(
  caption: [Результат моделирования, запуск 5],
  image("./assets/result-5.png", width: 60%),
) <fig-result-5>

#figure(
  caption: [Результат моделирования, запуск 6],
  image("./assets/result-6.png", width: 60%),
) <fig-result-6>

#figure(
  caption: [Результат моделирования, запуск 7],
  image("./assets/result-7.png", width: 60%),
) <fig-result-7>

#figure(
  caption: [Результат моделирования, запуск 8],
  image("./assets/result-8.png", width: 60%),
) <fig-result-8>

== Выводы

Была разработана имитационная модель при помощи средств языка программирования JavaScript, языков
разметки HTML и CSS. Проведены испытания модели и получены статистические характеристики модели.
Имитационная модель позволяет наглядно увидеть, как ведёт себя система, если вычислить её
характеристики аналитически сложно или невозможно.
