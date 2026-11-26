#import "@preview/touying:0.7.4": *
#import themes.university: *
#import "config.typ": author, student, teacher, title
#import "notes.typ": notes

#set document(title: title, author: author)
#set text(lang: "ru")
#show: university-theme.with(
  aspect-ratio: "4-3",
  config-info(
    subtitle: title,
    author: author,
    short-title: [Доклад],
    date: none,
    institution: [
      Петербургский государственный университет путей сообщения \
      Императора Александра I
    ],
    logo: image("assets/pgups.png", height: 54pt),
  ),
  footer-c: self => context [#here().page() / #notes.len()],
  progress-bar: true,
)

#title-slide(
  authors: (
    [Студент #student.group \ #author],
    [Преподаватель: Л.~В.~Мурейко \ #text(size: 0.85em)[#teacher.post]],
  ),
)
#speaker-note(notes.at(0).body)

#let ink = rgb("#163458")
#let accent = rgb("#2b6cb0")
#let soft = rgb("#eef4f7")
#let rule = rgb("#afc7cb")

#let definitions(gutter: 1.2em, ..entries) = {
  grid(
    columns: (30%, 1fr),
    column-gutter: 0.8em,
    row-gutter: gutter,
    align: left + top,
    ..entries
      .pos()
      .map(((label, description)) => (
        text(weight: "bold", fill: ink, label),
        description,
      ))
      .flatten(),
  )
}

#let takeaway(body) = block(
  width: 100%,
  inset: (left: 12pt, y: 3pt),
  stroke: (left: 2.5pt + rule),
  text(size: 0.86em, body),
)

#let card(heading, body, text-size: 0.78em) = block(
  width: 100%,
  height: 100%,
  inset: 10pt,
  radius: 4pt,
  fill: soft,
  stroke: 0.75pt + rule,
  align(left + top)[
    #text(size: 0.88em, weight: "bold", fill: ink, heading)
    #v(0.25em)
    #set list(spacing: 0.35em)
    #text(size: text-size, body)
  ],
)

#let step-box(num, label, detail, box-align: left) = block(
  width: 100%,
  height: 100%,
  inset: 9pt,
  radius: 4pt,
  fill: soft,
  stroke: (top: 2.5pt + ink),
  align(box-align + top)[
    #text(size: 0.70em, weight: "bold", fill: accent)[#num] \
    #text(size: 0.88em, weight: "bold", fill: ink)[#label]
    #v(0.25em)
    #text(size: 0.74em)[#detail]
  ],
)

== #notes.at(1).title

#align(horizon)[
  #definitions(
    ([Информация], [Сырые данные, вычисления и сообщения в сети до проверки и осмысления.]),
    ([Знание], [Проверенный результат, встроенный в систему понятий и научный оборот.]),
    ([Краудсорсинг], [Передача задачи открытому сетевому сообществу (Дж.~Хау, 2006).]),
  )
  #v(0.75em)
  #takeaway[
    В математике нельзя договориться голосованием: результат либо доказан, либо нет. Это делает её
    строгой проверкой возможностей научного краудсорсинга.
  ]
]
#speaker-note(notes.at(1).body)

== #notes.at(2).title

#align(horizon)[
  #v(0.5em)
  #grid(
    columns: (1fr, 1fr),
    rows: (7.4em, 7.4em),
    column-gutter: 0.85em,
    row-gutter: 0.85em,
    card([1. Вычислительный])[
      Добровольцы отдают свободные мощности ПК или облачных GPU. \
      #text(fill: luma(35%))[Примеры: Charity Engine, GIMPS.]
    ],
    card([2. Открытая дискуссия])[
      Учёные и энтузиасты совместно строят доказательство в блогах и вики. \
      #text(fill: luma(35%))[Примеры: Polymath8, Polymath16.]
    ],

    card([3. Стихийные площадки])[
      Решения возникают на анонимных форумах вне академических структур. \
      #text(fill: luma(35%))[Пример: «проблема Харухи» на 4chan.]
    ],
    card([4. Сообщества и верификация])[
      Децентрализованная работа в чатах и GitHub с машинной проверкой. \
      #text(fill: luma(35%))[Примеры: BB(5) в Coq, Equational Theories в Lean~4.]
    ],
  )
]
#speaker-note(notes.at(2).body)

== #notes.at(3).title

