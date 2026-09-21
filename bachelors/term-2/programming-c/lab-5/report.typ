#import "../common.typ": *

#show: report.with(
  number: "5",
  title: "Алгоритмы сортировки",
  variant: 19,
)

= Постановка задачи

+ Создать функцию сортировки «пузырьком» итерационную и рекурсивную.
+ Создать функцию сортировки «вставками», для поиска места вставки в отсортированную часть массива
  применять функцию двоичного поиска.
+ Создать функцию быстрой «qsort» сортировки, отличной от приведённого на лекции.

Во всех функциях:

a) применять указатели (не индексы);

b) для сравнения элементов, применять функцию, передаваемую как указатель, в качестве параметра
функции сортировки;

c) посчитать количество сравнений элементов, перестановок и (желательно) глубину рекурсии.

= Пояснения

В процедуре `main` вызываются 5 функций тестирования, куда передаются различные функции сравнения
элементов. Вы можете попробовать различные функции с различными сортировками или даже написать свою
собственную функцию. Примерный вид такой функции описан в файлах `book.h` и `book.c`.

= Код программы

#code-file(read("./src/c_lab_5.c"), name: "c_lab_5.c")

#code-file(read("./src/sort.c"), name: "sort.c")

#code-file(read("./src/sort.h"), name: "sort.h")

#code-file(read("./src/testing.c"), name: "testing.c")

#code-file(read("./src/testing.h"), name: "testing.h")

#code-file(read("./src/book.c"), name: "book.c")

#code-file(read("./src/book.h"), name: "book.h")

= Отладка приложения

Далее представлен вывод консоли, поскольку он не помещается в скриншоты. Вы можете проверить вывод
консоли самостоятельно с помощью exe файла.

