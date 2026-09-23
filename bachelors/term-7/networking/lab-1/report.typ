#import "../common.typ": *

#show: report.with(number: "1", title: "Настройка протокола RIP в корпоративной сети")

= Цель работы

Изучить принципы работы протокола RIP для настройки корпоративной сети

= Ход работы

== Самостоятельная работа 1

В результате работы была создана модель сети со следующей топологией:

#figure(
  caption: "топология сети №1",
  image("./assets/topology-1.png", width: 100%),
)

Для каждого маршрутизатора были добавлены адреса подсетей в раздел RIP настроек маршрутизатора. На
рисунке 2 представлен пример для Router0

#figure(
  caption: "настройки RIP для Router0",
  image("./assets/rip-router0.png", width: 80%),
)

Рассмотрим работу протокола RIP для компьютера 11.0.0.11. На рисунке 3 представлена конфигурация RIP
в Router0. На рисунке 4 показан путь пакета от компьютера 11.0.0.11 до компьютера 12.0.0.12 с
включенным Router2, а на рисунке 5 --- с выключенным. Можно увидеть, что после выключения Router2
маршрут пакета стал длиннее и «пошёл в обход» по другим маршрутизаторам.

#figure(
  caption: "результат команды show ip route rip для Router0",
  image("./assets/show-ip-route-router0.png", width: 100%),
)

#figure(
  caption: "результат команды tracert 12.0.0.12 для компьютера 11.0.0.11 до выключения Router2",
  image("./assets/tracert-before-router2-down.png", width: 100%),
)

#figure(
  caption: "результат команды tracert 12.0.0.12 для компьютера 11.0.0.11 после выключения Router2",
  image("./assets/tracert-after-router2-down.png", width: 100%),
)

== Самостоятельная работа №2

В результате работы была создана модель сети со следующей топологией:

#figure(
  caption: "топология сети №2",
  image("./assets/topology-2.png", width: 80%),
)

На рисунках 7 и 8 представлены результаты команды tracert при отправке пакета от PC1 к PC2 до и
после выключения Router5

#figure(
  caption: "результат команды tracert между PC1 и PC2 до выключения Router5",
  image("./assets/tracert-before-router5-down.png", width: 60%),
)

#figure(
  caption: "результат команды tracert между PC1 и PC2 после выключения Router5",
  image("./assets/tracert-after-router5-down.png", width: 60%),
)

= Вывод

В ходе работы был изучен принцип работы протокола RIP
