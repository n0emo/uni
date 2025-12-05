#import "@preview/cetz:0.4.2"
#import "@preview/cetz-plot:0.1.3": plot
#import "@preview/oxifmt:1.0.0": strfmt

#import "template.typ": conf

#show: doc => conf(
  number: [3],
  title: [Расчёт единичных и комплексных показателей надёжности],
  variant: [Вариант 16],
  department: [Информационные и вычислительные системы],
  discipline: [Надёжность информационных систем],
  author: [А. Шефнер],
  author_post: [студент группы ИВБ-211],
  teacher: [Е.Н. Шаповалов],
  teacher_post: [к.т.н., доцент кафедры "ИВС"],
  doc: doc,
)

// Calculations

#let rhour = $"час"^(-1)$
#let hour = $"час"$

#let lambda-base = (9e-4, 7e-4, 8e-4, 3e-4)
#let lambda-improved = (3e-4, 7e-4, 8e-4, 1e-4)
#let recovery-times = (10, 24, 16, 20)
#let working-times = (100, 500, 1000, 10000)
#let gamma-values = (0.9, 0.95, 0.99, 0.995)

#let p(t, l) = calc.exp(-l * t)

#let add(a, b) = a + b
#let lambda-sum = lambda-base.reduce(add)
#let lambda-improved-sum = lambda-improved.reduce(add)

#let weighted-recovery-time(lambdas, times) = {
  let total-lambda = lambdas.reduce(add)
  lambdas.zip(times).map(((l, t)) => l * t / total-lambda).reduce(add)
}

#let recovery-coeff(lambdas) = 1 / weighted-recovery-time(lambdas, recovery-times)

#let gamma-time(g, l) = -calc.ln(g) / l

#let ready-coeff(l, t) = calc.exp(-l * t)
#let ready-coeff-avg(l, tn) = (1 - calc.exp(-l * tn)) / (l * tn)
#let ready-coeff-recov(l, m, t) = m / (l + m) + (l / (l + m)) * calc.exp(-(l + m) * t)
#let ready-coeff-recov-avg(l, m, t) = m / (l + m) * (1 + (l) / (m * t * (l + m)))

#let oper-ready-coeff(l, t) = ready-coeff-avg(l, t) * calc.exp(-l * t)
#let oper-ready-coeff-recov(l, m, t) = ready-coeff-recov-avg(l, m, t) * calc.exp(-l * t)

#let ready-coeff-plot-opts = (
  size: (13, 5),
  x-label: $t$,
  y-label: $К_г$,
  x-grid: "major",
  y-grid: "major",
  x-ticks: (365 * 6, 365 * 12, 365 * 18, 365 * 24),
  x-tick-step: none,
)

#let ready-coeff-plot(lambda, time) = {
  cetz.canvas({
    plot.plot(..ready-coeff-plot-opts, {
      let xs = (range(0, 8800, step: 365) + range(0, 8800, step: 100)).sorted()
      let data = xs.map(t => (t, ready-coeff(lambda, calc.rem(t, time))))
      plot.add(data)
    })
  })
}

// Text body

= Задание 

== Цель работы

Выразить предложение по доработке системы с учётом рассчётных показателей надёжности

== Выполнить:

Рассчитать показатели надёжности для исходной и доработанной системы. Построить
графики зависимостей показателей надёжности.

== Исходные данные

#figure(
  table(
    columns: 4,
    [$lambda_i rhour$], [$lambda_i^д rhour$], [$t_(в i), hour$], [$t_з, hour$],
    [$9 dot 10^(-4)$], [$3 dot 10^(-4)$], [10], [100],
    [$7 dot 10^(-4)$], [], [24], [500],
    [$8 dot 10^(-4)$], [], [16], [1000],
    [$3 dot 10^(-4)$], [$10^(-4)$], [20], [10000],
  ),
  caption: [Исходные данные о надежности элементов],
)

#figure(
  table(
    columns: 3,
    [1], [2], [3],
    [ГТО], [ГТО+ПГТО], [ГТО+ПГТО+КвТО],
  ),
  caption: [Виды ТО системы в течение цикла],
)

