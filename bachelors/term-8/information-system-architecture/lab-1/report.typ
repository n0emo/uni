#import "../common.typ": *

#show: report.with(
  number: "1",
  title: "Расчёт метрик и использование законов параллельной обработки информации",
)

#let profile = csv("./data/profile.csv")
#let speedup = csv("./data/speedup.csv")

// Тактов в расписании и степень параллелизма на каждом такте — число задач,
// занимающих этот такт.
#let tasks = rows(profile).map(((task, start, duration)) => (
  task: task,
  start: int(start),
  duration: int(duration),
))
#let steps = calc.max(..tasks.map(t => t.start + t.duration - 1))
#let parallelism = range(1, steps + 1).map(step => tasks
  .filter(t => t.start <= step and step < t.start + t.duration)
  .len())

#let operations = parallelism.sum()
#let max-parallelism = calc.max(..parallelism)
#let mean-parallelism = operations / steps

// Профиль как в таблице: строка на задачу в том же порядке, что и на листе
// (4.3 сверху, 1.1 снизу), в каждой занятой клетке — номер задачи, под сеткой
// строка tn со степенью параллелизма на каждом такте.
#let task-colors = (
  rgb("#f28b82"), // 1.1
  rgb("#b39ddb"), // 2.1
  rgb("#fff176"), // 2.2
  rgb("#a5d6a7"), // 2.3
  rgb("#ffe082"), // 2.4
  rgb("#81c784"), // 3.1
  rgb("#f8bbd0"), // 3.2
  rgb("#90caf9"), // 3.3
  rgb("#d7a06a"), // 3.4
  rgb("#b0bec5"), // 3.5
  rgb("#9575cd"), // 3.6
  rgb("#e6ee9c"), // 3.7
  rgb("#c5e1a5"), // 4.1
  rgb("#ce93d8"), // 4.2
  rgb("#bdbdbd"), // 4.3
)

#let profile-chart = canvas({
  import draw: content, line, rect

  let w = 0.5
  let h = 0.34
  let label(pos, body, size: 5pt) = content(pos, text(size: size, body))

  for (i, task) in tasks.enumerate() {
    for step in range(task.start, task.start + task.duration) {
      let x = (step - 1) * w
      rect(
        (x, i * h),
        (x + w, i * h + h),
        fill: task-colors.at(i),
        stroke: 0.2pt + white,
      )
      label((x + w / 2, i * h + h / 2), task.task, size: 5pt)
    }
  }
  rect((0, 0), (steps * w, tasks.len() * h), stroke: 0.7pt + black)

  // Строка tn под сеткой.
  let y = -h
  label((-0.6, y + h / 2), [#text(weight: "bold")[tn]], size: 5pt)
  for (i, n) in parallelism.enumerate() {
    let x = i * w
    rect((x, y), (x + w, y + h), stroke: 0.2pt + luma(70%))
    label((x + w / 2, y + h / 2), [#n], size: 5pt)
  }
})

== Цель работы

Получить практические навыки расчёта основных метрик и использовать законы параллельных вычисления
для анализа показателей качества параллельной обработки информации.

== Ход работы

=== Профиль параллельной программы

В верхней части рисунка 1 представлена степень параллелизма, а в нижней --- профиль параллельной
программы. Максимальное количество одновременно выполняющихся задач равно #max-parallelism, а
средний параллелизм --- #num(mean-parallelism).

#figure(
  caption: "Степень параллелизма",
  kind: image,
  stack(
    dir: ttb,
    spacing: 1em,
    profile-chart,
    canvas(plot.plot(
      size: (11, 4),
      x-label: [Такт],
      y-label: [Степень параллелизма],
      x-min: 0,
      x-max: steps + 1,
      x-tick-step: 5,
      y-min: 0,
      y-tick-step: 2,
      plot.add-bar(
        parallelism.enumerate().map(((i, n)) => (i + 1, n)),
        bar-width: 0.7,
        style: (fill: blue.lighten(40%), stroke: 0.5pt + blue.darken(20%)),
      ),
    )),
  ),
)

=== Граф алгоритма

На рисунке 2 представлен граф алгоритма согласно условию задачи.

#figure(
  caption: "Граф алгоритма",
  image("./assets/graph.drawio.png", height: 30%),
)

=== Расчёт эффективности параллелизма

Эффективность для максимальног используемого числа процессоров:

$ E = S / n = #num(3.8) / 8 = #num(0.475) $

Стоимость вычислений:

$ C = n dot T_n = 8 dot 30 = 240 $

Утилизация:

$ U = O_n / (n dot T_n) = 114 / 240 = #num(0.475) $

Качество:

$ Q = S dot E dot C = #num(3.8) dot #num(0.475) dot 1 = #num(1.805) $

Суммарное время вычисление, не подлежащих распараллеливанию, составляет 6, а общее количество
операций --- #operations. Тогда #emph[f] примет значение:

$ f = 6 / 114 approx 0.05263 $

Предельное ускорение:

$ S_A = n / (1 + (n - 1) dot f) = 8 / (1 + (8 - 1) dot 6 / 114) = #num(5.8462) $

$ S_G = n + (1 - n) dot f = 8 + (1 - 8) dot 6 / 114 = #num(8.3684) $

--- ускорение по законам Амдала и Густавсона соответственно.

=== Таблица расчёта предельного ускорения для различных #emph[f]

На таблице 1 представлены результаты вычислений предельного ускорения по законам Амдала и Густавсона
при $n = 15$. Можно заметить, что по закону Амдала эффективность убывает значительно быстрее.

#csv-table(
  speedup,
  caption: [Предельное ускорение по законам Амдала и Густавсона для различных #emph[f]],
  headers: ($f$, $S_A$, $S_G$),
  format: cell => $#num(cell)$,
)

=== Графики эффективности параллельных вычисления

#figure(
  caption: "График эффективности вычислений",
  kind: image,
  line-plot(
    series(speedup, "f", "S_A"),
    series(speedup, "f", "S_G"),
    labels: ($S_A$, $S_G$),
    x-label: [Доля последовательных операций],
    y-label: [Эффективность],
    size: (11, 6),
    x-min: 0,
    x-max: 1,
    x-tick-step: 0.1,
    y-min: 0,
    y-max: 16,
    y-tick-step: 2,
  ),
)

== Вывод

В ходе работы были полученыпрактические навыки расчёта основных метрик и использованы законы
параллельных вычисления для анализа показателей качества параллельной обработки информации.
Полученные результаты показывают ограниченную эффективность параллелизма при наличии зависимостей
однизх задач от других.
