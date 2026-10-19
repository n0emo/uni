#import "../common.typ": *
#import "@preview/cetz:0.5.2"
#import "@preview/cetz-plot:0.1.4": plot
#import "@preview/zap:0.6.0"

#show: report.with(
  number: "2",
  title: "Моделирование электрических цепей с реактивными элементами",
)

#show table: it => align(center, it)

// Параметры варианта 5
#let R0 = 10.0
#let L0 = 10e-3
#let C0 = 250e-6
#let E0 = 25.0

#let num(x, d: 2) = {
  let s = str(calc.round(x, digits: d))
  if d > 0 {
    if not s.contains(".") { s += "." }
    s += "0" * (d - s.split(".").at(1).len())
  }
  s.replace(".", ",").replace("-", "−")
}

#let load(path) = (
  read(path)
    .split("\n")
    .filter(l => l.trim() != "")
    .map(l => {
      let p = l.split(" ").filter(s => s != "").map(float)
      (p.at(0), p.at(1), p.at(3))
    })
)

// Схемы замещения
#let scheme(kind) = zap.circuit({
  import zap: *
  let xs = if kind == "rlc" { (0, 3, 6) } else { (0, 3) }
  let xe = xs.last()
  vsource("e", (0, 0), (0, 3), label: $E$)
  resistor("r", (0, 3), (3, 3), label: $R$)
  if kind == "rc" {
    capacitor("x", (3, 3), (3, 0), label: $C$)
  } else if kind == "rl" {
    inductor("x", (3, 3), (3, 0), label: $L$)
  } else {
    inductor("l", (3, 3), (6, 3), label: $L$)
    capacitor("c", (6, 3), (6, 0), label: $C$)
  }
  wire((0, 0), (xe, 0))
  ground("g", (0, 0))
  for (i, x) in xs.enumerate() {
    node("n" + str(i + 1), (x, 3), label: (content: [#(i + 1)], anchor: "north-west"))
  }
})

// Аналитические решения для последовательной RLC-цепи
#let rlc(R) = {
  let a = R / (2 * L0)
  let w0 = 1 / calc.sqrt(L0 * C0)
  if a < w0 - 1e-9 {
    let wd = calc.sqrt(w0 * w0 - a * a)
    (
      kind: "osc",
      a: a,
      w0: w0,
      wd: wd,
      u: t => E0 * (1 - calc.exp(-a * t) * (calc.cos(wd * t) + a / wd * calc.sin(wd * t))),
      i: t => E0 / (L0 * wd) * calc.exp(-a * t) * calc.sin(wd * t),
    )
  } else if a < w0 + 1e-9 {
    (
      kind: "crit",
      a: a,
      w0: w0,
      u: t => E0 * (1 - (1 + a * t) * calc.exp(-a * t)),
      i: t => E0 / L0 * t * calc.exp(-a * t),
    )
  } else {
    let d = calc.sqrt(a * a - w0 * w0)
    let (s1, s2) = (-a + d, -a - d)
    (
      kind: "aper",
      a: a,
      w0: w0,
      s1: s1,
      s2: s2,
      u: t => E0 * (1 - (s2 * calc.exp(s1 * t) - s1 * calc.exp(s2 * t)) / (s2 - s1)),
      i: t => E0 / (L0 * (s1 - s2)) * (calc.exp(s1 * t) - calc.exp(s2 * t)),
    )
  }
}

#let rc-u = t => E0 * (1 - calc.exp(-t / (R0 * C0)))
#let rc-i = t => E0 / R0 * calc.exp(-t / (R0 * C0))
#let rl-i = t => E0 / R0 * (1 - calc.exp(-t * R0 / L0))
#let rl-u = t => E0 * calc.exp(-t * R0 / L0)

#let max-err(data, f, col) = calc.max(..data.map(r => calc.abs(r.at(col) - f(r.at(0)))))
#let at-time(data, t) = data.at(int(calc.round(t / (data.at(1).at(0) - data.at(0).at(0)))))