#align(horizon)[
  #v(0.35em)
  #grid(
    columns: (1fr, 1fr),
    rows: (12.2em,),
    column-gutter: 0.9em,
    card([Сумма трёх кубов: число 42], text-size: 0.76em)[
      Задача $x^3 + y^3 + z^3 = 42$ стояла *65 лет* (решена в 2019~г.).

      - Сеть *Charity Engine*: > 500~000 домашних ПК.
      - Более *1 млн часов* фоновых вычислений.
      - Решение из 17-значных чисел:
      #v(0.15em)
      #text(size: 0.82em)[
        $42 = (-80538738812075974)^3$ \
        $+ 80435758145817515^3 + 12602123297335631^3$
      ]
    ],
    card([Простые числа: проект GIMPS], text-size: 0.76em)[
      Добровольный поиск простых чисел Мерсенна $2^p - 1$ (с 1996~г.).

      - Октябрь 2024: открыто $2^(136279841) - 1$.
      - Длина — *41~024~320* десятичных цифр.
      - Сдвиг формата: от домашних CPU к облачной сети GPU (Л.~Дюрант).
    ],
  )
  #v(0.55em)
  #takeaway[
    Краудсорсинг расширяет вычислительную базу, но постановка и алгоритм остаются за отдельными
    исследователями.
  ]
]
#speaker-note(notes.at(3).body)

== #notes.at(4).title

#align(horizon)[
  #v(0.25em)
  #text(size: 0.92em)[
    *Polymath8 (2013–2014):* сближение соседних простых чисел ($p_(n+1) - p_n <= N$)
  ]
  #v(0.45em)
  #grid(
    columns: (1fr, auto, 1fr, auto, 1fr, auto, 1fr),
    rows: (6.4em,),
    column-gutter: 0.3em,
    align: center + horizon,
    step-box([Май 2013], [70 000 000], [Итан Чжан \ (исходный прорыв)], box-align: center),
    text(size: 1.15em, weight: "bold", fill: ink)[$arrow.r$],
    step-box([2013], [4 680], [Polymath8a \ (блог и вики)], box-align: center),
    text(size: 1.15em, weight: "bold", fill: ink)[$arrow.r$],
    step-box([Нояб. 2013], [600], [Дж.~Мейнард \ (новый метод)], box-align: center),
    text(size: 1.15em, weight: "bold", fill: ink)[$arrow.r$],
    step-box([2014], [246], [Polymath8b \ (совместный итог)], box-align: center),
  )
  #v(0.6em)
  #text(size: 0.9em)[
    *Polymath16 (2018):* задача Хадвигера — Нельсона о раскраске плоскости. Граф любителя Обри ди
    Грея (1~581 вершина) участники коллективно сжали до *509 вершин*.
  ]
  #v(0.45em)
  #takeaway[
    Статьи выходят под общим псевдонимом *D. H. J. Polymath*: научная дискуссия ускоряется с лет до
    месяцев.
  ]
]
#speaker-note(notes.at(4).body)

== #notes.at(5).title

#align(horizon)[
  #v(0.25em)
  #text(size: 0.88em)[
    *Задача Т.~Радо (1962):* сколько максимум шагов сделает останавливающаяся машина Тьюринга с 5
    состояниями? Кандидат на *47~176~870* шагов найден в 1989~г., но не доказан 35 лет.
  ]
  #v(0.45em)
  #grid(
    columns: (1fr, 1fr, 1fr),
    rows: (9.2em,),
    column-gutter: 0.65em,
    step-box([Этап 1 · 2022], [Discord и GitHub], [
      Тристан Стерен запускает `bbchallenge.org`. Пространство из ≈~17 трлн машин сводят к ≈~181
      млн.
    ]),
    step-box([Этап 2 · 2022–2024], [Решатели], [
      Участники со всего мира пишут программы (*deciders*), доказывающие зацикливание миллионов
      машин.
    ]),
    step-box([Этап 3 · 2 июля 2024], [Проверка в Coq], [
      Аноним `mxdys` формализует все случаи (включая *Skelet \#17*). Код компилируется:
      $"BB"(5) = 47 176 870$.
    ]),
  )
  #v(0.55em)
  #takeaway[
    Решающий вклад внёс анонимный участник без проверки дипломов: доверие обеспечила *машинная
    верификация*.
  ]
]
#speaker-note(notes.at(5).body)

== #notes.at(6).title

