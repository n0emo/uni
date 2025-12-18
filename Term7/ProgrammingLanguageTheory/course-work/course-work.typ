#import "template.typ": conf

#show: doc => conf(
  title: "Разработка программного эмулятора процессора MOS6502",
  author: "А. Шефнер",
  group: "ИВБ-211",
  teacher: "И.А. Молодкин",
  teacher-post: [ст. преп. каф. "ИВС"],
  doc: doc,
)

#include "chapters/abstract.typ"
#outline()
#include "chapters/introduction.typ"
#include "chapters/01-history.typ"
#include "chapters/02-architecture.typ"
#include "chapters/03-emulator.typ"
#include "chapters/04-cc65.typ"
#include "chapters/05-snake.typ"
#include "chapters/conclusion.typ"

#bibliography("bibliography.yaml")