// График: результат моделирования и аналитический расчёт
#let graph(data, col, f, xmax, xlabel: $t$, ylabel: "", ymax: auto, ymin: 0) = cetz.canvas({
  import cetz.draw: *
  plot.plot(
    size: (6.2, 4.2),
    x-label: [$t$, мс],
    y-label: ylabel,
    x-min: 0,
    x-tick-step: xmax / 5,
    x-max: xmax,
    y-min: ymin,
    y-max: ymax,
    legend: "inner-south-east",
    {
      plot.add(
        data.map(r => (r.at(0) * 1e3, r.at(col))),
        style: (stroke: 1.2pt + blue),
        label: "ngspice",
      )
      plot.add(
        domain: (0, xmax),
        samples: 200,
        t => f(t * 1e-3),
        style: (stroke: (paint: red, dash: "dashed", thickness: 0.9pt)),
        label: "расчёт",
      )
    },
  )
})

#let pair(data, f-u, f-i, xmax, ulabel, ilabel, umax: auto, imax: auto, umin: 0, imin: 0) = grid(
  columns: 2,
  column-gutter: 14pt,
  graph(data, 1, f-u, xmax, ylabel: ulabel, ymax: umax, ymin: umin),
  graph(data, 2, f-i, xmax, ylabel: ilabel, ymax: imax, ymin: imin),
)

#let rc = load("rc.txt")
#let rl = load("rl.txt")
#let cases = (
  (R: 1.0, data: load("rlc_1.txt"), xmax: 15),
  (R: 10.0, data: load("rlc_10.txt"), xmax: 15),
  (R: 2 * calc.sqrt(L0 / C0), data: load("rlc_crit.txt"), xmax: 15),
  (R: 50.0, data: load("rlc_50.txt"), xmax: 60),
)

= Цель работы

Моделирование простейших электрических схем с реактивными элементами в программе-симуляторе
ngspice, освоение методов расчёта электрических параметров цепей первого и второго порядков в
квазистационарном приближении.

= Задание

Для варианта 5 (таблица~@tbl-variant):

+ составить программы ngspice для RC-цепи, RL-цепи и последовательной RLC-цепи;
+ вывести графики тока и напряжения на реактивных элементах;
+ подобрать пределы времени моделирования для наиболее информативного отображения процессов;
+ для RLC-цепи подобрать значения $R$ и $L$ так, чтобы получить апериодический и колебательный
  переходные процессы;
+ сравнить результаты моделирования с ручными расчётами.

#figure(
  caption: "Исходные данные варианта 5",
  table(
    columns: 4,
    [*$R$, Ом*], [*$L$, мГн*], [*$C$, мкФ*], [*$E$, В*],
    [10], [10], [250], [25],
  ),
) <tbl-variant>

= Ход работы

Моделирование выполнено в ngspice 47 в пакетном режиме (`ngspice -b`) под macOS. Источник
постоянной ЭДС включается в момент $t = 0$, начальные условия нулевые: ключ `uic` в директиве
`.tran` отключает расчёт рабочей точки по постоянному току и начинает анализ с нулевых напряжений
на конденсаторах и токов в катушках. Данные для графиков записываются командой `wrdata`
и считываются в отчёт из текстовых файлов; перед записью результат приводится к равномерной
сетке командой `linearize`. Схемы нарисованы в Typst (пакет zap), номера узлов на них совпадают с
номерами в программах. Ток источника в ngspice отсчитывается от плюса к минусу внутри источника,
поэтому ток цепи берётся как $-i(V_1)$.

== RC-цепь

Схема цепи приведена на рис.~@fig-rc-scheme, программа ngspice~-- на
рис.~@fig-rc-code.

#figure(
  caption: [Схема RC-цепи],
  scheme("rc"),
) <fig-rc-scheme>

#figure(
  caption: [Программа ngspice для RC-цепи (`rc.cir`)],
  align(left, raw(read("rc.cir"), lang: "spice", block: true)),
) <fig-rc-code>

Постоянная времени цепи
$ tau = R C = 10 dot 250 dot 10^(-6) = 2","5 "мс". $
Процесс зарядки заканчивается практически за $(4 dots 5) tau$, поэтому время моделирования выбрано
равным 15 мс ($6 tau$) с шагом 50 мкс. Аналитическое решение уравнения
$R C thin dif u_C \/ dif t + u_C = E$ при $u_C (0) = 0$:
$ u_C (t) = E (1 - e^(-t \/ tau)), quad i (t) = E / R e^(-t \/ tau). $
Начальный ток $i(0) = E \/ R = 2","5$ А, установившееся напряжение $u_C (infinity) = E = 25$ В.

