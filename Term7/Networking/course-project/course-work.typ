#import "template.typ": conf

#show: doc => conf(
  title: "Организация взаимодействия устройств в системе диспетчеризации информации",
  author: "А. Шефнер",
  group: "ИВБ-211",
  doc: doc,
)

#heading(outlined: false)[Аннотация]

#include "chapters/abstract.typ"

#outline()

= Введение

#include "chapters/introduction.typ"

= 1. Использованные технологии

#include "chapters/1-techstack.typ"

= 2. Сетевой уровень 

#include "chapters/2-network-layer.typ"

= 3. Транспортный уровень

#include "chapters/3-transport-layer.typ"

= 4. Уровень приложения

#include "chapters/4-application-layer.typ"

= 5. Проверка работоспособности

#include "chapters/5-demo.typ"

= Заключение

#include "chapters/conclusion.typ"

#bibliography("bibliography.yaml")
