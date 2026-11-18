#import "@preview/touying:0.7.4": speaker-note
#import "notes.typ": notes

== Реализация требований

#align(horizon)[
  #table(
    columns: (1fr, 1fr),
    stroke: (bottom: 0.5pt + luma(75%)),
    inset: 12pt,
    table.header([Требование], [Средство Typst]),
    [Шрифт, поля, отступы], [Параметры `set`],
    [Вид заголовков и подписей], [Правила `show`],
    [Номера и ссылки], [Счётчики и метки],
    [Список источников], [Hayagriva и CSL-стиль],
  )

  #v(0.5em)
  Добавление рисунка обновляет его номер и ссылки при следующей сборке.
]
#speaker-note(notes.at(3).body)
