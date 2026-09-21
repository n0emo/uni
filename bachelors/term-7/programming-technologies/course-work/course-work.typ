#import "template.typ": conf

#show: doc => conf(
  title: "Архитектура web-сервера на базе плагинов WebAssembly",
  author: "А. Шефнер",
  group: "ИВБ-211",
  teacher: "Д.И. Баталов",
  teacher-post: [доц. каф. "ИВС"],
  doc: doc,
)

#include "chapters/abstract.typ"
#outline()
#include "chapters/introduction.typ"
#include "chapters/01-architecture.typ"
#include "chapters/02-http.typ"
#include "chapters/03-plugins.typ"
#include "chapters/04-running.typ"
#include "chapters/conclusion.typ"
#bibliography("bibliography.yaml")
#include "supplement.typ"
