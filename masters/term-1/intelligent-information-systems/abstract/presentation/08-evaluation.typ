#import "@preview/touying:0.7.4": speaker-note
#import "notes.typ": notes

== Время сборки учебных документов

#align(center + horizon)[
  #image("../assets/build-times.svg", width: 80%)

  #text(size: 20pt)[
    190 документов, из них 180 с pgups. Typst 0.15.1, Apple M2, 8 ГиБ.

    Медианы замеров pgups: полная сборка *175 мс*, после сохранения *136 мс*.
  ]
]
#speaker-note(notes.at(9).body)
