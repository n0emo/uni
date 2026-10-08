#import "../common.typ": *

#show: report.with(number: "6", title: "Последовательностные схемы. Регистры")

= Введение

== Цель работы

Исследование регистров.

== Задание

+ Собрать в программе Electronics Workbench схему, представленную на рис. @img-parallel-task.
+ Собрать в программе Electronics Workbench схему, представленную на рис. @img-shift-task.
+ Собрать в программе Electronics Workbench схему, представленную на рис. @img-prng-task (КС --
  комбинационная схема).
+ Для каждого устройства получить диаграммы входных и выходных сигналов.
+ Подготовить отчет. Отчет должен содержать схемы и диаграммы исследуемых устройств.

#figure(
  caption: "Схема параллельного регистра",
  image("./assets/parallel-register-task.png", width: 80%),
) <img-parallel-task>

#figure(
  caption: "Схема сдвигового регистра",
  image("./assets/shift-register-task.png", width: 90%),
) <img-shift-task>

#figure(
  caption: "Схема ГПСЧ",
  image("./assets/prng-task.gif", width: 90%),
) <img-prng-task>

= Основная часть

== Задание 1. Параллельный регистр

#figure(
  caption: "Схема параллельного регистра",
  image("./assets/parallel-register-circuit.png", width: 60%),
)

#figure(
  caption: "Диаграмма сигналов параллельного регистра",
  image("./assets/parallel-register-diagram.png", width: 80%),
)

== Задание 2. Сдвиговой регистр

#figure(
  caption: "Схема сдвигового регистра",
  image("./assets/shift-register-circuit.png", width: 90%),
)

#figure(
  caption: "Диаграмма сигналов сдвигового регистра",
  image("./assets/shift-register-diagram.png", width: 90%),
)

== Задание 3. ГПСЧ

#figure(
  caption: "Схема ГПСЧ",
  image("./assets/prng-circuit.png", width: 90%),
)

= Заключение

В ходе работы были исследованы регистры.
