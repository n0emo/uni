#import "../common.typ": *

#show: report.with(
  number: "4",
  title: "Работа с файлами",
  variant: 19,
)

= Постановка задачи

Написать программу, которая читает данные произвольной размерности из одного файла, преобразует
прочитанные данные и записывает получившийся результат в другой файл.

При выполнении задания продемонстрировать применение различных функций для работы с файлами
(`fprintf()`, `fscanf()`, `fgetc()`, `fputc()`, `fgets()`, `fputs()`, `fwrite()`, `fread()`).

Данные представить тремя вариантами:

a) Как двумерные динамические массивы

b) Как строки

c) Как структуры

Программа должна содержать несколько пользовательских функций, помещённых в соответствующие
отдельные файлы. Текст программ снабдить поясняющими комментариями.

== Вариант 19

В файле содержится информация типа «автор» в следующем виде: фамилия автора, направление (физика,
программирование и т.п.), год издания, число страниц. Считать информацию из файла, в другой файл
записать только информацию об книгах последних 5 лет издания.

= Пояснения

В главной функции вызываются функции `test_books_1` и `test_books_2`. Первая тестирует все функции
из файлов `books_1.h` и `books_1.c`. В них используется структура из `book.h` и функции стандартной
библиотеки `fprintf` и `fscanf`. Вторая тестирует все функции из файлов `books_2.h` и `books_2.c`. В
них используются массив строк, двумерный массив строк и функции стандартной библиотеки `fgets`,
`fputs`, `fputc`.

= Код программы

#code-file(read("./src/c_lab_4.c"), name: "c_lab_4.c")

#code-file(read("./src/books_1.c"), name: "books_1.c")

#code-file(read("./src/books_1.h"), name: "books_1.h")

#code-file(read("./src/books_2.c"), name: "books_2.c")

#code-file(read("./src/books_2.h"), name: "books_2.h")

#code-file(read("./src/book.h"), name: "book.h")

= Отладка приложения

Далее представлен вывод консоли, поскольку он не помещается в скриншоты. Вы можете проверить вывод
консоли самостоятельно с помощью exe файла.

#figure(
  kind: image,
  caption: "Вывод программы: тестирование test_books_1",
  ```
  books_1

  Martin - Clean Code Piter 2021 year (464 pages)
  Richter - CLR via C# 2012 year (896 pages)
  Shuuichi - Saiki Kusuo no PSI Nan vol. 1 2012 year (193 pages)
  Prata - C Primer Plus 5th Edition 2004 year (1202 pages)
  Marx - Das Capital 1867 year (200 pages)
  Gyasi - Transcendent Kingdom 2020 year (288 pages)
  Fujio - Doraemon Vol 1 1969 year (657 pages)
  Matthes - Python Crash Course, 3rd Edition 2023 year (552 pages)
  Heisig - Remembering the Kanji vol. I 2001 year (522 pages)
  Yong - An Immense World 2022 year (464 pages)
  Privalov - Entrance to CVFT 1999 year (431 pages)
  Yolen - Dragon's Blood: The Pit Dragon Chronicles, Vol. 1 2021 year (320 pages)
  Ulrickson - A Brief Quadrivium 2023 year (302 pages)
  Tokuno - New Game vol. 01 2013 year (126 pages)
  O'Farrell - Hamnet 2020 year (320 pages)
  Golden - World of Warcraft: Arthas: Rise of the Lich King 2010 year (416 pages)
  Nosonov - Socio-economic geography 2nd Edition 2019 year (476 pages)

  filtered:

  Martin - Clean Code Piter 2021 year (464 pages)
  Richter - CLR via C# 2012 year (896 pages)
  Shuuichi - Saiki Kusuo no PSI Nan vol. 1 2012 year (193 pages)
  Prata - C Primer Plus 5th Edition 2004 year (1202 pages)
  Gyasi - Transcendent Kingdom 2020 year (288 pages)
  Matthes - Python Crash Course, 3rd Edition 2023 year (552 pages)
  Heisig - Remembering the Kanji vol. I 2001 year (522 pages)
  Yong - An Immense World 2022 year (464 pages)
  Yolen - Dragon's Blood: The Pit Dragon Chronicles, Vol. 1 2021 year (320 pages)
  Ulrickson - A Brief Quadrivium 2023 year (302 pages)
  Tokuno - New Game vol. 01 2013 year (126 pages)
  O'Farrell - Hamnet 2020 year (320 pages)
  Golden - World of Warcraft: Arthas: Rise of the Lich King 2010 year (416 pages)
  Nosonov - Socio-economic geography 2nd Edition 2019 year (476 pages)
  ```,
)

