#import "template.typ": conf

#show: doc => conf(
  title: "Организация взаимодействия устройств в системе диспетчеризации информации",
  author: "А. Шефнер",
  group: "ИВБ-211",
  teacher: "И.А. Молодкин",
  teacher-post: [ст. преп. каф. "ИВС"],
  doc: doc,
)

#heading(outlined: false)[Аннотация]

#include "chapters/abstract.typ"

#outline()

= Введение

#include "chapters/introduction.typ"

= 1. Использованные технологии

#include "chapters/1-techstack.typ"

= 3. Протокол WebSocket

#include "chapters/2-transport-layer.typ"

= 4. Обмен данных на уровене приложений

#include "chapters/3-application-layer.typ"

= 5. Развёртка в сети ПГУПС

#include "chapters/4-deploy.typ"

= Заключение

#include "chapters/conclusion.typ"

#bibliography("bibliography.yaml")

#include "supplement/supplement.typ"
