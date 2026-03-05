#let title-page(title: "", number: "") = {
  align(center)[
    ФЕДЕРАЛЬНОЕ АГЕНСТВО ЖЕЛЕЗНОДОРОЖНОГО ТРАНСПОРТА

    Федеральное государственное бюджетное образовательное учреждение высшего образования

    "ПЕТЕРБУРГСКИЙ ГОСУДАРСТВЕННЫЙ УНИВЕРСИТЕТ ПУТЕЙ СООБЩЕНИЯ Императора Александра I"

    *(ФГБОУ ВО ПГУПС)*

    #line(length: 100%)

    \ \

    Кафедра "Информационные и вычислительные системы"

    Дисциплина "Метрология, сертификация, стандартизация"

    \ \ \

    *ЛАБОРАТОРНАЯ РАБОТА №#number*

    *"#title"*

    Вариант 13
  ]

  linebreak()
  linebreak()
  linebreak()
  linebreak()

  grid(
    columns: (1.3fr, 0.7fr, 1fr),
    rows: (100pt, 40pt),
    grid.cell[#align(left)[
      Выполнил: \
      Студент группы ИВБ-211
    ]],
    grid.cell[#align(center)[
      #underline(" " * 50) \
      (дата, подпись)
    ]],
    grid.cell[#align(right)[А. Шефнер]],
    grid.cell[
      Проверил: \
      доц. каф. "ИВС"
    ],
    grid.cell[#align(center)[
      #underline(" " * 50) \
      (дата, подпись)
    ]],
    grid.cell[#align(right)[А.М. Барановский]],
  )

  align(center + bottom)[Санкт-Петербург \ 2025]
}

#let text-size = 14pt
#let text-indent = 12.5mm
#let line-spacing = 1em
#let list-marker = [--]

#let conf(
  title: "",
  number: "",
  doc,
) = {
  set text(
    lang: "ru",
    size: text-size,
    font: "Times New Roman",
  )

  set page(
    margin: (left: 30mm, right: 15mm, top: 20mm, bottom: 20mm),
  )

  page[
    #title-page(
      title: title,
      number: number,
    )
  ]

  set page(
    numbering: "1",
    number-align: right,
  )

  show list: set list(marker: list-marker)

  set par(
    leading: line-spacing,
    spacing: line-spacing,
    first-line-indent: (amount: 12.5mm, all: true),
    justify: true,
  )

  set heading(supplement: none)
  show heading: it => {
    set text(size: text-size)
    set par(
      spacing: line-spacing,
    )
    it.body
  }

  show heading.where(level: 1): it => {
    set align(center)
    set text(size: text-size)
    set par(
      spacing: line-spacing,
    )

    pagebreak()
    upper(it.body)
  }

  show heading.where(level: 2): it => {
    set par(first-line-indent: (amount: text-indent, all: true))
    it
  }

  show heading.where(level: 3): it => {
    set text(style: "italic", weight: "semibold")
    set par(first-line-indent: (amount: text-indent, all: true))
    it
  }

  show outline.entry.where(level: 1): it => {
    set text(weight: "bold")
    upper(it)
  }

  show outline.entry.where(level: 3): none

  set figure.caption(separator: [ -- ])

  show figure.where(kind: table): it => {
    block[
      #align(left, it.caption)
      #it.body
    ]
  }

  show figure.where(kind: image): set figure(supplement: [Рисунок])
  show figure.where(kind: image): it => {
    block[
      #rect(stroke: 0.5pt, it.body)
      #it.caption
    ]
  }

  show enum.item: it => {
    pad(left: text-indent - measure([#it.number]).width - enum.body-indent)[#it]
  }

  show list.item: it => {
    pad(
      left: text-indent - measure([#list-marker]).width - list.body-indent,
    )[#it]
  }

  show raw: set par(leading: 0.5em)

  set page(
    header: [
      #counter(footnote).update(0)
    ],
  )

  show raw: set text(size: 0.9em)

  set bibliography(style: "gost-r-705-2008-numeric")
  set ref(supplement: none)
  show cite: it => {
    show ",": ", "
    it
  }

  doc
}

#let supplement(content) = {
  counter(heading).update(0)
  set page(numbering: none)

  set text(size: 12pt)

  let ru-alph(pattern) = {
    let alphabet = "абвгдежзиклмнопрстуфхцчшщэюя".split("")
    let f(i) = {
      let letter = alphabet.at(i)
      let str = ""
      for char in pattern {
        if char == "а" {
          str += letter
        } else if char == "А" {
          str += upper(letter)
        } else {
          str += char
        }
      }
      str
    }
    f
  }

  set heading(numbering: ru-alph("А"), outlined: false)
  show heading.where(level: 2): set heading(numbering: none)
  show heading.where(level: 3): set heading(numbering: none)

  show heading.where(level: 1): it => {
    set text(size: 12pt)
    pagebreak()
    [
      #align(right)[ПРИЛОЖЕНИЕ #counter(heading).display()]
      #align(center, it.body)
    ]
  }

  show table: it => {
    set text(size: 11pt)
    set par(first-line-indent: 0em)
    set list(indent: 0em)
    set enum(indent: 0em)
    it
  }

  show figure: set figure(numbering: num => (
    counter(heading).display() + str(num)
  ))

  content
}
