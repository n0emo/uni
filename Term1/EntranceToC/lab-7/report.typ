#import "../common.typ": *

#show: report.with(number: "7", title: "Работа с матрицами")

= Задание

Разработать информационную технологию, позволяющую последовательно заполнить
вектор Р индексами элементов матрицы S, расположенных над её главной диагональю
и имеющих положительные значения. Размерность матрицы произвольная.

= Ход работы

== Разработка алгоритма

#figure(
  caption: "Алгоритм функции main",
  image("assets/flowchart-1.png"),
)

#figure(
  caption: "Алгоритм функции Алгоритм функции matrix_read",
  image("assets/flowchart-2.png"),
)

#figure(
  caption: "Алгоритм функции matrix_find_positive_elements_above_main_diagonal",
  image("assets/flowchart-3.png"),
)

#pagebreak()

== Исходный текст программы

#code-file(read("./src/main.c"), name: "main.c")

== Отладка приложения

#figure(
  kind: image,
  caption: "Отладка приложения",
  ```
  albert@einstein uni/Term1/EntranceToC
  ❯ ./build/lab-7/lab-7
  Enter rows and columns count:
  10 10
  Enter matrix with 10 rows and 10 columns:

  -43 -34  45 -29  31  13  18  13   3  49
   -5 -14  18  44   1  49 -29  39 -21 -15
   39   1 -22  -8  44 -12 -29 -41  -8  44
   46  43 -29  39  17 -38  25 -40 -36 -22
  -49  33   0  20 -13  25 -27 -12  35  17
   -2 -18 -21 -10 -33  42 -35 -29  25 -33
  -40  -3  39  35 -26  -5  36  -9  -7   5
   42  22  18  31  -7  45  22  32 -37  31
   49  38 -24  30 -36  50  49 -45 -19  36
   10   0  37  17 -19 -43  48   4   4 -40

  Positive elements:
  matrix[0, 2] =  45
  matrix[0, 4] =  31
  matrix[0, 5] =  13
  matrix[0, 6] =  18
  matrix[0, 7] =  13
  matrix[0, 8] =   3
  matrix[0, 9] =  49
  matrix[1, 2] =  18
  matrix[1, 3] =  44
  matrix[1, 4] =   1
  matrix[1, 5] =  49
  matrix[1, 7] =  39
  matrix[2, 4] =  44
  matrix[2, 9] =  44
  matrix[3, 4] =  17
  matrix[3, 6] =  25
  matrix[4, 5] =  25
  matrix[4, 8] =  35
  matrix[4, 9] =  17
  matrix[5, 8] =  25
  matrix[6, 9] =   5
  matrix[7, 9] =  31
  matrix[8, 9] =  36
  ```,
)

== Проверка

#let matrix_table(m) = {
  let rows = m.len()
  let cols = m.at(0).len()

  table(
    columns: cols,
    ..for row in range(rows) {
      for col in range(cols) {
        let elem = m.at(row).at(col)
        let bg = if col > row and elem > 0 {
          green.lighten(50%)
        } else if col > row {
          yellow.lighten(50%)
        } else {
          white
        }
        (table.cell(fill: bg)[#elem],)
      }
    }
  )
}

#let m = (
  (-43, -34, 45, -29, 31, 13, 18, 13, 3, 49),
  (-5, -14, 18, 44, 1, 49, -29, 39, -21, -15),
  (39, 1, -22, -8, 44, -12, -29, -41, -8, 44),
  (46, 43, -29, 39, 17, -38, 25, -40, -36, -22),
  (-49, 33, 0, 20, -13, 25, -27, -12, 35, 17),
  (-2, -18, -21, -10, -33, 42, -35, -29, 25, -33),
  (-40, -3, 39, 35, -26, -5, 36, -9, -7, 5),
  (42, 22, 18, 31, -7, 45, 22, 32, -37, 31),
  (49, 38, -24, 30, -36, 50, 49, -45, -19, 36),
  (10, 0, 37, 17, -19, -43, 48, 4, 4, -40),
)

На таблице @table-check жёлтым выделены элементы выше главной диагонали матрицы
10х10, зелёным – положительные из них. Программа вывела их правильно.

#figure(
  caption: "Проверка исходной матрицы",
  matrix_table(m),
) <table-check>

== Выводы

В ходе работы были получены навыки работы с матрицами в языке программирования C.
