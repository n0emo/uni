#let title-page(
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
}

#let text-indent = 12.5mm

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

  set par(
    first-line-indent: (amount: 12.5mm, all: true),
    justify: true,
  )

  page[
    #title-page(
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
  ]

  set page(
    numbering: "1",
    number-align: right,
  )

  show heading.where(level: 1): it => {
    set align(center)
    set text(size: 14pt)

    pagebreak()
    upper(it)
  }

  show heading.where(level: 2): it => {
    set text(size: 14pt)
    set par(first-line-indent: (amount: text-indent, all: true))

    pad(left: text-indent, it)
  }

  show heading.where(level: 3): it => {
    set text(size: 14pt, style: "italic")
    set par(first-line-indent: (amount: text-indent, all: true))

    pad(left: text-indent, it)
  }

  show figure.where(
    kind: table,
  ): set figure.caption(position: top)

  show figure.where(kind: image): set figure(supplement: [Рисунок])
  show figure.where(kind: image): it => {
    rect(stroke: 0.5pt, it.body)
    it.caption
  }

  show list: set list(marker: [--])
  show list: set list(indent: text-indent)
  show enum: set enum(indent: text-indent)

  doc
}
