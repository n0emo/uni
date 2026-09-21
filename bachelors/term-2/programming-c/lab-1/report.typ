#import "../common.typ": *

#show: report.with(
  number: "1",
  title: "Реализация стандартных строковых функций",
  variant: 17,
)

= Постановка задачи

Требуется написать свою собственную реализацию стандартных функций `strlen`, `strcpy`, `strcat` и
`strcmp` двумя разными способами.

= Пояснения

Мои 8 функций находятся в файлах `strfuncs.h` (объявление) и `strfuncs.c` (реализация). Первый
способ реализации -- с помощью индексации, второй -- с помощью указателей. В файлах `tests.h` и
`tests.c` находятся тесты, которые для каждой стандартной функции выводят в консоль результат
выполнения этой функции и двух моих.

= Код программы

#code-file(read("./src/main.c"), name: "main.c")

#code-file(read("./src/strfuncs.h"), name: "strfuncs.h")

#code-file(read("./src/strfuncs.c"), name: "strfuncs.c")

#code-file(read("./src/tests.h"), name: "tests.h")

#code-file(read("./src/tests.c"), name: "tests.c")

= Отладка приложения

#figure(
  caption: "Результат выполнения тестов",
  image("./assets/debug-output.png", height: 70%),
)
