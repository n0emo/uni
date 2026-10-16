#import "../common.typ": *

#show: report.with(number: "10", title: "Базы данных")

== Задания

=== Задание 4

Спроектируйте базу данных и напишите программу «Электронный каталог продуктов магазина» с
возможностью сохранения, удаления и редактирования данных.

==== Код

`shop.py` --- отправная точка приложения

#code-file(read("./src/shop.py"), name: "shop.py")

`shopdb.py` --- функции работы с базой данных

#code-file(read("./src/shopdb.py"), name: "shopdb.py")

==== Отладка

#figure(
  caption: "Меню приложения",
  image("./assets/shop-menu.png", width: 50%),
)

#figure(
  caption: "Добавление новой записи",
  image("./assets/shop-add.png", width: 55%),
)

#figure(
  caption: "Вывод всех записей",
  image("./assets/shop-list.png", width: 85%),
)

=== Задание 9

Спроектируйте базу данных и напишите программу «Электронная телефонная книга» с возможностью
сохранения, удаления и редактирования данных.

==== Код

Отличается лишь набором констант в файле исходного кода функций базы данных.

#code-file(read("./src/contacts.py"), name: "contacts.py")

`contactsdb.py` --- функции работы с базой данных

#code-file(read("./src/contactsdb.py"), name: "contactsdb.py")

==== Отладка

#figure(
  caption: "Вывод всех записей телефонной книги",
  image("./assets/contacts-list.png", width: 60%),
)