= Ход работы

== Задание 1

Найти:

1. интенсивность отказов системы $Lambda_с$
2. математическое ожидание наработки системы до отказа Tc
3. Вероятность безотказной работы системы (ВБР) системы в течение заданного времени
  $P_(accent(T, hat)_с)(t_з)$ (четвертый столбец таблицы 1) для экспоненциального распределения.

=== Решение

1. $Lambda_с = sum lambda_i = #{ calc.round(lambda-sum, digits: 5) } dot rhour$
2. $Т_с = frac(1, Lambda_c) = #{ calc.round(1 / lambda-sum, digits: 2) } dot hour$
3. $P_(accent(T, hat)_с) (t_з) = e^(-lambda t)$
  - $P_(accent(T, hat)_с) (100 dot hour) = #p(lambda-sum, 100)$
  - $P_(accent(T, hat)_с) (500 dot hour) = #p(lambda-sum, 500)$
  - $P_(accent(T, hat)_с) (1000 dot hour) = #p(lambda-sum, 1000)$
  - $P_(accent(T, hat)_с) (10000 dot hour) = #p(lambda-sum, 10000)$

== Задание 2

Сравнить полученные показатели надежности (ПН) системы с ПН элементов, сделать выводы.

=== Решение

Можно сравнить среднюю наработку до отказа отдельных элементов и системы.

- Для $lambda_1 = 9 dot 10^(-4) rhour, T_(с,1) = #{ int(1 / 9e-4) }$
- Для $lambda_2 = 7 dot 10^(-4) rhour, T_(с,2) = #{ int(1 / 7e-4) }$
- Для $lambda_3 = 8 dot 10^(-4) rhour, T_(с,3) = #{ int(1 / 8e-4) }$
- Для $lambda_4 = 3 dot 10^(-4) rhour, T_(с,4) = #{ int(1 / 3e-4) }$

Можно заметить, что средняя наработка до отказа систему ($approx 370 hour$) значительно
меньше средней наработки каждого отдельного элемента. Это говорит о том, что система менее
надёжна её самого ненадёжного элемента.

== Задание 3

Построить график зависимости $P_(accent(T, hat)_с) (t_з)$.

=== Решение

#figure(
  cetz.canvas({
    plot.plot(
      size: (6, 3),

      x-label: $t_з$,
      x-mode: "log",
      x-min: 80,
      x-max: 15000,
      x-ticks: (100, 500, 1000, 10000),

      y-label: $P_(accent(T, hat)_с) (t_з)$,
      y-min: 0.01,
      y-max: 1,
      y-tick-step: 0.2,

      {
        plot.add(
          working-times.map(t => (t, p(lambda-sum, t))),
          mark: "o",
        )
      },
    )
  }),
  caption: [График зависимости $P_(accent(T, hat)_с) (t_з)$],
)

== Задание 4

Рассчитать гамма-процентное время наработки системы до отказа при различных значениях при
различных значениях. Результаты занести в таблицу 3. Построить график
зависимости $T_gamma (gamma)$.

=== Решение

Чтобы вычислить гамма-процентное время до отказа, можно решать уравнение:

$
               P(t) & = gamma \
      e^(-lambda t) & = gamma \
  ln(e^(-lambda t)) & = ln(gamma) \
          -lambda t & = ln(gamma) \
                  t & = -frac(ln(gamma), lambda)
$


