#let title-page(
  title: text,
  author: text,
  author_post: text,
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

    к курсовому проекту

    по дисциплине "Сети и телекоммуникации"

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
      ст. преп.
    ],
    grid.cell[
      #align(center)[
        #underline(" " * 50)
      ]
    ],
    grid.cell[
      #align(right)[
        И.А. Молодкин
      ]
    ],
  )

  align(center + bottom)[Санкт-Петербург \ 2025]
}

#let assessment-list = [
  Оценочный лист результатов курсового проекта \
  Ф.И.О. студента А. Шефнер \
  Группа ИВБ-211

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

    table.cell(rowspan: 4)[Пояснительная записка к курсовому проекту],

    table.cell(rowspan: 2)[1. Соответствие исходных данных выданному заданию],
    [Соответствует],
    [15],
    [Плохо соответствует],
    [5],

    table.cell(rowspan: 2)[2. Обоснованность принятых решений],
    [Все решения обоснованы],
    [15],
    [Решения обоснованы слабо],
    [5],

    table.cell(colspan: 4)[Итого количество баллов  по п. 1],
    [*30*],

    table.cell(rowspan: 2)[2],
    table.cell(rowspan: 2)[Качество выполнения задания],
    table.cell(rowspan: 2)[3. Полнота реализации требования задания],

    [Высокая],
    [20],
    [Невысокая],
    [10],

    table.cell(colspan: 4)[Итого количество баллов  по п. 2],
    [*20*],

    table.cell(rowspan: 4)[3],
    table.cell(rowspan: 4)[Графические материалы],

    table.cell(rowspan: 2)[
      1. Соответствие разработанных схем пояснительной записке
    ],
    [Соответствует],
    [10],
    [Не соответствует],
    [5],

    table.cell(rowspan: 2)[
      2. Соответствие требования ГОСТ
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
    columns: (0.75fr, 1fr, 1fr, 1.75fr, 0.5fr),
    align: center + horizon,

    table.header(
      [Вид контроля],
      [Материалы, необходимые для оценивания],
      [Максимальное количество баллов в процессе оценивания],
      [Процедура оценивания],
      [Оценка],
    ),

    [1. Текущий контроль],
    [Курсовой проект],
    [70],
    [
      Количество баллов определяется в соответствии с таблицей 1 \
      Допуск к защите курсового проекта > 50 баллов
    ],
    [],

    [2. Промежуточная аттестация],
    [Защита курсового проекта],
    [30],
    [
      - получены полные ответы на вопросы – 25-30 баллов;
      - получены достаточно полные ответы на вопросы – 20-24 балла;
      - получены неполные ответы на вопросы – 11-19 баллов;
      - не получены ответы на вопросы или ответы не раскрыты – 0-10 баллов.
    ],
    [],

    table.cell(colspan: 2)[Итого],
    [100],
    [],
    [],

    [3. Итоговая оценка],
    table.cell(colspan: 3)[
      - "Отлично" - 86-100 баллов;
      - "Хорошо" - 75-85 баллов;,
      - "Удовлетворительно" - 60-74 балла;,
      - «Неудовлетворительно» - менее 60 баллов.,
    ]
  )
]

#let text-indent = 12.5mm

#let conf(
  title: text,
  author_post: text,
  author: text,
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

  page[
    #title-page(
      title: title,
      author: author,
      author_post: author_post,
    )
  ]

  set page(
    numbering: "1",
    number-align: right,
  )

  page(assessment-list)

  set par(
    first-line-indent: (amount: 12.5mm, all: true),
    justify: true,
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

  set bibliography(style: "gost-r-705-2008-numeric", )

  doc
}
