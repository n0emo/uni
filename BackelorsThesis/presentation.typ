#import "@preview/touying:0.7.4": *
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *

#import themes.university: *

#show: codly-init.with()
#codly(languages: codly-languages)

#set text(lang: "ru")

#show raw: set text(size: 17pt)

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
    subtitle: [
      Разработка интерфейса взаимодействия между информационной системой и пользовательскими
      программами на основе среды выполнения WebAssembly
    ],
    author: [Шефнер Альберт],
    short-title: [Wassel],
    date: datetime(year: 2026, month: 6, day: 25),
    institution: [
      Петербургский государственный университет путей сообщения \ Императора Александра I
    ],
    logo: logo,
  ),
  progress-bar: true,
)

#title-slide(
  authors: (
    "Студент ИВБ-211 Шефнер Альберт",
    "Научный руководитель: д.т.н, доцент Хетчиков Дмитрий Михайлович",
  ),
)

#include "./presentation/01-problem.typ"
#include "./presentation/02-wasm.typ"
#include "./presentation/03-architecture.typ"
#include "./presentation/04-wassel.typ"
#include "./presentation/05-sdk.typ"
#include "./presentation/06-bench.typ"
#include "./presentation/07-economy.typ"
#include "./presentation/08-labor.typ"
#include "./presentation/09-conclusion.typ"
