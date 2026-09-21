#import "../common.typ": *

#show: report.with(
  number: "6",
  title: "Односвязный список",
  variant: 19,
)

= Постановка задачи

+ Создать односвязный список. Данными списка должны быть структуры из задания № 4 соответствующего
  варианта. Создать функции для записи списка в файл и чтения списка из файла.
+ Реализовать минимум все функции, приведённые в лекции, предложить свои варианты функций работы со
  списком.
+ Создать меню для управления работы со списком.

= Пояснения

Мой список является отдельной структурой `list`, в которой находится количество элементов, ссылка на
голову и ссылка на хвост листа. Данные хранятся в узлах `node` в виде указателей на `void`. Это
позволяет Вам использовать данный список не только со структурой `book`, но и вообще с любыми
другими структурами, если Вы работаете с ними через указатели. Для очистки списка сначала примените
процедуру `free` для каждого элемента (это может сделать моя функция `list_apply`), а затем вызовите
`list_delete`.

= Код программы

#code-file(read("./src/c_lab_6.c"), name: "c_lab_6.c")

#code-file(read("./src/list.c"), name: "list.c")

#code-file(read("./src/list.h"), name: "list.h")

#code-file(read("./src/booksfile.c"), name: "booksfile.c")

#code-file(read("./src/booksfile.h"), name: "booksfile.h")

#code-file(read("./src/book.c"), name: "book.c")

#code-file(read("./src/book.h"), name: "book.h")

= Отладка приложения

#figure(
  caption: "Меню программы",
  image("./assets/menu.png", width: 80%),
)

#figure(
  caption: "Загрузка книг из файла",
  image("./assets/load-from-file.png", width: 60%),
)

#figure(
  caption: "Хвост списка после загрузки",
  image("./assets/list-tail.png", width: 60%),
)

#figure(
  caption: "Вывод всего списка книг",
  image("./assets/show-list.png", width: 70%),
)

= Содержимое файлов

`books.txt` -- исходный файл, из которого считываются книги.

#figure(
  caption: "Содержимое файла books.txt",
  image("./assets/books-txt.png", width: 80%),
)