#figure(
  kind: image,
  caption: "Вывод программы: сравнение сортировок по числу сравнений и перестановок",
  ```
  Before sort:

  Martin Clean Code Piter 2021 464
  Richter CLR via C# 2012 896
  Shuuichi Saiki Kusuo no PSI Nan vol. 1 2012 193
  Prata C Primer Plus 5th Edition 2004 1202
  Marx Das Capital 1867 200
  Gyasi Transcendent Kingdom 2020 288
  Fujio Doraemon Vol 1 1969 657
  Matthes Python Crash Course, 3rd Edition 2023 552
  Heisig Remembering the Kanji vol. I 2001 522
  Yong An Immense World 2022 464
  Privalov Entrance to CVFT 1999 431
  Yolen Dragon's Blood: The Pit Dragon Chronicles, Vol. 1 2021 320
  Ulrickson A Brief Quadrivium 2023 302
  Tokuno New Game vol. 01 2013 126
  O'Farrell Hamnet 2020 320
  Golden World of Warcraft: Arthas: Rise of the Lich King 2010 416
  Nosonov Socio-economic geography 2nd Edition 2019 476


  Bubble sort.

  80 swaps, 136 compares

  Sorted array:

  Tokuno New Game vol. 01 2013 126
  Shuuichi Saiki Kusuo no PSI Nan vol. 1 2012 193
  Marx Das Capital 1867 200
  Gyasi Transcendent Kingdom 2020 288
  Ulrickson A Brief Quadrivium 2023 302
  Yolen Dragon's Blood: The Pit Dragon Chronicles, Vol. 1 2021 320
  O'Farrell Hamnet 2020 320
  Golden World of Warcraft: Arthas: Rise of the Lich King 2010 416
  Privalov Entrance to CVFT 1999 431
  Martin Clean Code Piter 2021 464
  Yong An Immense World 2022 464
  Nosonov Socio-economic geography 2nd Edition 2019 476
  Heisig Remembering the Kanji vol. I 2001 522
  Matthes Python Crash Course, 3rd Edition 2023 552
  Fujio Doraemon Vol 1 1969 657
  Richter CLR via C# 2012 896
  Prata C Primer Plus 5th Edition 2004 1202


  Insertion sort.

  0 swaps, 79 compares

  Sorted array:

  Fujio Doraemon Vol 1 1969 657
  Golden World of Warcraft: Arthas: Rise of the Lich King 2010 416
  Gyasi Transcendent Kingdom 2020 288
  Heisig Remembering the Kanji vol. I 2001 522
  Martin Clean Code Piter 2021 464
  Marx Das Capital 1867 200
  Matthes Python Crash Course, 3rd Edition 2023 552
  Nosonov Socio-economic geography 2nd Edition 2019 476
  O'Farrell Hamnet 2020 320
  Prata C Primer Plus 5th Edition 2004 1202
  Privalov Entrance to CVFT 1999 431
  Richter CLR via C# 2012 896
  Shuuichi Saiki Kusuo no PSI Nan vol. 1 2012 193
  Tokuno New Game vol. 01 2013 126
  Ulrickson A Brief Quadrivium 2023 302
  Yolen Dragon's Blood: The Pit Dragon Chronicles, Vol. 1 2021 320
  Yong An Immense World 2022 464


  Bubble sort recursive.

  60 swaps, 136 compares, 17 max rec

  Sorted array:

  Marx Das Capital 1867 200
  Fujio Doraemon Vol 1 1969 657
  Privalov Entrance to CVFT 1999 431
  Heisig Remembering the Kanji vol. I 2001 522
  Prata C Primer Plus 5th Edition 2004 1202
  Golden World of Warcraft: Arthas: Rise of the Lich King 2010 416
  Richter CLR via C# 2012 896
  Shuuichi Saiki Kusuo no PSI Nan vol. 1 2012 193
  Tokuno New Game vol. 01 2013 126
  Nosonov Socio-economic geography 2nd Edition 2019 476
  Gyasi Transcendent Kingdom 2020 288
  O'Farrell Hamnet 2020 320
  Martin Clean Code Piter 2021 464
  Yolen Dragon's Blood: The Pit Dragon Chronicles, Vol. 1 2021 320
  Yong An Immense World 2022 464
  Matthes Python Crash Course, 3rd Edition 2023 552
  Ulrickson A Brief Quadrivium 2023 302


  Insertion sort recursive.

  0 swaps, 73 compares, 16 max rec

  Sorted array:

  Marx Das Capital 1867 200
  Fujio Doraemon Vol 1 1969 657
  Privalov Entrance to CVFT 1999 431
  Heisig Remembering the Kanji vol. I 2001 522
  Prata C Primer Plus 5th Edition 2004 1202
  Golden World of Warcraft: Arthas: Rise of the Lich King 2010 416
  Richter CLR via C# 2012 896
  Shuuichi Saiki Kusuo no PSI Nan vol. 1 2012 193
  Tokuno New Game vol. 01 2013 126
  Nosonov Socio-economic geography 2nd Edition 2019 476
  Gyasi Transcendent Kingdom 2020 288
  O'Farrell Hamnet 2020 320
  Martin Clean Code Piter 2021 464
  Yolen Dragon's Blood: The Pit Dragon Chronicles, Vol. 1 2021 320
  Yong An Immense World 2022 464
  Matthes Python Crash Course, 3rd Edition 2023 552
  Ulrickson A Brief Quadrivium 2023 302


  Quick sort.

  34 swaps, 45 compares, 4 max rec

  Sorted array:

  Marx Das Capital 1867 200
  Fujio Doraemon Vol 1 1969 657
  Privalov Entrance to CVFT 1999 431
  Heisig Remembering the Kanji vol. I 2001 522
  Prata C Primer Plus 5th Edition 2004 1202
  Golden World of Warcraft: Arthas: Rise of the Lich King 2010 416
  Shuuichi Saiki Kusuo no PSI Nan vol. 1 2012 193
  Richter CLR via C# 2012 896
  Tokuno New Game vol. 01 2013 126
  Nosonov Socio-economic geography 2nd Edition 2019 476
  Gyasi Transcendent Kingdom 2020 288
  O'Farrell Hamnet 2020 320
  Martin Clean Code Piter 2021 464
  Yolen Dragon's Blood: The Pit Dragon Chronicles, Vol. 1 2021 320
  Yong An Immense World 2022 464
  Ulrickson A Brief Quadrivium 2023 302
  Matthes Python Crash Course, 3rd Edition 2023 552

  Press any key to continue . . .
  ```,
)

= Содержимое файлов

`books.txt` -- исходный файл, из которого считываются книги.

#code-file(read("./src/books.txt"), name: "books.txt")