#figure(
  caption: [Напряжение на конденсаторе и ток в RC-цепи],
  pair(rc, rc-u, rc-i, 15, [$u_C$, В], [$i$, А]),
) <fig-rc-plots>

Сравнение результатов моделирования и расчёта приведено в таблице~@tbl-rc. Графики
на рис.~@fig-rc-plots практически совпадают.

#figure(
  caption: [RC-цепь: моделирование и расчёт],
  table(
    columns: 5,
    [*$t$*], [*$u_C$ расчёт, В*], [*$u_C$ ngspice, В*], [*$i$ расчёт, А*], [*$i$ ngspice, А*],
    ..(1, 2, 3, 5)
      .map(k => {
        let t = k * R0 * C0
        let r = at-time(rc, t)
        ([#k$tau$], [#num(rc-u(t), d: 3)], [#num(r.at(1), d: 3)], [#num(rc-i(t), d: 3)], [#num(r.at(2), d: 3)])
      })
      .flatten(),
  ),
) <tbl-rc>

Наибольшая абсолютная разность между кривыми на всём интервале составляет
#num(max-err(rc, rc-u, 1) * 1e3, d: 2) мВ по напряжению и #num(max-err(rc, rc-i, 2) * 1e3, d: 2) мА
по току.

== RL-цепь

Схема цепи приведена на рис.~@fig-rl-scheme, программа~-- на рис.~@fig-rl-code.

#figure(
  caption: [Схема RL-цепи],
  scheme("rl"),
) <fig-rl-scheme>

#figure(
  caption: [Программа ngspice для RL-цепи (`rl.cir`)],
  align(left, raw(read("rl.cir"), lang: "spice", block: true)),
) <fig-rl-code>

Постоянная времени
$ tau = L / R = (10 dot 10^(-3)) / 10 = 1 "мс". $
Время моделирования выбрано равным 8 мс ($8 tau$), шаг 25 мкс. Решение уравнения
$L thin dif i \/ dif t + R i = E$ при $i(0) = 0$:
$ i (t) = E / R (1 - e^(-t \/ tau)), quad u_L (t) = E e^(-t \/ tau). $
Установившийся ток $i(infinity) = E \/ R = 2","5$ А, в момент включения всё напряжение источника
приложено к катушке: $u_L (0) = E = 25$ В.

#figure(
  caption: [Напряжение на катушке и ток в RL-цепи],
  pair(rl, rl-u, rl-i, 8, [$u_L$, В], [$i$, А]),
) <fig-rl-plots>

#figure(
  caption: [RL-цепь: моделирование и расчёт],
  table(
    columns: 5,
    [*$t$*], [*$u_L$ расчёт, В*], [*$u_L$ ngspice, В*], [*$i$ расчёт, А*], [*$i$ ngspice, А*],
    ..(1, 2, 3, 5)
      .map(k => {
        let t = k * L0 / R0
        let r = at-time(rl, t)
        ([#k$tau$], [#num(rl-u(t), d: 3)], [#num(r.at(1), d: 3)], [#num(rl-i(t), d: 3)], [#num(r.at(2), d: 3)])
      })
      .flatten(),
  ),
) <tbl-rl>

Графики приведены на рис.~@fig-rl-plots, числовое сравнение~-- в таблице~@tbl-rl. Наибольшая
абсолютная разность составляет #num(max-err(rl, rl-u, 1) * 1e3, d: 2) мВ по напряжению и
#num(max-err(rl, rl-i, 2) * 1e3, d: 3) мА по току.

== Последовательная RLC-цепь

Схема цепи приведена на рис.~@fig-rlc-scheme, программа~-- на рис.~@fig-rlc-code. Напряжение
снимается с конденсатора (узел 3). Программа последовательно изменяет сопротивление резистора
командой `alter` и повторяет анализ переходного процесса для четырёх значений $R$ при
неизменных $L = 10$ мГн и $C = 250$ мкФ.

#figure(
  caption: [Схема последовательной RLC-цепи],
  scheme("rlc"),
) <fig-rlc-scheme>

