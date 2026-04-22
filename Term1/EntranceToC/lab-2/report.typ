#import "../common.typ": *

#show: report.with(
  number: "2",
  title: "Сравнение значений (операции отношения). Логические операции. Условные операторы",
)

= Задание

== 1. Вычислить кусочную функцию

$y$ задан в виде кусочной функции:

$
  y = cases(
    sqrt(a + |x|) & ";" x <= 0,
    frac(1 + 3x, 2c + root(n, 1 + x)) & ";" x > 0
  )
$

== 2. Вычислить функцию, заданную графически

$y$ задан графически:

#figure(
  caption: "График функции",
  image("assets/graph-2.png"),
)

Приведение к виду кусочной функции:

$
  y = cases(
    sin(x) & ";" x < 0,
    0 & ";" 0 <= x < 1,
    cos(x) + 1 & ";" x >= 1
  )
$

= Ход работы

== Разработка алгоритма

#figure(
  caption: "Алгоритм программы",
  image("assets/flowchart.png"),
)

== Исходный текст программы

#code-file(read("./src/task_1.c"), name: "task_1.c")
#code-file(read("./src/task_2.c"), name: "task_2.c")
#code-file(
  name: "task_3.c",
  ```c
  #include <stdio.h>

  int main()
  {
      printf("Hello, World!\n");
      return 0;
  }
  ```,
)

== Отладка приложения

=== Отладка программы для задания 1

#figure(
  kind: image,
  caption: "Отладка приложения 1",
  ```
  albert@einstein uni/Term1/EntranceToC
  ❯ ./build/lab-2/lab-2-1
  Enter a, c, x vaules:
  -2 -2 -10.5
  y = 2.915476

  albert@einstein uni/Term1/EntranceToC
  ❯ ./build/lab-2/lab-2-1
  Enter a, c, x vaules:
  -2 2 15
  y = 7.055386
  ```,
)

=== Отладка программы для задания 2

#figure(
  kind: image,
  caption: "Отладка приложения 2",
  ```
  albert@einstein uni/Term1/EntranceToC
  ❯ ./build/lab-2/lab-2-2
  Enter x value:
  -28376
  y = -0.906599

  albert@einstein uni/Term1/EntranceToC
  ❯ ./build/lab-2/lab-2-2
  Enter x value:
  0.51
  y = 0.000000

  albert@einstein uni/Term1/EntranceToC
  ❯ ./build/lab-2/lab-2-2
  Enter x value:
  53.5353
  y = 0.008210
  ```,
)

== Проверка в другом приложении

Для проверки выбрано приложение MathCad.

#figure(
  caption: "Проверка приложения 1",
  image("assets/mathcad-1.png", width: 30%),
)

#figure(
  caption: "Проверка приложения 2",
  image("assets/mathcad-2.png", width: 30%),
)

== Выводы

В ходе работы были получены навыки написания алгоритмов с условными
конструкциями на языке программирования C.
