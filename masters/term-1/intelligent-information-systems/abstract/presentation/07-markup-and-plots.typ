#import "@preview/touying:0.7.4": speaker-note
#import "notes.typ": notes

== Текстовая разметка и графики

#align(horizon)[
  #text(size: 21pt)[Markdown задаёт заголовок: `## Функции принадлежности`]

  #grid(
    columns: (1fr, 1fr),
    gutter: 24pt,
    [
      *Блокнот Jupyter*

      #image("../assets/markup-plots-before.svg", width: 100%)
    ],
    [
      *Отчёт Typst и pgups*

      #image("../assets/markup-plots-after.svg", width: 100%)
    ],
  )
]
#speaker-note(notes.at(8).body)
