#import "../common.typ": *

#show: report.with(number: "3", title: "Гонки и состязания в цифровых устройствах")

= Введение

== Цель работы

Исследовать влияние временных задержек в логических элементах на работу цифровых устройств.

== Задание

+ Собрать в программе Electronics Workbench схему, представленную ниже:

  #figure(
    caption: "Исследуемая схема",
    image("./assets/test-circuit.gif", width: 70%),
  )
+ Получить диаграммы сигналов в точках _СИ_, _1_, _С_, _Q_ с помощью осциллографа (Oscilloscope).
+ Исследовать схему с количеством инверторов от 1 до 7, используя только нечетные количества.
+ Рассчитать задержку для каждого количества инверторов по формуле (1).
+ Определить значение задержки в точке _1_ для разного количества инверторов с помощью инструментов
  осциллографа (Oscilloscope).
+ Построить графики зависимости расчетного и полученного значений задержки от количества инверторов.
+ Подготовить отчет. Отчет должен содержать схемы, диаграммы входных и выходных сигналов триггеров и
  выводы о работе схем.

= Основная часть

== Схема с 1 инвертором

#grid(
  columns: 2,
  gutter: 1em,
  figure(
    caption: "Переход от высокого сигнала к низкому",
    image("./assets/scope-1inv-a-high-to-low.png", width: 100%),
  ),
  figure(
    caption: "Переход от низкого сигнала к высокому",
    image("./assets/scope-1inv-a-low-to-high.png", width: 100%),
  ),
)

#figure(
  caption: "Исследуемая схема",
  image("./assets/circuit-1inv.png", width: 55%),
)

#grid(
  columns: 2,
  gutter: 1em,
  figure(
    caption: "Переключения от низкого уровня к высокому",
    image("./assets/scope-1inv-b-low-to-high.png", width: 100%),
  ),
  figure(
    caption: "Переключение от высокого уровня к низкому",
    image("./assets/scope-1inv-b-high-to-low.png", width: 100%),
  ),
)

$ t = 2 dot 2.88 + 2 dot 2.88 = 11.52 $

Время задержки для 1-го инвертора = 11.52 миллисекунды

== Схема с 3 инверторами

#figure(
  caption: "Исследуемая схема с 3 инверторами",
  image("./assets/circuit-3inv.png", width: 55%),
)

#grid(
  columns: 2,
  gutter: 1em,
  figure(
    caption: "Переход от низкого уровня к высокому",
    image("./assets/scope-3inv-low-to-high.png", width: 100%),
  ),
  figure(
    caption: "Переход от высокого уровня к низкому",
    image("./assets/scope-3inv-high-to-low.png", width: 100%),
  ),
)

$ t = 2 dot 2.88 + 2 dot 3.601 = 12.962 $

Время задержки для 3-х инвертора = 12.962 миллисекунды

== Схема с 5 инверторами

#figure(
  caption: "Исследуемая схема с 5 инверторами",
  image("./assets/circuit-5inv.png", width: 55%),
)

#grid(
  columns: 2,
  gutter: 1em,
  figure(
    caption: "Переход от низкого уровня к высокому",
    image("./assets/scope-5inv-low-to-high.png", width: 100%),
  ),
  figure(
    caption: "Переход от высокого уровня к низкому",
    image("./assets/scope-5inv-high-to-low.png", width: 100%),
  ),
)

$ t = 2 dot 3.601 + 2 dot 3.601 = 14.404 $

Время задержки для 5-ти инвертора = 14.404 миллисекунды

== Схема с 7 инверторами

#figure(
  caption: "Исследуемая схема для 7 инверторов",
  image("./assets/circuit-7inv.png", width: 55%),
)

#grid(
  columns: 2,
  gutter: 1em,
  figure(
    caption: "Переход от низкого уровня к высокому",
    image("./assets/scope-7inv-low-to-high.png", width: 100%),
  ),
  figure(
    caption: "Переход от высокого уровня к низкому",
    image("./assets/scope-7inv-high-to-low.png", width: 100%),
  ),
)

$ t = 2 dot 3.87 + 2 dot 3.87 = 15.52 $

Время задержки для 7-ми инвертора = 15.52 миллисекунды

== Зависимость задержки от количества инверторов

#figure(
  caption: "Зависимость задержки от количества инверторов",
  image("./assets/delay-chart.png", width: 80%),
)

Задержка сигнала возрастает с возрастанием количества инверторов.
