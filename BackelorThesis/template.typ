#let text-size = 12pt
#let text-indent = 12.5mm
#let line-spacing = 1.15em
#let list-marker = [--]

#let date-placeholder = ["#"___""#"_____________"20#"__" г.]
#let date-signature = [
  #"  ____________  " \
  #text(size: text-size - 2pt, "подпись, дата")
]

#let default-author = text(fill: red, "<author: АВТОР РАБОТЫ>")
#let default-theme = text(fill: red, "<theme: ТЕМА РАБОТЫ>")
#let default-speciality = text(fill: red, "<speciality: СПЕЦИАЛЬНОСТЬ>")
#let default-specialization = text(fill: red, "<specialization: СПЕЦИАЛИЗАЦИЯ>")
#let default-source-data = text(fill: red, "<source-data: ИСХОДНЫЕ ДАННЫЕ>")
#let default-problem-contents = text(
  fill: red,
  "<contentes: ПЕРЕЧЕНЬ ВОПРОСОВ>",
)
#let default-graphics = text(
  fill: red,
  "<graphics: ПЕРЕЧЕНЬ ГРАФИЧЕСКОГО МАТЕРИАЛА>",
)
#let default-participants = (
  (
    (
      post: text(fill: red, "<post: ДОЛЖНОСТЬ>"),
      title: text(fill: red, "<title: ЧЕЛОВЕК>"),
    ),
  )
    * 6
)
#let default-steps = range(0, 10).map(i => text(
  fill: red,
  "<steps: Этап " + str(i) + ">",
))

#let ru-alph(pattern) = {
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

#let organization() = {
  align(center)[
    *ФЕДЕРАЛЬНОЕ АГЕНСТВО ЖЕЛЕЗНОДОРОЖНОГО ТРАНСПОРТА* \
    Федеральное государственное бюджетное образовательное учреждение высшего образования \
    *"Петербургский государственный университет путей сообщения Императора Александра I"* \
    *(ФГБОУ ВО ПГУПС)* \

    #line(length: 100%)

    Факультет "Автоматизация и интеллектуальные технологии" \
    Кафедра "Информационные и вычислительные системы"
  ]
}

#let page-title(
  theme: default-theme,
  author: default-author,
  participants: default-participants,
) = page()[
  #organization()

  \ \

  #text(size: text-size + 4pt, align(center)[
    *ПОЯСНИТЕЛЬНАЯ ЗАПИСКА*

    *К бакалаврской работе*

    #strong(author)

    на тему "#theme"

    #(
      participants
        .map(p => {
          grid(
            columns: 3,
            p.post, date-signature, p.title,
          )
        })
        .join()
    )
  ])
]

#let page-problem(
  author: default-author,
  theme: default-theme,
  speciality: default-speciality,
  specialization: default-specialization,
  source-data: default-source-data,
  problem-contents: default-problem-contents,
  graphics: default-graphics,
) = page()[
  #organization()

  \ \

  Специальность (направление): #speciality

  Специализация (профиль, магистерская программа): #specialization

  #align(right, block[
    #align(left)[
      УТВЕРЖДАЮ \
      Зав. кафедрой

      #date-placeholder
    ]
  ])

  #align(center)[
    #text(size: text-size + 4pt, strong("ЗАДАНИЕ")) \
    #strong[на выпускную квалификационную работу обучабщегося]

    #author
  ]

  1. Тема проекта (работы, дессертации): #theme \
    Утверждена приказом по Университету от #date-placeholder №#"___"

  2. Срок сдачи обучающимся законченного проекта (работы, диссертации) \
    #"____________________"

  3. Исходные данные по проекту (работе, диссертации): \
    #source-data

  4. Содержание расчётно-пояснительной записки (перечень подлежащих разработке вопросов): \
    #problem-contents

  5. Перечень графического материала (с точным указанием обязательных чертежей/слайдов): \
    #graphics

  #pagebreak()

  6. Консультанты по ВКР с указанием относящихся к ним разделов проекта (работы, диссертации)

  #table(
    columns: (0.25fr, 0.25fr, 0.25fr, 0.25fr),
    align: center + horizon,

    table.cell(rowspan: 2)[Раздел],
    table.cell(rowspan: 2)[Консультант],
    table.cell(colspan: 2)[Консультант],
    [Задание выдал],
    [Задание принял],

    ..range(0, 16).map(_ => block(height: 1em)),
  )

  7. Дата выдачи задания #"________________________"

  \

  #align(center, grid(
    columns: (0.25fr, 0.25fr),
    align(right)[
      Руководитель ВКР

      Задание принял к исполнению
    ],
    align(left)[
      #{ "   _______________" }

      #{ "   _______________" }
    ],
  ))
]

