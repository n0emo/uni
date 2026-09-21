#import "../common.typ": *

#show: report.with(
  number: "2",
  title: "Функциональное представление кусочно-разрывной функции",
  variant: 19,
)

= Постановка задачи

Дана кусочно-разрывная функция, т.е. имеющая различное аналитическое представление в зависимости от
диапазона. Написать функциональное представление для этой функции на всём диапазоне, табулировать
функцию, вычислить площадь под этой функцией.

Функция:

$
  f(x) = cases(
    2 sin x\, & quad x < -2,
    x\, & quad -2 <= x < 1,
    ln(1 + x)\, & quad x >= 1,
  )
$

#figure(
  caption: "График кусочно-разрывной функции",
  image("./assets/function-plot.png", width: 80%),
)

Входные данные: заданные функции $y_1$, $y_2$, $y_3$, передаваемые как параметры, границы диапазонов
$a$, $b$, $x_1$, $x_2$.

Выходные данные: листинг функции `y(x, y1, y2, y3, x1, x2)`, значения площади под каждой функцией
$c_1$, $c_2$, $c_3$ и под всей функцией.

= Код программы

#code-file(read("./src/main.c"), name: "main.c")

#code-file(read("./src/funcs.h"), name: "funcs.h")

#code-file(read("./src/funcs.c"), name: "funcs.c")

= Отладка приложения

#figure(
  caption: "Результат выполнения программы",
  image("./assets/debug-output.png", width: 90%),
)

= Проверка в другом приложении (WolframAlpha)

#figure(
  caption: [Площадь под $2 sin x$ на отрезке $[a; x_1]$],
  image("./assets/wolfram-func-1.png", width: 60%),
)

#figure(
  caption: [Площадь под $x$ на отрезке $[x_1; x_2]$],
  image("./assets/wolfram-func-2.png", width: 60%),
)

#figure(
  caption: [Площадь под $ln(1 + x)$ на отрезке $[x_2; b]$],
  image("./assets/wolfram-func-3.png", width: 60%),
)

#figure(
  caption: [Площадь под всей функцией на отрезке $[a; b]$],
  image("./assets/wolfram-total.png", width: 80%),
)
