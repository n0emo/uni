#import "../common.typ": *

#show: report.with(number: "9", title: "Сетевое программирование")

== Задания 1 и 8

Напишите программу (клиентскую и серверную часть), позволяющую общаться пользователям внутри
локальной сети. Используйте при этом протокол TCP.

Напишите клиент-серверное приложение, где на клиентской стороне вход в основное окно приложения
осуществляется только после его авторизации на сервере, с возможностью регистрации нового
пользователя. На серверной стороне хеш связки «логин:пароль» пользователей хранится в отдельном
файле.

=== Код

Структура проекта

#figure(
  caption: "Структура проекта",
  image("./assets/project-structure.png", width: 50%),
)

==== Общая часть

`networking/common.py` --- функции и константы, общие для клиентской и серверной сетевых частей

#code-file(read("./src/networking/common.py"), name: "networking/common.py")

`networking/password.py` --- функции для работы с логинами и паролями

#code-file(read("./src/networking/password.py"), name: "networking/password.py")

`data/passwords.json` --- файл, хранящий хеш-связки логин:пароль

#figure(
  caption: "Файл data/passwords.json",
  image("./assets/passwords-json.png", width: 100%),
)

`models/message.py` --- класс сообщения и нужный для него класс цвета

#code-file(read("./src/models/message.py"), name: "models/message.py")

`models/requests.py` --- классы и перечисление запросов

#code-file(read("./src/models/requests.py"), name: "models/requests.py")

`models/status.py` --- перечисление статусных кодов

#code-file(read("./src/models/status.py"), name: "models/status.py")

==== Серверная часть

`server.py` --- отправная точка серверной части

#code-file(read("./src/server.py"), name: "server.py")

`networking/serverside.py` --- поток работы с клиентами

#code-file(read("./src/networking/serverside.py"), name: "networking/serverside.py")

==== Клиентская часть

`client.py` --- отправная точка программы клиента

#code-file(read("./src/client.py"), name: "client.py")

`networking/clientside.py` --- функции клиентской сетевой части

#code-file(read("./src/networking/clientside.py"), name: "networking/clientside.py")

`app/clientwindow.py` --- окно клиентского приложения

#code-file(read("./src/app/clientwindow.py"), name: "app/clientwindow.py")

`app/messagebox.py` --- вспомогательные функции для вызова маленьких окон с сообщением

#code-file(read("./src/app/messagebox.py"), name: "app/messagebox.py")

`app/auth.py` --- виджеты авторизации и регистрации

#code-file(read("./src/app/auth.py"), name: "app/auth.py")

`app/chat.py` --- виджет чата

#code-file(read("./src/app/chat.py"), name: "app/chat.py")

=== Отладка

Логи сервера, которые выводятся в консоль

#figure(
  caption: "Логи сервера",
  image("./assets/server-log.png", width: 70%),
)

Клиентская часть --- окно авторизации

#figure(
  caption: "Окно авторизации",
  image("./assets/auth-window.png", width: 45%),
)

#figure(
  caption: "Неправильный логин или пароль",
  image("./assets/auth-wrong-password.png", width: 45%),
)

#figure(
  caption: "Регистрация с пустым логином",
  image("./assets/register-empty-login.png", width: 45%),
)

#figure(
  caption: "Регистрация с пустым паролем",
  image("./assets/register-empty-password.png", width: 45%),
)

#figure(
  caption: "Регистрация с несовпадающими паролями",
  image("./assets/register-mismatch.png", width: 45%),
)

#figure(
  caption: "Успешная регистрация",
  image("./assets/register-success.png", width: 45%),
)

#figure(
  caption: "Регистрация с уже существующим логином",
  image("./assets/register-exists.png", width: 45%),
)

#figure(
  caption: "Окно чата",
  image("./assets/chat-window.png", width: 45%),
)

#figure(
  caption: "Несколько клиентов в чате одновременно",
  image("./assets/chat-multiple.png", width: 70%),
)