#let page-plan(steps: default-steps) = page[
  #align(center)[*КАЛЕНДАРНЫЙ ПЛАН*]

  #show table.cell.where(y: 0): set align(center + horizon)
  #show table.cell.where(x: 0): set align(center + horizon)

  #table(
    columns: (0.06fr, 0.45fr - 0.06fr, 0.225fr, 0.225fr),

    table.header(
      [№ \ п/п],
      [Наименование этапов ВКР],
      [Сроки выполнения этапов ВКР],
      [Примечание],
    ),

    ..steps.enumerate().map(((i, s)) => ([#{ i + 1 }], [#s], [], [])).flatten(),
  )

  \

  #align(center, grid(
    columns: (0.25fr, 0.25fr),
    align(right)[
      Обучающийся

      Руководитель ВКР
    ],
    align(left)[
      #{ "   _______________" }

      #{ "   _______________" }
    ],
  ))
]

#let thesis(
  abstract: [],
  author: default-author,
  bibliography-path: none,
  body: [],
  conclusion: [],
  graphics: default-graphics,
  introduction: [],
  participants: default-participants,
  problem-contents: default-problem-contents,
  sourc: default-source-data,
  source-data: default-source-data,
  speciality: default-speciality,
  specialization: default-specialization,
  steps: default-steps,
  supplement: none,
  theme: default-theme,
) = [
  #set text(
    lang: "ru",
    size: text-size,
    font: "Times New Roman",
  )

  #set page(
    margin: (left: 30mm, right: 15mm, top: 20mm, bottom: 20mm),
  )

  #set page(footer: context {
    let page-number = counter(page).get().first()
    if page-number == 1 {
      align(center)[
        Санкт-Петербург \ 2025
      ]
    } else {
      align(center)[#page-number]
    }
  })

  #show list: set list(marker: list-marker)

  #set heading(supplement: none)
  #show heading: it => {
    set text(size: text-size)
    set par(
      spacing: line-spacing,
    )
    it
  }

  #show heading.where(level: 1): it => {
    set align(center)
    set text(size: text-size)
    set par(
      spacing: line-spacing,
    )

    pagebreak()
    upper(it)
  }

  #show heading.where(level: 2): it => {
    set par(first-line-indent: (amount: text-indent, all: true))
    it
  }

  #show heading.where(level: 3): it => {
    set text(style: "italic", weight: "semibold")
    set par(first-line-indent: (amount: text-indent, all: true))
    it
  }

  #show outline.entry.where(level: 1): it => {
    set text(weight: "bold")
    upper(it)
  }

  // #show outline.entry.where(level: 3): none

  #set figure.caption(separator: [ -- ])

  #show figure.where(kind: table): it => {
    block[
      #align(left, it.caption)
      #it.body
    ]
  }

  #show figure.where(kind: image): set figure(supplement: [Рисунок])
  #show figure.where(kind: image): it => {
    block[
      #rect(stroke: 0.5pt, it.body)
      #it.caption
    ]
  }

  #show enum.item: it => {
    pad(left: text-indent - measure([#it.number]).width - enum.body-indent)[#it]
  }

  #show list.item: it => {
    pad(
      left: text-indent - measure([#list-marker]).width - list.body-indent,
    )[#it]
  }

  #show raw: set par(leading: 0.5em)

  #set page(
    header: [
      #counter(footnote).update(0)
    ],
  )

  #show raw: set text(size: 0.9em)

  #set bibliography(style: "gost-r-705-2008-numeric")
  #set ref(supplement: none)
  #show cite: it => {
    show ",": ", "
    it
  }

  #page-title(
    theme: theme,
    author: author,
    participants: participants,
  )

  #page-problem(
    author: author,
    theme: theme,
    speciality: speciality,
    specialization: specialization,
    source-data: source-data,
    problem-contents: problem-contents,
    graphics: graphics,
  )

  #page-plan(steps: steps)

  = Аннотация
  #abstract

  = Введение
  #introduction

  #outline()

  #context {
    set heading(numbering: "1.1")

    body
  }

  = Заключение
  #conclusion

  #if bibliography-path != none {
    bibliography(bibliography-path)
  }

  #if supplement != none {
    set text(size: 12pt)
    set heading(numbering: ru-alph("А"), outlined: false)

    show heading.where(level: 2): set heading(numbering: none)
    show heading.where(level: 3): set heading(numbering: none)

    counter(heading).update(0)

    set page(numbering: none)

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

    supplement
  }
]



