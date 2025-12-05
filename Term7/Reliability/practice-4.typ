#import "@preview/oxifmt:1.0.0": strfmt

#import "template.typ": conf

#show: doc => conf(
  number: [4],
  title: [Анализ надёжности функционального узла],
  variant: [Вариант 16],
  department: [Информационные и вычислительные системы],
  discipline: [Надёжность информационных систем],
  author: [А. Шефнер],
  author_post: [студент группы ИВБ-211],
  teacher: [Е.Н. Шаповалов],
  teacher_post: [к.т.н., доцент кафедры "ИВС"],
  doc: doc,
)

== Цель занятия

Приобретение навыков анализа надежности типового функционального узла (ФУ) с учетом условий его эксплуатации.

== Выполнить:

Заполнить таблицы 4.5 и 4.6 исходных данных

== Ход работы

#let elements = (
  (name: [Микросхема], lambda: 0.2e-6, count: 33, load: 1),
  (name: [Индикатор], lambda: 0.2e-6, count: 20, load: 1),
  (name: [Резистор], lambda: 0.15e-4, count: 22, load: 1),
  (name: [Конденсатор], lambda: 0.1e-6, count: 6, load: 1),
  (name: [Катушка индуктивности], lambda: 0.4e-6, count: 2, load: 1),
  (name: [Транзистор], lambda: 0.4e-6, count: 2, load: 1),
  (name: [Диод], lambda: 0.1e-6, count: 2, load: 1),
  (name: [Кварцевый резонатор], lambda: 0.75e-6, count: 1, load: 1),
  (name: [Печатная плата], lambda: 0.2e-6, count: 1, load: 1),
  (name: [Тиристор], lambda: 0.15e-6, count: 8, load: 1),
  (name: [Фоторезистор], lambda: 0.2e-5, count: 14, load: 1),
  (name: [Паяные соединения], lambda: 0.04e-6, count: 126, load: 1),
  (name: [Разъём], lambda: 0.1e-6, count: 2, load: 1),
)

#figure(
  table(
    columns: 6,
    [*Наименование элемента*],
    [*Исх. $lambda$*],
    [*Кол-во элементов*],
    [*$K_н$*],
    [*$lambda$ с учётом нагрузки*],
    [*Интенсивность отказов группы элементов*],

    ..elements
      .map(e => {
        let load-lambda = e.lambda * e.load
        let load-lambda-total = load-lambda * e.count
        (
          [#e.name],
          [#strfmt("{:.2e}", e.lambda)],
          [#e.count],
          [#e.load],
          [#strfmt("{:.2e}", load-lambda)],
          [#strfmt("{:.3e}", load-lambda-total)],
        )
      })
      .flatten(),
  ),

  caption: [Интенсивность отказов элементов ФУ (4.5)],
)

#let elements = (
  (c: 1, t: 12, lname: "низкая"),
  (c: 1, t: 12, lname: "высокая"),
  (c: 3, t: 12, lname: "низкая"),
  (c: 3, t: 12, lname: "высокая"),
  (c: 3, t: 50, lname: "низкая"),
  (c: 3, t: 50, lname: "высокая"),
  (c: 7, t: 12, lname: "низкая"),
  (c: 7, t: 12, lname: "высокая"),
  (c: 7, t: 50, lname: "низкая"),
  (c: 7, t: 50, lname: "высокая"),
)

#let work-times = (10000, 50000, 90000)

#figure(
  table(
    columns: (auto, auto, auto, auto, auto, auto, auto, 1fr),
    align: center+horizon,

    table.cell(rowspan: 2)[Усл.],
    table.cell(rowspan: 2)[$t_0$],
    table.cell(rowspan: 2)[Нагрузка \ на диод],
    table.cell(rowspan: 2)[$Lambda_с$],
    table.cell(rowspan: 2)[Средняя \ наработка \ до отказа],
    table.cell(rowspan: 2)[90%-я наработка \ ФУ до отказа],
    table.cell(colspan: 2)[ВБР],
    [$t$], [$P$],

    ..elements
      .map(e => {
        let temp-coef = if e.t <= 20 { 1.0 } else { 1.5 }
        let use-coef = if e.c == 1 { 1.0 } else if e.c == 3 { 1.1 } else if e.c == 7 { 7.0 } else { 1.0 }
        let load-coef = if e.lname == "низкая" { 1.0 } else { 1.5 }

        let lambda = temp-coef * use-coef * load-coef * 1e-7 * 2
        let w-90 = -calc.ln(0.9) / lambda

        (
          table.cell(rowspan: 3)[#e.c],
          table.cell(rowspan: 3)[#e.t],
          table.cell(rowspan: 3)[#e.lname],
          table.cell(rowspan: 3)[#strfmt("{:.3e}", lambda)],
          table.cell(rowspan: 3)[#int(1 / lambda)],
          table.cell(rowspan: 3)[#int(w-90)],
          ..work-times.map(t => (
            [#t],
            [#calc.round(calc.exp(-lambda * t), digits: 7)]
          )).flatten(),
        )
      })
      .flatten(),
  ),
  caption: [Расчет интенсивности отказов ФУ для различных условий (4.6)],
)

== Выводы

Показатели надёжности имеют прямую зависимость от условий эксплуатации. В работе
были учтены общие условия эксплуатации, рабочая температура и нагрузка на
изделие. Вывод оказался предельно ожидаемым: чем более жёсткие условия, тем
ниже показатели надёжности изделия. Наибольшее влияние оказывают общие условия
эксплутации.
