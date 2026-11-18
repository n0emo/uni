#import "@preview/touying:0.7.4": *
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#import themes.university: *
#import "config.typ": author, course, presentation-date, student, teacher, title
#import "style.typ": custom-style
#import "presentation/notes.typ": notes

#show: codly-init.with()
#codly(languages: codly-languages)

#set text(lang: "ru")
#show raw: set text(size: 17pt)
#set par(justify: false)
#set list(spacing: 0.6em)

#let logo = box[
  #let height = 60pt
  #box(image("assets/ivs.png", height: height))
  #box(image("assets/pgups.png", height: height))
]

#show: university-theme.with(
  aspect-ratio: "4-3",
  config-common(datetime-format: "[day].[month].[year]"),
  config-info(
    title: [],
    subtitle: title,
    author: author,
    short-title: [Реферат],
    date: presentation-date,
    institution: [
      Петербургский государственный университет путей сообщения \
      Императора Александра I
    ],
    logo: logo,
  ),
  footer-c: self => context [#here().page() / #notes.len()],
  progress-bar: true,
)
#show: custom-style

#title-slide(
  authors: (
    [Студент #student.group #author],
    [Преподаватель: #teacher.post #teacher.name],
  ),
)
#speaker-note(notes.at(0).body)

#include "presentation/slides.typ"