#figure(
  table(
    columns: 5,
    [$gamma, %$], [90], [95], [99], [99.5],
    [$T_gamma, "час"$],
    [#calc.round(gamma-time(0.9, lambda-sum), digits: 5)],
    [#calc.round(gamma-time(0.95, lambda-sum), digits: 5)],
    [#calc.round(gamma-time(0.99, lambda-sum), digits: 5)],
    [#calc.round(gamma-time(0.995, lambda-sum), digits: 5)],
  ),
  caption: [Гарантированное время безотказной работы системы],
)

#figure(
  cetz.canvas({
    plot.plot(
      size: (7, 5),

      x-label: $gamma$,
      x-mode: "log",
      x-min: 0.89,
      x-max: 1,

      y-label: $T_gamma$,
      y-min: 1,
      y-max: 45,

      {
        plot.add(
          (0.9, 0.95, 0.99, 0.995).map(g => (g, gamma-time(g, lambda-sum))),
          mark: "o",
        )
      },
    )
  }),
  caption: [График зависимости гарантированного времени безотказной работы системы от $gamma$],
)

== Задание 5

Рассчитать среднее время восстановления системы $overline(T)_("вc")$. Сделать выводы
о соотношении $overline(T)_("вc")$ с $t_(в i)$.

=== Решение

Среднее время восстановления системы вычисляется по формуле:

$ overline(T_в) = sum_(i=1)^4 overline(t)_(в, i) dot frac(lambda_i, Lambda_с) $

$
  overline(T_в) =
  10 dot frac(9 dot 10^(-4), 0.0027) +
  24 dot frac(7 dot 10^(-4), 0.0027) +
  16 dot frac(8 dot 10^(-4), 0.0027) +
  20 dot frac(3 dot 10^(-4), 0.0027)
$

$
  overline(T_в) =
  #calc.round(weighted-recovery-time(lambda-base, recovery-times), digits: 5)
$

Можно сделать вывод, что среднее время восстановления системы является средневзвешанной оценкой
времени восстановления отдельных её элементов.

== Задание 6

Рассчитать среднее время восстановления системы после повышения надежности (доработок)
некоторых элементов (второй столбец таблицы 1). Сделать выводы о том, какие ПН системы
улучшились, а какие ухудшились, и подкрепить их расчетами.

=== Решение

Можно вычислить базовые показатели надёжности на примере предыдущих заданий с учётом доработки.

#let improved-recovery-time = calc.round(
  weighted-recovery-time(lambda-improved, recovery-times),
  digits: 5,
)

$
       Lambda_"сд" & = sum_(i=1)^4 lambda_(д, i) = #{ lambda-improved.reduce(add) } dot rhour \
            T_"сд" & = frac(1, Lambda) = #{ calc.round(1 / lambda-improved.reduce(add), digits: 5) } dot "час" \
  overline(T)_"вд" & = sum_(i=1)^4 overline(t)_(в, i) dot frac(lambda_(д, i), Lambda_"сд")
                     = #improved-recovery-time hour
$

Можно сделать вывод, что система после даработки стала значительно надёжнее. Несмотря на то, что время
восстановления немного увеличилось, средняя наработка до отказа увеличилась на #{ int(526 / 370 * 100 - 100) }%.

== Задание 7

Рассчитать коэффициент готовности системы в конце межрегламентного периода и средний
коэффициент готовности системы при условии, что ее состояние не контролируется для различных
вариантов регламентных работ (таблица 2). Построить график изменения коэффициента готовности
от времени (в течение цикла).

=== Решение

Из предыдущего задания, коэффициент готовности для экспоненциального распределения невосстанавливаемой
системы:

$
  K_г = P_(accent(t, hat)) (t) = e^(-lambda t) \
  overline(K)_г =
  frac(1, t_n) integral_0^(t_n) e^(-lambda t) d t =
  frac(1-e^(-lambda t_n), lambda t_n)
$

В следующей таблице приведены рассчёты коэффциента готовности для разных периодов обслуживания

#figure(
  table(
    columns: 4,
    [вид ТО], [период, час], [КГ в конце периода], [средний КГ],
    ..(([ГТО], 365 * 24), ([ГТО+ПГТО], 365 * 12), ([ГТО+ПГТО+КвТО], 365 * 6))
      .map(((n, t)) => {
        (
          [#n],
          [#t],
          [#strfmt("{:.4e}", ready-coeff(lambda-sum, t))],
          [#strfmt("{:.4e}", ready-coeff-avg(lambda-sum, t))],
        )
      })
      .flatten(),
  ),
  caption: [КГ в конце периода обслуживания и средний КГ исходной системы],
)

#figure(
  ready-coeff-plot(lambda-sum, 365.0 * 24.0),
  caption: [КГ доработанной системы при ГТО],
)
#figure(
  ready-coeff-plot(lambda-sum, 365.0 * 12.0),
  caption: [КГ доработанной системы при ПГТО+ГТО],
)
#figure(
  ready-coeff-plot(lambda-sum, 365.0 * 6.0),
  caption: [КГ доработанной системы при ГТО+ПГТО+КвТО],
)

== Задание 8

Рассчитать коэффициент готовности доработанной системы (второй столбец таблицы 1) в конце
межрегламентного периода и средний коэффициент готовности доработанной системы при условии,
что ее состояние не контролируется для различных вариантов регламентных работ (таблица 2).
Построить график изменения среднего коэффициента готовности от продолжительности
межрегламентного периода.

=== Решение

Расчёты аналогичны предыдущему заданию и приведены в следующей таблице.

#figure(
  table(
    columns: 4,
    [вид ТО], [период, час], [КГ в конце периода], [средний КГ],
    ..(([ГТО], 365 * 24), ([ГТО+ПГТО], 365 * 12), ([ГТО+ПГТО+КвТО], 365 * 6))
      .map(((n, t)) => {
        (
          [#n],
          [#t],
          [#strfmt("{:.4e}", ready-coeff(lambda-improved-sum, t))],
          [#strfmt("{:.4e}", ready-coeff-avg(lambda-improved-sum, t))],
        )
      })
      .flatten(),
  ),
  caption: [КГ в конце периода обслуживания и средний КГ доработанной системы],
)

#figure(
  ready-coeff-plot(lambda-improved-sum, 365.0 * 24.0),
  caption: [КГ доработанной системы при ГТО],
)
#figure(
  ready-coeff-plot(lambda-improved-sum, 365.0 * 12.0),
  caption: [КГ доработанной системы при ПГТО+ГТО],
)
#figure(
  ready-coeff-plot(lambda-improved-sum, 365.0 * 6.0),
  caption: [КГ доработанной системы при ГТО+ПГТО+КвТО],
)

== Задание 9

Рассчитать коэффициент готовности (средний и стационарный) системы при условии, что система
непрерывно контролируется в межрегламентный период для различных вариантов регламентных
работ (таблица 2). Сравнить результаты, сделать выводы. Построить график изменения среднего
коэффициента готовности от продолжительности межрегламентного периода.

=== Решение

Коэффициент восстановления можно найти очень просто:

$
  mu
  = frac(1, T_в)
  = frac(1, [#weighted-recovery-time(lambda-base, recovery-times)])
  = #{ recovery-coeff(lambda-base) }
$

Тогда формула коэффициента готовности для контролируемой системы примет вид (из предыдущего ПЗ):

$
  overline(K)_г approx frac(mu, lambda + mu)[1 + frac(lambda, mu t_n (lambda + mu))]
$

Результаты расчётов представлены на следующей таблице.

#figure(
  table(
    columns: 4,
    [вид ТО], [период, час], [КГ в конце периода], [средний КГ],
    ..(([ГТО], 365 * 24), ([ГТО+ПГТО], 365 * 12), ([ГТО+ПГТО+КвТО], 365 * 6))
      .map(((n, t)) => {
        (
          [#n],
          [#t],
          [#strfmt("{:.6e}", ready-coeff-recov(lambda-sum, recovery-coeff(lambda-base), t))],
          [#strfmt("{:.6e}", ready-coeff-recov-avg(lambda-sum, recovery-coeff(lambda-base), t))],
        )
      })
      .flatten(),
  ),
  caption: [КГ в конце периода обслуживания и средний КГ непрерывно контролируемой исходной системы],
)

== Задание 10

Рассчитать коэффициент готовности (средний и стационарный) доработанной системы при условии,
что система непрерывно контролируется в межрегламентный период для различных вариантов
регламентных работ (таблица 2). Сравнить результаты, сделать выводы.

=== Решение

#figure(
  table(
    columns: 4,
    [вид ТО], [период, час], [КГ в конце периода], [средний КГ],
    ..(([ГТО], 365 * 24), ([ГТО+ПГТО], 365 * 12), ([ГТО+ПГТО+КвТО], 365 * 6))
      .map(((n, t)) => {
        (
          [#n],
          [#t],
          [#strfmt("{:.6e}", ready-coeff-recov(lambda-improved-sum, recovery-coeff(lambda-improved), t))],
          [#strfmt("{:.6e}", ready-coeff-recov-avg(lambda-improved-sum, recovery-coeff(lambda-improved), t))],
        )
      })
      .flatten(),
  ),
  caption: [КГ в конце периода обслуживания и средний КГ непрерывно контролируемой доработанной системы],
)

== Задание 11

Рассчитать коэффициент оперативной готовности исходной и доработанной системы, не контролируемой
в межрегламентный период, за заданное время (четвертый столбец таблицы 1).

=== Решение

Коэффициент оперативной готовности есть произведение среднего коэффициента готовности и вероятности
безотказной работы в единый промежуток времени

$K_"ог" (t) = overline(K)_г (t) dot P_(accent(T, hat)_с)(t)$

На таблице далее приведены значения КОГ для различных промежутков времени исходной и доработанной системы

#figure(
  table(
    columns: 3,
    [], [$K_"ог"$ исходной системы], [$K_"ог"$ доработанной системы],
    ..(100, 500, 1000, 10000)
      .map(t => {
        (
          [$t=#t$],
          [#strfmt("{:.5e}", oper-ready-coeff(lambda-sum, t))],
          [#strfmt("{:.5e}", oper-ready-coeff(lambda-improved-sum, t))],
        )
      })
      .flatten(),
  ),
  caption: [КГ в конце периода обслуживания и средний КГ непрерывно контролируемой доработанной системы],
)

== Задание 12

Рассчитать коэффициент оперативной готовности исходной и доработанной системы, непрерывно
контролируемой в межрегламентный период, за заданное время (четвертый столбец таблицы 1).

=== Решение

#figure(
  table(
    columns: 3,
    [], [$K_"ог"$ исходной системы], [$K_"ог"$ доработанной системы],
    ..(100, 500, 1000, 10000)
      .map(t => {
        (
          [$t=#t$],
          [#strfmt("{:.5e}", oper-ready-coeff-recov(lambda-sum, recovery-coeff(lambda-base), t))],
          [#strfmt("{:.5e}", oper-ready-coeff-recov(lambda-improved-sum, recovery-coeff(lambda-improved), t))],
        )
      })
      .flatten(),
  ),
  caption: [КГ в конце периода обслуживания и средний КГ непрерывно контролируемой доработанной системы],
)

== Задание 13

Рассчитать коэффициент технического использования системы при различных значениях
продолжительности регламентных работ.

=== Решение

Коэффициент технического использования вычисляется по формуле:

$
  K_"ти" = frac(T_с, T_с + T_в + T_"рр")
$

Результаты вычислений для исходной и доработанной системы при различных режимах
регламентных работ приведена на таблице

#let service-params = (
  "ГТО": (t-work: 365*24, t-service: 7*24*3),
  "ГТО+ПГТО": (t-work: 365*24/2, t-service: 7*24*5),
   "ГТО+ПГТО+КвТО": (t-work: 365*24/4, t-service: 7*24*6),
)

#figure(
  table(
    columns: 3,
    [$T_"рр"$], [$K_"ти"$ исх. системы], [$K_"ти"$ дор. системы],
    ..("ГТО", "ГТО+ПГТО", "ГТО+ПГТО+КвТО").map(kind => {
      let t-w = service-params.at(kind).t-work
      let t-s = service-params.at(kind).t-service

      let t-rec-base = 1 / weighted-recovery-time(lambda-base, recovery-times)
      let t-rec-impr = 1 / weighted-recovery-time(lambda-improved, recovery-times)

      let k-base = t-w / (t-w + t-rec-base + t-s)
      let k-impr = t-w / (t-w + t-rec-impr + t-s)

      ([#kind], [#k-base], [#k-impr])
    }).flatten()
  ),
  caption: [Коэффициент технического использования]
)