#figure(
  kind: image,
  caption: "Вывод программы: тестирование test_books_2",
  ```
  books_2

  Lines readden from file

  Martin Clean_Code_Piter 2021 464
  Richter CLR_via_C# 2012 896
  Shuuichi Saiki_Kusuo_no_PSI_Nan_vol._1 2012 193
  Prata C_Primer_Plus_5th_Edition 2004 1202
  Marx Das_Capital 1867 200
  Gyasi Transcendent_Kingdom 2020 288
  Fujio Doraemon_Vol_1 1969 657
  Matthes Python_Crash_Course,_3rd_Edition 2023 552
  Heisig Remembering_the_Kanji_vol._I 2001 522
  Yong An_Immense_World 2022 464
  Privalov Entrance_to_CVFT 1999 431
  Yolen Dragon's_Blood:_The_Pit_Dragon_Chronicles,_Vol._1 2021 320
  Ulrickson A_Brief_Quadrivium 2023 302
  Tokuno New_Game_vol._01 2013 126
  O'Farrell Hamnet 2020 320
  Golden World_of_Warcraft:_Arthas:_Rise_of_the_Lich_King 2010 416
  Nosonov Socio-economic_geography_2nd_Edition 2019 476

  Chopped lines:

  Martin| Clean_Code_Piter| 2021| 464
  Richter| CLR_via_C#| 2012| 896
  Shuuichi| Saiki_Kusuo_no_PSI_Nan_vol._1| 2012| 193
  Prata| C_Primer_Plus_5th_Edition| 2004| 1202
  Marx| Das_Capital| 1867| 200
  Gyasi| Transcendent_Kingdom| 2020| 288
  Fujio| Doraemon_Vol_1| 1969| 657
  Matthes| Python_Crash_Course,_3rd_Edition| 2023| 552
  Heisig| Remembering_the_Kanji_vol._I| 2001| 522
  Yong| An_Immense_World| 2022| 464
  Privalov| Entrance_to_CVFT| 1999| 431
  Yolen| Dragon's_Blood:_The_Pit_Dragon_Chronicles,_Vol._1| 2021| 320
  Ulrickson| A_Brief_Quadrivium| 2023| 302
  Tokuno| New_Game_vol._01| 2013| 126
  O'Farrell| Hamnet| 2020| 320
  Golden| World_of_Warcraft:_Arthas:_Rise_of_the_Lich_King| 2010| 416
  Nosonov| Socio-economic_geography_2nd_Edition| 2019| 476

  Filtered lines:

  Martin| Clean_Code_Piter| 2021| 464
  Gyasi| Transcendent_Kingdom| 2020| 288
  Matthes| Python_Crash_Course,_3rd_Edition| 2023| 552
  Yong| An_Immense_World| 2022| 464
  Yolen| Dragon's_Blood:_The_Pit_Dragon_Chronicles,_Vol._1| 2021| 320
  Ulrickson| A_Brief_Quadrivium| 2023| 302
  O'Farrell| Hamnet| 2020| 320
  Nosonov| Socio-economic_geography_2nd_Edition| 2019| 476

  Data successfully written to file.

  Press any key to continue . . .
  ```,
)

= Содержимое файлов

`books.txt` -- исходный файл, из которого считываются книги.

#code-file(read("./src/books.txt"), name: "books.txt")

`filtered_1.txt` -- результат работы функций из `books_1`. Условие: год выпуска книги больше или
равен 2000.

#figure(
  caption: "Условие фильтрации в books_1 (filter_struct)",
  image("./assets/filter-struct-condition.png", width: 60%),
)

#figure(
  caption: "Содержимое filtered_1.txt",
  image("./assets/filtered-1-output.png", width: 70%),
)

`filtered_2.txt` -- результат работы функций из `books_2`. Условие: год книги больше или равен
2018.

#figure(
  caption: "Условие фильтрации в books_2 (filter_line)",
  image("./assets/filter-line-condition.png", width: 60%),
)

#figure(
  caption: "Содержимое filtered_2.txt",
  image("./assets/filtered-2-output.png", width: 70%),
)
