#let title_page(
  number: text,
  name: text,
  department: text,
  discipline: text,
  variant: text,
  author: text,
  author_post: text,
  teacher_post: text,
  teacher: text,
) = {
  set text(
    lang: "ru",
    size: 14pt,
    font: "Times New Roman",
  )

  set page(
    margin: (left: 30mm, right: 15mm, top: 20mm, bottom: 20mm),
  )

  align(center)[
    ФЕДЕРАЛЬНОЕ АГЕНСТВО ЖЕЛЕЗНОДОРОЖНОГО ТРАНСПОРТА

    Федеральное государственное бюджетное образовательное учреждение высшего образования

    "ПЕТЕРБУРГСКИЙ ГОСУДАРСТВЕННЫЙ УНИВЕРСИТЕТ ПУТЕЙ СООБЩЕНИЯ Императора Александра I"

    *(ФГБОУ ВО ПГУПС)*

    \ \

    Кафедра "#department"

    Дисциплина "#discipline"

    \ \ \

    *ОТЧЁТ*

    *ПО ПРАКТИЧЕСКОЙ РАБОТЕ №#number*

    *"#name"*

    #variant
  ]

  linebreak()
  linebreak()
  linebreak()
  linebreak()

  grid(
    columns: (1.3fr, 0.7fr, 1fr),
    rows: (100pt, 40pt),
    grid.cell[
      #align(left)[
        Выполнил: \
        #author_post

      ]
    ],
    grid.cell[
      #align(center)[
        #underline(" " * 50)
      ]
    ],
    grid.cell[
      #align(right)[
        #author
      ]
    ],
    grid.cell[
      Проверил: \
      #teacher_post
    ],
    grid.cell[
      #align(center)[
        #underline(" " * 50)
      ]
    ],
    grid.cell[
      #align(right)[
        #teacher
      ]
    ],
  )

  align(center + bottom)[Санкт-Петербург \ 2025]

  pagebreak()
}

#let conf(
  number: text,
  title: text,
  department: text,
  discipline: text,
  variant: text(""),
  author_post: text,
  author: text,
  teacher: text,
  teacher_post: text,
  doc: content,
) = {
  set text(
    lang: "ru",
    size: 14pt,
    font: "Times New Roman",
  )

  set page(
    margin: (left: 30mm, right: 15mm, top: 20mm, bottom: 20mm),
  )

  title_page(
    number: number,
    name: title,
    department: department,
    discipline: discipline,
    variant: variant,
    author: author,
    author_post: author_post,
    teacher: teacher,
    teacher_post: teacher_post,
  )

  set page(
    numbering: "1",
    number-align: right,
  )

  set par(
    first-line-indent: (amount: 5mm, all: true),
    justify: true,
  )

  show figure.where(
    kind: table,
  ): set figure.caption(position: top)

  show figure.where(kind: image): set figure(supplement: [Рисунок])

  doc
}