#figure(
  caption: [Программа ngspice для RLC-цепи (`rlc.cir`)],
  align(left, raw(read("rlc.cir"), lang: "spice", block: true)),
) <fig-rlc-code>

Характеристическое уравнение $p^2 + 2 alpha p + omega_0^2 = 0$, где
$alpha = R \/ (2 L)$ -- коэффициент затухания, $omega_0 = 1 \/ sqrt(L C)$ -- частота собственных
колебаний:
$ omega_0 = 1 / sqrt(10 dot 10^(-3) dot 250 dot 10^(-6)) = #num(1 / calc.sqrt(L0 * C0), d: 1) "рад/с". $
Вид процесса определяется соотношением $alpha$ и $omega_0$. Критическое сопротивление, при
котором $alpha = omega_0$:
$ R_"кр" = 2 sqrt(L / C) = 2 sqrt((10 dot 10^(-3)) / (250 dot 10^(-6))) = #num(2 * calc.sqrt(L0 / C0), d: 3) "Ом". $
При $R < R_"кр"$ корни комплексно-сопряжённые и процесс колебательный, при $R > R_"кр"$ корни
вещественные и процесс апериодический. Значение $R = 10$ Ом из варианта лежит ниже $R_"кр"$,
поэтому процесс в исходной схеме колебательный; для колебательного режима с более выраженными
колебаниями принято $R = 1$ Ом, для апериодического~-- $R = 50$ Ом, дополнительно рассмотрен
критический режим $R = R_"кр"$. Индуктивность оставлена равной значению варианта: сопротивление
полностью определяет вид процесса.

Для $u_C (0) = 0$, $i (0) = 0$ расчётные выражения имеют вид:

- колебательный режим ($omega_d = sqrt(omega_0^2 - alpha^2)$):
  $ u_C = E [1 - e^(-alpha t) (cos omega_d t + alpha / omega_d sin omega_d t)], quad
  i = E / (omega_d L) e^(-alpha t) sin omega_d t; $
- критический режим:
  $ u_C = E [1 - (1 + alpha t) e^(-alpha t)], quad i = E / L t e^(-alpha t); $
- апериодический режим ($p_(1,2) = -alpha plus.minus sqrt(alpha^2 - omega_0^2)$):
  $ u_C = E [1 - (p_2 e^(p_1 t) - p_1 e^(p_2 t)) / (p_2 - p_1)], quad
  i = E / (L (p_1 - p_2)) (e^(p_1 t) - e^(p_2 t)). $

Параметры рассмотренных режимов приведены в таблице~@tbl-rlc-params.

