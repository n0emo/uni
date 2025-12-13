#import "template.typ": conf

#show: doc => conf(
  number: [8],
  title: [Рассчет ошибок первого и второго рода при планировании выборочных испытаний],
  variant: [Вариант 16],
  department: [Информационные и вычислительные системы],
  discipline: [Надёжность информационных систем],
  author: [А. Шефнер],
  author_post: [студент группы ИВБ-211],
  teacher: [Е.Н. Шаповалов],
  teacher_post: [к.т.н., доцент кафедры "ИВС"],
  doc: doc,
)

= Ход работы

== Задание

Самостоятельно решить задачу оценивания ошибок перваого и второго рода при
планировании выборочного контроля.

== Исходные данные

#let s1 = 0.03
#let s2 = 0.25
#let N = 19
#let c = (0, 1, 2)
#let a = 0.19
#let b = 0.10

#let combs(k, n) = calc.fact(n) / (calc.fact(k) * calc.fact(n - k))

#let diagbox(text_left, text_right, start: "top", ..kwargs) = {
  let content = context {
    let stroke = kwargs.at("stroke", default: 1pt + black)
    let inset = kwargs.at("inset", default: 0% + 5pt)

    let padded_right = pad(text_right, inset)
    let padded_left = pad(text_left, inset)

    let measure_right = measure(padded_right)
    let measure_left = measure(padded_left)

    // Used to account for big differences between text widths
    let width_diff = calc.abs(measure_right.width - measure_left.width)

    let inner_height = measure_right.height + measure_left.height + width_diff / 10
    let inner_width = measure_right.width + measure_left.width

    box(width: inner_width, height: inner_height) // Empty box to ensure minimal size

    if start == "bottom" {
      place(bottom + right, padded_right)
      place(top + left, line(start: (0%, 100%), end: (100%, 0%), stroke: stroke))
      place(top + left, padded_left)
    } else if start == "top" {
      place(top + right, padded_right)
      place(top + left, line(end: (100%, 100%), stroke: stroke))
      place(bottom + left, padded_left)
    } else {
      panic("Unhandled value '" + start + "' for start parameter, expected 'top' or 'bottom'")
    }
  }
  table.cell(content, ..kwargs, inset: 0pt, breakable: false)
}

Исходные задания для текущего задания приведены далее: \
$s_1 = #s1$ \
$s_2 = #s2$ \
$N = #N$ \
$c = #c$ \
$alpha = #a$ \
$beta = #b$

== Решение

Результаты вычислений вероятностей возможных исходов испытаний по закону 
биномиального распределения для разных $s$ и $k$ представлены на таблице
#ref(label("table-binomial"), supplement: none).

#figure(
  table(
    columns: 7,
    align: center + horizon,
    table.cell(rowspan: 2)[s],
    table.cell(colspan: 6)[k],
    [0], [1], [2], [3], [4], [5],

    ..(0.01, 0.25)
      .map(s => (
        [#s],
        ..range(6).map(k => {
          let result = combs(k, N) * calc.pow(s, k) * calc.pow(1 - s, N - k)
          [#calc.round(result, digits: 5)]
        }),
      ))
      .flatten(),
  ),
  caption: [Вероятности возможных исходов испытаний],
) <table-binomial>

#let p-less(s, c) = {
  range(c + 1).map(c => combs(c, N) * calc.pow(s, c) * calc.pow(1 - s, N - c)).sum()
}

Вероятности допустить ошибки первого и второго рода показаны на таблице
#ref(label("table-errors"), supplement: none).

#figure(
  table(
    columns: 4,
    align: center + horizon,
    table.cell(rowspan: 2)[Вид ошибки],
    table.cell(colspan: 3)[c],
    ..c.map(c => [#c]),

    [$alpha$],
    ..c.map(c => { [#calc.round(1 - p-less(s1, c), digits: 4)] }).flatten(),

    [$beta$],
    ..c.map(c => { [#calc.round(p-less(s2, c), digits: 4)] }).flatten(),
  ),
  caption: [Ошибки первого и второго рода]
) <table-errors>

== Вывод

К значениям ошибок $alpha и beta $ обычно применяют жесткие требования: их
допустимые значения не должны превышать $0.1$. Полученные в примере значения
ошибок не подходят под требования. Это свидетельствует о некачественности
выборки.