#align(horizon)[
  #v(0.2em)
  #text(size: 0.9em)[
    *Equational Theories Project* (Теренс Тао, осень 2024): классификация всех следствий между
    *4~694* законами магм — всего *22~028~942* потенциальных импликаций.
  ]
  #v(0.55em)
  #set text(size: 0.9em)
  #definitions(
    gutter: 0.85em,
    (
      [Слой 1 · Люди],
      [Сотни профессионалов и любителей на GitHub: стратегии, контрпримеры, сложные случаи.],
    ),
    (
      [Слой 2 · Автоматика],
      [Автоматические пруверы (*Vampire*, *Prover9*, *Mace4*) и перебор конечных моделей.],
    ),
    (
      [Слой 3 · Верификатор],
      [Обязательная формальная проверка каждой из 22 млн связей в *Lean~4*.],
    ),
  )
  #v(0.55em)
  #set text(size: 1.05em)
  #takeaway[
    Усложнение знания: объём доказательства превышает возможности ручного рецензирования и требует
    гибридной человеко-машинной архитектуры.
  ]
]
#speaker-note(notes.at(6).body)

== #notes.at(7).title

#align(horizon)[
  #v(0.25em)
  #text(size: 0.9em)[
    *Задача о суперперестановке:* сколько минимум серий аниме нужно посмотреть, чтобы встретить все
    $n!$ порядков просмотра?
  ]
  #v(0.45em)
  #grid(
    columns: (1fr, 1fr),
    rows: (10.4em,),
    column-gutter: 0.9em,
    card([2011 · 4chan (`/sci/`)])[
      Анонимный пользователь в треде выводит строгую нижнюю границу:
      #v(0.2em)
      #align(center, text(size: 0.86em)[$L(n) >= n! + (n-1)! + (n-2)! + n - 3$])
      #v(0.2em)
      Но результат *7 лет* остаётся в архивах любительской вики незамеченным наукой.
    ],
    card([2018 · Возвращение в науку])[
      Математик Робин Хьюстон находит доказательство, формализует его с коллегами и публикует в
      *OEIS*.

      В графе автора официально указано: \
      *«Anonymous 4chan poster»*.
    ],
  )
  #v(0.55em)
  #takeaway[
    Появление информации в сети ещё не означает трансляции знания: без фильтрации открытия теряются
    в информационном шуме.
  ]
]
#speaker-note(notes.at(7).body)

== #notes.at(8).title

#align(horizon)[
  #set text(size: 0.78em)
  #table(
    columns: (22%, 39%, 39%),
    inset: 9pt,
    stroke: 0.6pt + rule,
    fill: (x, y) => if y == 0 { ink } else if calc.odd(y) { soft } else { white },
    table.header(
      text(fill: white, weight: "bold")[Критерий],
      text(fill: white, weight: "bold")[Традиционная модель],
      text(fill: white, weight: "bold")[Краудсорсинговая модель],
    ),
    [*Динамика*],
    [Последовательная работа лабораторий; цикл проверки — месяцы и годы.],
    [Параллельный поиск в сети; быстрые итерации и гибрид с алгоритмами.],

    [*Трансляция*],
    [Рецензируемые журналы, монографии, конференции.],
    [GitHub, блоги, вики, Discord; трансляция идёт прямо в ходе поиска.],

    [*Достоверность*],
    [Институт репутации, учёные степени, рецензирование экспертами.],
    [Открытая проверка сообществом и *формальная верификация* (Coq, Lean~4).],

    [*Авторство и риски*],
    [Чёткое личное авторство; высокий порог входа для непрофессионалов.],
    [Коллективные псевдонимы и анонимность; риск *информационного шума*.],
  )
]
#speaker-note(notes.at(8).body)

== #notes.at(9).title

#align(horizon)[
  - *Новая динамика:* краудсорсинг ускоряет и масштабирует научный поиск — от вычислений (*Charity
    Engine*, *GIMPS*) до коллективных доказательств (*Polymath*, *BB(5)*, *Lean~4*).
  - *Новый критерий достоверности:* в точных науках доверие смещается от регалий автора к *машинно
    проверяемому результату* (Coq, Lean).
  - *Предел сетевой трансляции:* пример *4chan* показывает, что без институтов фиксации и отбора
    знание легко растворяется в информационном потоке.
  #v(0.6em)
  #takeaway[
    Краудсорсинг не отменяет академическую науку, а перестраивает её: соединяет сетевую открытость с
    новыми инструментами строгой проверки.
  ]
]
#speaker-note(notes.at(9).body)