#figure(
  caption: [Параметры переходного процесса в RLC-цепи],
  table(
    columns: 5,
    [*$R$, Ом*], [*$alpha$, 1/с*], [*Корни, 1/с*], [*Характер процесса*], [*Макс. откл. $u_C$, мВ*],
    ..cases
      .map(c => {
        let m = rlc(c.R)
        let roots = if m.kind == "osc" {
          [$-#num(m.a, d: 0) plus.minus j #num(m.wd, d: 1)$]
        } else if m.kind == "crit" {
          [$-#num(m.a, d: 1)$ (двукр.)]
        } else {
          [$#num(m.s1, d: 1)$; $#num(m.s2, d: 1)$]
        }
        let name = (osc: "колебательный", crit: "критический", aper: "апериодический").at(m.kind)
        (
          [#num(c.R, d: if c.R == 1.0 or c.R == 10.0 or c.R == 50.0 { 0 } else { 3 })],
          [#num(m.a, d: 1)],
          roots,
          [#name],
          [#num(max-err(c.data, m.u, 1) * 1e3, d: 1)],
        )
      })
      .flatten(),
  ),
) <tbl-rlc-params>

Результаты моделирования для колебательных режимов показаны на рис.~@fig-rlc-osc, для
критического и апериодического режимов~-- на рис.~@fig-rlc-aper.

#figure(
  caption: [Колебательный режим: напряжение на конденсаторе и ток при $R = 1$ Ом (вверху) и
    $R = 10$ Ом (внизу)],
  stack(
    spacing: 10pt,
    pair(cases.at(0).data, rlc(1.0).u, rlc(1.0).i, 15, [$u_C$, В], [$i$, А], umax: 50, imax: auto, imin: auto),
    pair(cases.at(1).data, rlc(10.0).u, rlc(10.0).i, 15, [$u_C$, В], [$i$, А], umax: 30, imin: auto),
  ),
) <fig-rlc-osc>

#figure(
  caption: [Критический режим ($R = R_"кр"$, вверху, и апериодический режим $R = 50$ Ом, внизу):
    напряжение на конденсаторе и ток],
  stack(
    spacing: 10pt,
    pair(cases.at(2).data, rlc(cases.at(2).R).u, rlc(cases.at(2).R).i, 15, [$u_C$, В], [$i$, А]),
    pair(cases.at(3).data, rlc(50.0).u, rlc(50.0).i, 60, [$u_C$, В], [$i$, А]),
  ),
) <fig-rlc-aper>

В колебательном режиме напряжение на конденсаторе превышает $E$, а ток меняет знак. Первый
максимум $u_C$ достигается в момент $t_m = pi \/ omega_d$ и равен
$ u_(C max) = E (1 + e^(-pi alpha \/ omega_d)). $
Сравнение с результатом моделирования приведено в таблице~@tbl-overshoot.

#figure(
  caption: [Первый максимум напряжения на конденсаторе в колебательном режиме],
  table(
    columns: 5,
    [*$R$, Ом*], [*$t_m$ расчёт, мс*], [*$t_m$ ngspice, мс*], [*$u_(C max)$ расчёт, В*], [*$u_(C max)$ ngspice, В*],
    ..cases
      .slice(0, 2)
      .map(c => {
        let m = rlc(c.R)
        let top = c.data.fold(c.data.at(0), (a, r) => if r.at(1) > a.at(1) { r } else { a })
        (
          [#num(c.R, d: 0)],
          [#num(calc.pi / m.wd * 1e3, d: 2)],
          [#num(top.at(0) * 1e3, d: 2)],
          [#num(E0 * (1 + calc.exp(-calc.pi * m.a / m.wd)), d: 2)],
          [#num(top.at(1), d: 2)],
        )
      })
      .flatten(),
  ),
) <tbl-overshoot>

В апериодическом режиме ($R = 50$ Ом) напряжение монотонно стремится к $E$ без перерегулирования;
процесс определяется медленным корнем, постоянная времени
$1 \/ abs(p_1) = #num(1e3 / calc.abs(rlc(50.0).s1), d: 1)$ мс, поэтому установление длится
около 50 мс. Ток нарастает до максимума и затем плавно спадает к нулю. В критическом режиме
($R = R_"кр"$) установление происходит быстрее всего без колебаний.

= Выводы

В ngspice построены модели RC-, RL- и последовательной RLC-цепи для варианта 5
($R = 10$ Ом, $L = 10$ мГн, $C = 250$ мкФ, $E = 25$ В). Для RC-цепи постоянная времени равна
$tau = 2","5$ мс, для RL-цепи~-- $tau = 1$ мс; моделирование воспроизводит экспоненциальные
законы заряда конденсатора и нарастания тока в катушке, расхождение с аналитическими решениями не
превышает #num(calc.max(max-err(rc, rc-u, 1), max-err(rl, rl-u, 1)) * 1e3, d: 1) мВ.

Вид переходного процесса в RLC-цепи определяется соотношением $R$ и
$R_"кр" = 2 sqrt(L \/ C) = #num(2 * calc.sqrt(L0 / C0), d: 2)$ Ом. При $R = 10$ Ом и
$R = 1$ Ом процесс колебательный (перерегулирование
#num(E0 * calc.exp(-calc.pi * rlc(10.0).a / rlc(10.0).wd) / E0 * 100, d: 1) % и
#num(E0 * calc.exp(-calc.pi * rlc(1.0).a / rlc(1.0).wd) / E0 * 100, d: 1) % соответственно), при
$R = 50$ Ом~-- апериодический, при $R = R_"кр"$~-- критический. Результаты моделирования
совпадают с расчётом по формулам для корней характеристического уравнения, что подтверждает
корректность моделей и выбранных пределов времени.
