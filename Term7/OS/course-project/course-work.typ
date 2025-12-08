#import "template.typ": conf

#show: doc => conf(
  title: "Разработка кроссплатформенной библиотеки для написания многопоточных веб-серверов",
  author: "А. Шефнер",
  group: "ИВБ-211",
  teacher: "М.В. Полищук",
  teacher-post: [ст. преп. каф. "ИВС"],
  doc: doc,
)

#heading(outlined: false)[Аннотация]

#include "chapters/abstract.typ"

#outline()

= Введение

#include "chapters/introduction.typ"

= 1. Требования к библиотеке

#include "chapters/01-requirements.typ"

= 2. Организация процесса сборки

#include "chapters/02-project-organization.typ"

= 3. Разработка базовых функций

#include "chapters/03-core.typ"

= 4. Разработка абстракций над примитивами ОС

#include "chapters/04-os-abstractions.typ"

= 5. Разработка функций HTTP-сервера

#include "chapters/05-http.typ"

= 6. Пример использования библиотеки

#include "chapters/06-example.typ"

= Заключение

#include "chapters/conclusion.typ"

#bibliography("bibliography.yaml")

#include "supplement/supplement.typ"
