#import "../common.typ": *

#show: report.with(number: "2", title: "Работа с указателями и строками")

= Цель работы

- освоить работу с указателями.

- Узнать основные методы обработки строк

= Задание

Создать тестовую функцию #strong[main ( )], которая реализует алгоритм, показанный на рисунке:

#figure(
  caption: "Блок-схема алгоритма",
  image("./assets/flowchart.png", height: 45%),
)

== Условие ввода строк

Пока последние 2 символа не являются цифрами.

== Условие обработки строки

Всякие разные.

= Используемые средства

В качестве интегрированной среды разработки использовалась JetBrains CLion.

Для работы в консоли с потоками ввода-вывода использовалась стандартная библиотека `<iostream>`.

Для работы со строками использовалась библиотека `<cstring>`.

= UML-диаграмма программы

#figure(
  caption: "UML-диаграмма класса NString",
  image("./assets/uml-diagram.png", width: 70%),
)

= Код программы с комментариями

#code-file(read("./src/main.cpp"), name: "main.cpp")

#code-file(read("./src/NString.h"), name: "NString.h")

#code-file(read("./src/NString.cpp"), name: "NString.cpp")

= Тестовые примеры

#figure(
  caption: "Результат выполнения тестовых примеров",
  image("./assets/test-output.png", width: 90%),
)
