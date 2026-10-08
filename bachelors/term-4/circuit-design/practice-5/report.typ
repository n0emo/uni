#import "../common.typ": *

#show: report.with(number: "5", title: "Последовательностные схемы. Счётчики")

= Введение

== Цель работы

Исследование счетчиков

== Задание

1. Собрать в программе Electronics Workbench схему, представленную на рис. @fig-async-counter-task.

#figure(
  caption: "Принципиальная схема асинхронного счетчика",
  image("./assets/async-counter-task.png", width: 70%),
) <fig-async-counter-task>

Для исследования схемы необходимо задать счетный режим каждого триггера.

2. Собрать в программе Electronics Workbench схему, представленную на рис. @fig-sync-counter-task.

Для реализации данной схемы необходимо использовать модель микросхемы 7472 (AND gated JK MS-SLV FF
(pre, clr)) из набора предлагаемых в программе Electronics Workbench.

3. Собрать в программе Electronics Workbench схему, представленную на рис.
  @fig-sync-counter-carry-task.
4. Собрать в программе Electronics Workbench схему, представленную на рис. @fig-down-counter-task.
5. Собрать в программе Electronics Workbench схему, представленную на рис.
  @fig-sync-counter-modulo-task.

#figure(
  caption: "Схема синхронного счетчика",
  image("./assets/sync-counter-task.png", width: 90%),
) <fig-sync-counter-task>

#figure(
  caption: "Схема синхронного счетчика с асинхронным переносом",
  image("./assets/sync-counter-carry-task.gif", width: 90%),
) <fig-sync-counter-carry-task>

#figure(
  caption: "Схема асинхронного вычитающего счетчика",
  image("./assets/down-counter-task.png", width: 70%),
) <fig-down-counter-task>

#figure(
  caption: "Схема синхронного счетчика с измененным модулем счета",
  image("./assets/sync-counter-modulo-task.png", width: 85%),
) <fig-sync-counter-modulo-task>

Для исследования схемы необходимо задать счетный режим каждого триггера.

6. Собрать в программе Electronics Workbench схему, представленную на рис.
  @fig-johnson-counter-task.

#figure(
  caption: "Схема кольцевого счетчика Джонсона",
  image("./assets/johnson-counter-task.gif", width: 65%),
) <fig-johnson-counter-task>

7. Для каждой схемы необходимо получить таблицу состояний и диаграмму сигналов, определить
  коэффициент пересчета (модуль счетчика), классифицировать счетчик.
8. Подготовить отчет. Отчет должен содержать схемы, таблицы состояний и диаграммы исследуемых
  устройств.

= Основная часть

== Задание 1. Схема асинхронного счетчика

#figure(
  caption: "Схема асинхронного счетчика",
  image("./assets/async-counter-schema.png", width: 90%),
)

#figure(
  caption: "Диаграмма асинхронного счетчика",
  image("./assets/async-counter-diagram.png", width: 60%),
)

$ K = 64 $

== Задание 2. Схема синхронного счетчика

#figure(
  caption: "Схема синхронного счетчика",
  image("./assets/sync-counter-schema.png", width: 90%),
)

#figure(
  caption: "Диаграмма синхронного счетчика",
  image("./assets/sync-counter-diagram.png", width: 60%),
)

$ K = 64 $

== Задание 3. Схема синхронного счетчика с асинхронным переносом

#figure(
  caption: "Схема синхронного счетчика с асинхронным переносом",
  image("./assets/sync-counter-carry-schema.jpg", width: 90%),
)

#figure(
  caption: "Диаграмма синхронного счетчика с асинхронным переносом",
  image("./assets/sync-counter-carry-diagram.png", width: 60%),
)

$ K = 8 $

== Задание 4. Схема асинхронного вычитающего счетчика

#figure(
  caption: "Схема асинхронного вычитающего счетчика",
  image("./assets/down-counter-schema.png", width: 85%),
)

#figure(
  caption: "Диаграмма асинхронного вычитающего счетчика",
  image("./assets/down-counter-diagram.png", width: 55%),
)

$ K = 64 $

== Задание 5. Схема синхронного счетчика с измененным модулем счета

#figure(
  caption: "Схема синхронного счетчика с измененным модулем счета",
  image("./assets/sync-counter-modulo-schema.png", width: 85%),
)

#figure(
  caption: "Диаграмма синхронного счетчика с измененным модулем счета",
  image("./assets/sync-counter-modulo-diagram.png", width: 65%),
)

$ K = 64 $

== Задание 6. Схема кольцевого счетчика Джонсона

#figure(
  caption: "Схема кольцевого счетчика Джонсона",
  image("./assets/johnson-counter-schema.png", width: 85%),
)

#figure(
  caption: "Диаграмма кольцевого счетчика Джонсона",
  image("./assets/johnson-counter-diagram.png", width: 55%),
)

$ K = 64 $
