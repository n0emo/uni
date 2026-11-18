#import "@preview/touying:0.7.4": speaker-note
#import "notes.typ": notes

== От Jupyter Notebook к отчёту

#align(horizon)[
  #grid(
    columns: (1fr, 1fr),
    gutter: 24pt,
    [
      *Блокнот Jupyter*

      #text(size: 18pt)[Фрагмент стандартного PDF-экспорта]

      #image("../assets/notebook-before.svg", width: 100%)
    ],
    [
      *Отчёт Typst и pgups*

      #text(size: 18pt)[Таблица из лабораторной работы № 3]

      #image("../assets/notebook-after.svg", width: 100%)

      #v(0.5em)
      #text(size: 21pt)[Данные сохранены. Подпись и номер таблицы добавлены автоматически.]
    ],
  )

  #v(0.5em)
  #text(size: 21pt)[Jupyter сохраняет результаты, Callisto читает ячейки, pgups оформляет отчёт.]
]
#speaker-note(notes.at(7).body)
