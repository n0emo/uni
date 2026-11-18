#import "@preview/touying:0.7.4": speaker-note
#import "notes.typ": notes

== Выводы и дальнейшая работа

#let docs-url = "https://gitlab.pgups.ru/pages/typst/pgups/"

#align(horizon)[
  - Общая основа для лабораторных, курсовых и ВКР
  - Результаты Jupyter без ручного переноса
  - Быстрое обновление PDF после небольших правок

  #v(0.4em)
  *Дальнейшая работа:* документация, сверка с требованиями и проверки на разных документах.

  #v(0.5em)
  #grid(
    columns: (145pt, 1fr),
    gutter: 24pt,
    link(docs-url, image("../assets/pgups-docs-qr.svg", width: 145pt)),
    [
      *Руководство и справочник*

      #text(size: 21pt)[#link(docs-url)[gitlab.pgups.ru/pages/typst/pgups/]]

      #v(0.4em)
      #text(size: 23pt)[Планируем опубликовать pgups в *Typst Universe*, официальном реестре пакетов
        Typst.]
    ],
  )
]
#speaker-note(notes.at(11).body)
