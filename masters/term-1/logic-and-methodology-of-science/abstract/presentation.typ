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
    short-title: [Реферат],
    date: none,
    institution: [
      Петербургский государственный университет путей сообщения \
      Императора Александра I
    ],
    logo: image("assets/pgups.png", height: 60pt),
  ),
  footer-c: self => context [#here().page() / #notes.len()],
  progress-bar: true,
)

#title-slide(authors: ([Студент #student.group #author], [Преподаватель #teacher.name]))
#speaker-note(notes.at(0).body)

#let ink = rgb("#163458")
#let rule = rgb("#afc7cb")
#let definitions(..entries) = {
  grid(
    columns: (34%, 1fr),
    column-gutter: 0.85em,
    row-gutter: 1.75em,
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
#let takeaway(body) = block(width: 100%, inset: (left: 12pt), stroke: (left: 2pt + rule), body)

== #notes.at(1).title

#align(horizon)[
  #definitions(
    ([Наблюдение], [Фиксирует отдельное событие.]),
    ([Закон], [Связывает величины в целом классе случаев.]),
    ([Модель], [Указывает, как применить закон к данному объекту.]),
  )
  #v(0.6em)
  #takeaway[Какие свойства можно опустить, сохранив точность описания?]
]
#speaker-note(notes.at(1).body)

== #notes.at(2).title

#align(horizon)[
  #definitions(
    ([Истинность], [При каком положении дел утверждение верно?]),
    ([Обоснованность], [Какие данные позволяют его принять?]),
    ([Применимость], [В каких условиях расчёт достаточно точен?]),
  )
]
#speaker-note(notes.at(2).body)

== #notes.at(3).title

#align(horizon)[
  #definitions(
    ([Поппер], [Какие результаты поставили бы гипотезу под сомнение?]),
    ([Дюгем], [Какие ещё допущения потребовались, чтобы получить предсказание?]),
  )
  #v(0.6em)
  #takeaway[Изменив условия опыта, можно проверить, какая предпосылка привела к расхождению.]
]
#speaker-note(notes.at(3).body)

== #notes.at(4).title

#align(horizon)[
  #definitions(
    ([Научный реализм], [Новые предсказания дают основания доверять объяснению.]),
    ([Ван Фраассен], [Для принятия теории достаточно верного описания наблюдаемых явлений.]),
    (
      [Пуанкаре, Уорролл],
      [О реальности можно судить по отношениям, которые сохраняются при смене теории.],
    ),
  )
]
#speaker-note(notes.at(4).body)

== #notes.at(5).title

#align(horizon)[
  #grid(
    columns: (46%, 1fr),
    column-gutter: 1em,
    align: left + horizon,
    [
      #image(
        "assets/arago-spot.jpg",
        width: 100%,
        alt: "В центре круглой тени видна красная светлая точка.",
      )
      #text(size: 0.60em)[Пятно Араго — Пуассона. Фрагмент снимка #link(
          "https://commons.wikimedia.org/wiki/File:Poisson_Spot.jpg",
        )[Clement Eustache] · #link("https://creativecommons.org/licenses/by-sa/4.0/")[CC BY-SA
          4.0].]
    ],
    [
      *Предсказание Френеля* \
      В центре круглой тени возникает светлая точка.

      *Что сохранилось?* \
      Из теории Максвелла следуют формулы отражения и преломления Френеля.
    ],
  )
]
#speaker-note(notes.at(5).body)

== #notes.at(6).title

#align(horizon)[
  #grid(
    columns: (52%, 1fr),
    column-gutter: 1em,
    align: left + horizon,
    [
      #image("assets/gps-iii-sv01.jpg", width: 100%, alt: "Спутник GPS III SV-01 в сборочном цехе.")
      #text(size: 0.60em)[GPS III SV-01 в сборочном цехе. Фото #link(
          "https://commons.wikimedia.org/wiki/File:GPS_III.jpg",
        )[Lockheed Martin].]
    ],
    [
      *Орбита* \
      Период по Ньютону — около *11 ч 58 мин*.

      *Часы* \
      Без поправки опережали бы земные примерно на *38 мкс за сутки*.
    ],
  )
  #v(0.5em)
  #takeaway[Границы приближения зависят от того, что измеряют и с какой точностью.]
]
#speaker-note(notes.at(6).body)

== #notes.at(7).title

#align(horizon)[
  Сходство формул ещё допускает совпадение. Для содержательного сравнения теорий нужно установить:
  #v(0.3em)
  - какие величины в них соответствуют друг другу,
  - как эти величины можно измерить,
  - при каких условиях прежний закон выводится из нового.
]
#speaker-note(notes.at(7).body)

== #notes.at(8).title

#align(horizon)[
  *Какое утверждение проверено?* \
  *Какие альтернативы исключены?* \
  *Где проходят границы проверки?*
  #v(0.7em)
  #takeaway[Мы можем знать, как связаны явления, и оставлять открытым вопрос об окончательном
    объяснении этой связи.]
]
#speaker-note(notes.at(8).body)
