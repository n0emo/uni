#let title-page(
  title: text,
  author: text,
  group: text,
  teacher: text,
  teacher-post: text,
) = {
  align(center)[
    ФЕДЕРАЛЬНОЕ АГЕНСТВО ЖЕЛЕЗНОДОРОЖНОГО ТРАНСПОРТА

    Федеральное государственное бюджетное образовательное учреждение высшего образования

    "ПЕТЕРБУРГСКИЙ ГОСУДАРСТВЕННЫЙ УНИВЕРСИТЕТ ПУТЕЙ СООБЩЕНИЯ Императора Александра I"

    *(ФГБОУ ВО ПГУПС)*

    \ \

    Кафедра "Информационные и вычислительные системы"


    \ \ \

    *ПОЯСНИТЕЛЬНАЯ ЗАПИСКА*

    к курсовой работе

    по дисциплине "Технологии программирования"

    *"#title"*
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
        Студент группы #group
      ]
    ],
    grid.cell[
      #align(center)[
        #underline(" " * 50) \
        (дата, подпись)
      ]
    ],
    grid.cell[
      #align(right)[
        #author
      ]
    ],
    grid.cell[
      Проверил: \
      #teacher-post
    ],
    grid.cell[
      #align(center)[
        #underline(" " * 50) \
        (дата, подпись)
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

#let assessment-list(
  author: text,
  group: text,
  teacher: text,
  teacher-post: text,
) = [
  Оценочный лист результатов курсовой работы \
  Ф.И.О. студента #author \
  Группа #group

  #set text(size: 12pt)

  #align(right)[Таблица 1]
  #table(
    columns: (0.3fr, 1.25fr, 1.5fr, 1.25fr, 0.70fr),
    align: center + horizon,

    table.header(
      [№ \ п/п],
      [Материалы необходимые для оценки знаний, умений и навыков],
      [Показатель оценивания],
      [Критерии оценивания],
      [Шкала оценивания],
    ),

    table.cell(rowspan: 4)[1],

    table.cell(rowspan: 4)[Пояснительная записка к курсовой работе],

    table.cell(rowspan: 2)[\1. Соответствие исходных данных выданному заданию],
    [Соответствует],
    [15],
    [Плохо соответствует],
    [5],

    table.cell(rowspan: 2)[\2. Обоснованность принятых решений],
    [Все решения обоснованы],
    [15],
    [Решения обоснованы слабо],
    [5],

    table.cell(colspan: 4)[Итого количество баллов  по п. 1],
    [*30*],

    table.cell(rowspan: 2)[2],
    table.cell(rowspan: 2)[Качество выполнения задания],
    table.cell(rowspan: 2)[\3. Полнота реализации требования задания],

    [Высокая],
    [20],
    [Невысокая],
    [10],

    table.cell(colspan: 4)[Итого количество баллов  по п. 2],
    [*20*],

    table.cell(rowspan: 4)[3],
    table.cell(rowspan: 4)[Графические материалы],

    table.cell(rowspan: 2)[
      \1. Соответствие разработанных схем пояснительной записке
    ],
    [Соответствует],
    [10],
    [Не соответствует],
    [5],

    table.cell(rowspan: 2)[
      \2. Соответствие требованиям ГОСТ
    ],

    [Высокое],
    [10],
    [Невысокое ],
    [5],

    table.cell(colspan: 4)[Итого количество баллов по п. 3],
    [*20*],

    table.cell(colspan: 4)[*Итого количество баллов*],
    [*70*],
  )

  #pagebreak()

  #align(right)[Таблица 2]
  #table(
    columns: (1.25fr, 0.9fr, 1fr, 1.75fr, 0.5fr),
    align: center + horizon,

    table.header(
      [Вид контроля],
      [Материалы, необходимые для оценивания],
      [Максимальное количество баллов в процессе оценивания],
      [Процедура оценивания],
      [Оценка],
    ),

    [\1. Текущий контроль],
    [Курсовая работа],
    [70],
    align(left)[
      Количество баллов определяется в соответствии с таблицей 1 \
      Допуск к защите курсовой работе > 50 баллов
    ],
    [],

    [\2. Промежуточная аттестация],
    [Защита курсовой работы],
    [30],
    align(left)[
      - получены полные ответы на вопросы – 25-30 баллов;
      - получены достаточно полные ответы на вопросы – 20-24 балла;
      - получены неполные ответы на вопросы – 11-19 баллов;
      - не получены ответы на вопросы или ответы не раскрыты – 0-10 баллов.
    ],
    [],

    table.cell(colspan: 2)[*Итого*],
    [*100*],
    [],
    [],

    [\3. Итоговая оценка],
    table.cell(colspan: 3, align(left)[
      "Отлично" -- 86-100 баллов; \
      "Хорошо" -- 75-85 баллов; \
      "Удовлетворительно" -- 60-74 балла; \
      «Неудовлетворительно» -- менее 60 баллов.
    ]),
  )

  #align(bottom)[
    #columns(3)[
      #align(left)[
        #teacher-post \
      ]

      #colbreak()
      #colbreak()

      #align(center)[
        #teacher \ \
        #underline(" " * 50) \
        (дата, подпись)
      ]
    ]
  ]
]

#let text-size = 14pt
#let text-indent = 12.5mm
#let line-spacing = 1.15em
#let list-marker = [--]

#let conf(
  title: text,
  group: text,
  author: text,
  teacher: text,
  teacher-post: text,
  doc: content,
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
      author: author,
      group: group,
      teacher: teacher,
      teacher-post: teacher-post,
    )
  ]

  set page(
    numbering: "1",
    number-align: right,
  )

  show list: set list(marker: list-marker)

  page(assessment-list(
    author: author,
    group: group,
    teacher: teacher,
    teacher-post: teacher-post,
  ))

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
    pad(left: text-indent - measure([#list-marker]).width - list.body-indent)[#it]
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

  show figure: set figure(numbering: num => counter(heading).display() + str(num))

  content
}
