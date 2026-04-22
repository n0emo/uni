#import "../common.typ": *

#show: report.with(
  number: "4",
  title: [Массивы и указатели (накопление), часть 1],
)

= Задание

== Задание 1

Вычислить значение функции:

$ W = sum_(i=1)^n frac(a_i^2, 2) $

где $n$ — размерность вектора $A$.

Проанализировать выполнение программы на примере вектора:

$ A = {2; -6; 0; 4; -4; -2; 2} $

== Задание 2

Вычислить произведение и количество элементов прямоугольной матрицы в чётных строках.

= Ход работы

== Разработка алгоритма

#figure(
  caption: "Алгоритм программы задания 1",
  image("assets/flowchart-1.png", width: 70%),
)

#figure(
  caption: "Алгоритм программы задания 2",
  image("assets/flowchart-2.png", width: 90%),
)

#pagebreak()

== Исходный текст программы

#code-file(read("./src/main.c"), name: "main.c")

== Отладка приложения

=== Отладка программы для задания 1

#figure(
  kind: image,
  caption: "Отладка программы 1",
  ```
  albert@einstein uni/Term1/EntranceToC
  ❯ ./build/lab-5/lab-5
  Select question number (1 or 2):
  1
  Enter array elements count:
  7
  Enter array numbers:
  2 -6 0 4 -4 -2 2
  Answer: W = 40.000000
  ```,
)

#figure(
  kind: image,
  caption: "Отладка программы 2",
  ```
  albert@einstein uni/Term1/EntranceToC
  ❯ ./build/lab-5/lab-5
  Select question number (1 or 2):
  2
  Enter matrix with 4 rows and 3 columns:
  1 2 3
  4 5 6
  7 8 9
  10 11 12
  Answer: product = 158400.000000, count = 6
  ```,
)

== Выводы

В ходе работы были получены навыки работы с массивами фиксированного размера в
языке программирования С.
