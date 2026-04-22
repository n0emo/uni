#import "../common.typ": *

#show: report.with(number: "1", title: "Создание консольного приложения")

#let formula = $
  V = frac(
    L^3 sin 2alpha dot sin beta dot cos alpha,
    4 sqrt(cos(alpha + beta) dot cos(alpha - beta))
  )
$

= Задание

Основание прямой призмы — ромб. Одна из диагоналей призмы равна $L$ и составляет
с плоскостью основания угол, равный $alpha$, а с одной из боковых граней угол,
равный $beta$. Найти объем призмы по формуле:

#formula

если $L = 28$ см; $alpha = 40degree$; $beta = 30degree$.

= Ход работы

== Постановка задачи

Вычислить значение выражения.

=== Входные параметры

$L$, $beta$, $alpha$ -- переменные вещественного типа.

=== Выходные данные

== Математическая модель задачи

#formula

== Разработка алгоритма

#figure(
  caption: "Блок-схема алгоритма",
  image("./assets/flowchart.png", height: 30%),
)

== Исходный текст программы

#code-file(read("./src/main.c"), name: "main.c")

== Отладка приложения

#figure(
  kind: image,
  caption: "Отладка приложения",
  ```
  albert@einstein uni/Term1/EntranceToC
  ❯ cmake --build build
  [2/2] Linking C executable lab-1/lab-1

  albert@einstein uni/Term1/EntranceToC
  ❯ ./build/lab-1/lab-1
  Enter L vaule:
  28
  Enter a vaule:
  40
  Enter b vaule:
  30

  V = 3566.875582
  ```,
)

== Проверка в другом приложении

Для проверки алгоритма использован сервис WolframAlpha.

#figure(
  caption: "Ввод данных в WolframAlpha",
  image("assets/wolfram-alpha-input.png", width: 80%),
)

#figure(
  caption: "Результат вычислений",
  image("assets/wolfram-alpha-output.png"),
)

== Выводы

В ходе работы были получены базовые навыки написания алгоритма вычисления
функции на языке программирования C.
