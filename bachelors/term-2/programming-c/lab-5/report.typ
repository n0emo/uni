МИНИСТЕРСТВО ТРАНСПОРТА РОССИЙСКОЙ ФЕДЕРАЦИИ

ФЕДЕРАЛЬНОЕ АГЕНТСТВО ЖЕЛЕЗНОДОРОЖНОГО ТРАНСПОРТА

Государственное бюджетное образовательное учреждение

высшего образования

«ПЕТЕРБУРГСКИЙ ГОСУДАРСТВЕННЫЙ УНИВЕРСИТЕТ

ПУТЕЙ СООБЩЕНИЯ ИМПЕРАТОРА АЛЕКСАНДРА I»

Кафедра «ИНФОРМАЦИОННЫЕ И ВЫЧИСЛИТЕЛЬНЫЕ СИСТЕМЫ»

Дисциплина: «Программирование(C)»

ОТЧЕТ

по лабораторной работе № 5

Вариант #emph[19]

Выполнил студент Шефнер А.

Факультета #emph[АИТ]

Группы #emph[ИВБ-211]

Санкт-Петербург

2023

#emph[#strong[ \ ]]

#strong[Постановка задачи]

\1. Создать функцию сортировки «пузырьком» итерационную и рекурсивную.

\2. Создать функцию сортировки «вставками», для поиска места вставки в
отсортированную часть массива применять функцию двоичного поиска.

\3. Создать функцию быстрой «qsort» сортировки, отличной от приведённого
на лекции.

Во всех функциях:

a) применять указатели (не индексы);

b) для сравнения элементов, применять функцию, передаваемую как
указатель, в качестве параметра функции сортировки;

c) посчитать количество сравнений элементов, перестановок и (желательно)
глубину рекурсии.

#strong[ \ Пояснения]

В процедуре main вызываются 5 функций тестирования, куда передаются
различные функции сравнения элементов. Вы можете попробовать различные
функции с различными сортировками или даже написать свою собственную
функцию. Примерный вид такой функции описан в файлах book.h и book.c.

#strong[ \ ]

#strong[Код программы]

#strong[c\_lab\_5.c] (точка входа программы)

#strong[\#include \<stdio.h\>]

#strong[\#include \<stdlib.h\>]

#strong[~]

#strong[\#include \"book.h\"]

#strong[\#include \"sort.h\"]

#strong[\#include \"testing.h\"]

#strong[~]

#strong[int main(int argc, char\* argv\[\])]

#strong[{]

#strong[int count;]

#strong[book\*\* books = get\_books\_from\_file(\"books.txt\", &count);]

#strong[printf(\"Before sort:\\n\\n\");]

#strong[print\_books(books, count);]

#strong[~]

#strong[test\_info\_sort(books, count, bubble\_iter\_info,
book\_compare\_pages, \"\\n\\nBubble sort.\\n\\n\");]

#strong[test\_info\_sort(books, count, insertion\_iter\_info,
book\_compare\_surname, \"\\n\\nInsertion sort.\\n\\n\");]

#strong[test\_info\_sort\_rec(books, count, bubble\_rec\_info,
book\_compare\_year, \"\\n\\nBubble sort recursive.\\n\\n\");]

#strong[test\_info\_sort\_rec(books, count, insertion\_rec\_info,
book\_compare\_year, \"\\n\\nInsertion sort recursive.\\n\\n\");]

#strong[test\_info\_sort\_rec(books, count, quicksort\_info,
book\_compare\_year, \"\\n\\nQuick sort.\\n\\n\");]

#strong[for(int i = 0; i \< count; i++)]

#strong[{]

#strong[free(books\[i\]);]

#strong[}]

#strong[free(books);]

#strong[printf(\"\\n\");]

#strong[system(\"pause\"); #emph[\/\/ NOLINT(concurrency-mt-unsafe)]]

#strong[return 0;]

#strong[}]

#strong[ \ ]

#strong[book.h] (Структура book и основные процедуры работы с массивом
книг)

#strong[\#pragma once]

#strong[~]

#strong[\#define SURNAME\_CHAR\_NUMBER 20]

#strong[\#define THEME\_CHAR\_NUMBER 50]

#strong[~]

#strong[\#define SURNAME\_FORMAT \"%20s\"]

#strong[\#define THEME\_FORMAT \"%50s\"]

#strong[\#define YEAR\_FORMAT \"%5hu\"]

#strong[\#define PAGE\_FORMAT \"%5hu\"]

#strong[~]

#strong[struct book;]

#strong[typedef struct book {]

#strong[char surname\[SURNAME\_CHAR\_NUMBER\];]

#strong[char theme\[THEME\_CHAR\_NUMBER\];]

#strong[unsigned short year;]

#strong[unsigned short page\_count;]

#strong[} book;]

#strong[~]

#strong[book\*\* get\_books\_from\_file(const char\* path, int\*
count);]

#strong[~]

#strong[int book\_compare\_year(const book\* a, const book\* b);]

#strong[~]

#strong[int book\_compare\_pages(const book\* a, const book\* b);]

#strong[~]

#strong[int book\_compare\_surname(const book\* a, const book\* b);]

#strong[book.с]

#strong[\#define \_CRT\_SECURE\_NO\_WARNINGS]

#strong[~]

#strong[\#include \"book.h\"]

#strong[~]

#strong[\#include \<stdio.h\>]

#strong[\#include \<stdlib.h\>]

#strong[\#include \<string.h\>]

#strong[~]

#strong[void replace\_char(char str\[\], char from, char to, int size)]

#strong[{]

#strong[for(int i = 0; i \< size; i++)]

#strong[{]

#strong[if(str\[i\] == from) str\[i\] = to;]

#strong[}]

#strong[}]

#strong[~]

#strong[book\*\* get\_books\_from\_file(const char\* path, int\* count)]

#strong[{]

#strong[FILE\* file;]

#strong[file = fopen(path, \"r\");]

#strong[fscanf(file, \"%i\\n\", count);]

#strong[book\*\* books = malloc(sizeof(book\*) \* \*count);]

#strong[for(int i = 0; i \< \*count; i++)]

#strong[{]

#strong[books\[i\] = (book\*)malloc(sizeof(book));]

#strong[char\* surname\[SURNAME\_CHAR\_NUMBER\];]

#strong[char\* theme\[THEME\_CHAR\_NUMBER\];]

#strong[unsigned short year;]

#strong[unsigned short page\_count;]

#strong[fscanf(file, SURNAME\_FORMAT \" \" THEME\_FORMAT \" \"
YEAR\_FORMAT \" \" PAGE\_FORMAT \"\\n\",]

#strong[surname,]

#strong[theme,]

#strong[&year,]

#strong[&page\_count]

#strong[);]

#strong[strcpy(books\[i\]-\>surname, surname);]

#strong[strcpy(books\[i\]-\>theme, theme);]

#strong[replace\_char(books\[i\]-\>theme, \'\_\', \' \',
THEME\_CHAR\_NUMBER);]

#strong[books\[i\]-\>year = year;]

#strong[books\[i\]-\>page\_count = page\_count;]

#strong[}]

#strong[fclose(file);]

#strong[return books;]

#strong[}]

#strong[~]

#strong[int book\_compare\_year(const book\* a, const book\* b)]

#strong[{]

#strong[if(a-\>year \< b-\>year) return -1;]

#strong[if(a-\>year \> b-\>year) return 1;]

#strong[return 0;]

#strong[}]

#strong[~]

#strong[int book\_compare\_pages(const book\* a, const book\* b)]

#strong[{]

#strong[if(a-\>page\_count \< b-\>page\_count) return -1;]

#strong[if(a-\>page\_count \> b-\>page\_count) return 1;]

#strong[return 0;]

#strong[}]

#strong[~]

#strong[int book\_compare\_surname(const book\* a, const book\* b)]

#strong[{]

#strong[return strcmp(a-\>surname, b-\>surname);]

#strong[}]

#strong[sort.h] (функции сортировки)

#strong[\#pragma once]

#strong[~~]

#strong[void bubble\_iter(void\*\* begin, void\*\* end,
int(\*compare)(void\*, void\*));]

#strong[~]

#strong[void bubble\_rec(void\*\* begin, void\*\* end,
int(\*compare)(void\*, void\*));]

#strong[~]

#strong[void insertion\_iter(void\*\* begin, void\*\* end,
int(\*compare)(void\*, void\*));]

#strong[~]

#strong[void insertion\_rec(void\*\* begin, void\*\* end,
int(\*compare)(void\*, void\*));]

#strong[~]

#strong[void quicksort(void\*\* begin, void\*\* end,
int(\*compare)(void\*, void\*));]

#strong[~]

#strong[void bubble\_iter\_info(void\*\* begin, void\*\* end,
int(\*compare)(void\*, void\*),]

#strong[int\* swap\_count, int\* cmp\_count]

#strong[);]

#strong[~]

#strong[void bubble\_rec\_info(void\*\* begin, void\*\* end,
int(\*compare)(void\*, void\*),]

#strong[int\* swap\_count, int\* cmp\_count, int current\_rec, int\*
max\_rec]

#strong[);]

#strong[~]

#strong[void insertion\_iter\_info(void\*\* begin, void\*\* end,
int(\*compare)(void\*, void\*),]

#strong[int\* swap\_count, int\* cmp\_count]

#strong[);]

#strong[~]

#strong[void insertion\_rec\_info(void\*\* begin, void\*\* end, int(\*
compare)(void\*, void\*),]

#strong[int\* swap\_count, int\* cmp\_count, int current\_rec, int\*
max\_rec);]

#strong[~]

#strong[void quicksort\_info(void\*\* begin, void\*\* end,
int(\*compare)(void\*, void\*),]

#strong[int\* swap\_count, int\* cmp\_count, int current\_rec, int\*
max\_rec]

#strong[);]

#strong[sort.с]

#strong[\#include \"sort.h\"]

#strong[~]

#strong[void S\_swap(void\*\* a, void\*\*b)]

#strong[{]

#strong[void\* tmp = \*a;]

#strong[\*a = \*b;]

#strong[\*b = tmp;]

#strong[}]

#strong[~]

#strong[void bubble\_iter(void\*\* begin, void\*\* end, int(\*
compare)(void\*, void\*))]

#strong[{]

#strong[while(begin \< end)]

#strong[{]

#strong[void\*\* iter = begin;]

#strong[while(iter \< end - 1)]

#strong[{]

#strong[if(compare(\*iter, \*(iter + 1)) == 1) S\_swap(iter, iter + 1);]

#strong[iter++;]

#strong[}]

#strong[end-\-;]

#strong[}]

#strong[}]

#strong[~]

#strong[void bubble\_rec(void\*\* begin, void\*\* end, int(\*
compare)(void\*, void\*))]

#strong[{]

#strong[if(begin \>= end) return;]

#strong[void\*\* iter = begin;]

#strong[while(iter \< end - 1)]

#strong[{]

#strong[if(compare(\*iter, \*(iter + 1)) == 1) S\_swap(iter, iter + 1);]

#strong[iter++;]

#strong[}]

#strong[bubble\_rec(begin, end - 1, compare);]

#strong[}]

#strong[~]

#strong[void insertion\_iter(void\*\* begin, void\*\* end, int(\*
compare)(void\*, void\*))]

#strong[{]

#strong[void\*\* iter\_1 = begin + 1;]

#strong[while(iter\_1 \< end)]

#strong[{]

#strong[void\* key = \*iter\_1;]

#strong[void\*\* iter\_2 = iter\_1 - 1;]

#strong[while (iter\_2 \>= begin && compare(\*iter\_2, key) == 1)]

#strong[{]

#strong[\*(iter\_2 + 1) = \*iter\_2;]

#strong[iter\_2-\-;]

#strong[}]

#strong[\*(iter\_2 + 1) = key;]

#strong[iter\_1++;]

#strong[}]

#strong[}]

#strong[~]

#strong[void insertion\_rec\_impl(void\*\* begin, void\*\* end, void\*\*
iter\_end, int(\* compare)(void\*, void\*))]

#strong[{]

#strong[if(end \<= iter\_end) return;]

#strong[void\* key = \*iter\_end;]

#strong[void\*\* iter\_2 = iter\_end - 1;]

#strong[while (iter\_2 \>= begin && compare(\*iter\_2, key) == 1)]

#strong[{]

#strong[\*(iter\_2 + 1) = \*iter\_2;]

#strong[iter\_2-\-;]

#strong[}]

#strong[\*(iter\_2 + 1) = key;]

#strong[insertion\_rec\_impl(begin, end, iter\_end + 1, compare);]

#strong[}]

#strong[~]

#strong[void insertion\_rec(void\*\* begin, void\*\* end, int(\*
compare)(void\*, void\*))]

#strong[{ insertion\_rec\_impl(begin, end, begin + 1, compare); }]

#strong[~]

#strong[void\*\* quicksort\_partition(void\*\* begin, void\*\* end,
int(\* compare)(void\*, void\*))]

#strong[{]

#strong[void\* pivot = \*end;]

#strong[void\*\* pivot\_ptr = begin;]

#strong[~]

#strong[for(void\*\* iter\_i = begin; iter\_i \< end; iter\_i++)]

#strong[{]

#strong[if(compare(\*iter\_i, pivot) == -1)]

#strong[{]

#strong[S\_swap(pivot\_ptr, iter\_i);]

#strong[pivot\_ptr++;]

#strong[}]

#strong[}]

#strong[~]

#strong[S\_swap(pivot\_ptr, end);]

#strong[return pivot\_ptr;]

#strong[}]

#strong[~]

#strong[void quicksort\_impl(void\*\* begin, void\*\* end, int(\*
compare)(void\*, void\*))]

#strong[{]

#strong[if(begin \>= end) return;]

#strong[void\*\* pivot\_ptr = quicksort\_partition(begin, end,
compare);]

#strong[quicksort\_impl(begin, pivot\_ptr - 1, compare);]

#strong[quicksort\_impl(pivot\_ptr + 1, end, compare);]

#strong[}]

#strong[~]

#strong[void quicksort(void\*\* begin, void\*\* end, int(\*
compare)(void\*, void\*))]

#strong[{ quicksort\_impl(begin, end - 1, compare); }]

#strong[~]

#strong[void bubble\_iter\_info(void\*\* begin, void\*\* end, int(\*
compare)(void\*, void\*), int\* swap\_count, int\* cmp\_count)]

#strong[{]

#strong[while(begin \< end)]

#strong[{]

#strong[void\*\* iter = begin;]

#strong[while(iter \< end - 1)]

#strong[{]

#strong[\(\*cmp\_count)++;]

#strong[if(compare(\*iter, \*(iter + 1)) == 1)]

#strong[{]

#strong[\(\*swap\_count)++;]

#strong[S\_swap(iter, iter + 1);]

#strong[}]

#strong[iter++;]

#strong[}]

#strong[end-\-;]

#strong[}]

#strong[}]

#strong[~]

#strong[void bubble\_rec\_info(void\*\* begin, void\*\* end, int(\*
compare)(void\*, void\*), int\* swap\_count, int\* cmp\_count,]

#strong[int current\_rec, int\* max\_rec)]

#strong[{]

#strong[if(begin \>= end)]

#strong[{]

#strong[if(current\_rec \> \*max\_rec) \*max\_rec = current\_rec;]

#strong[return;]

#strong[}]

#strong[void\*\* iter = begin;]

#strong[while(iter \< end - 1)]

#strong[{]

#strong[\(\*cmp\_count)++;]

#strong[if(compare(\*iter, \*(iter + 1)) == 1)]

#strong[{]

#strong[\(\*swap\_count)+=1;]

#strong[S\_swap(iter, iter + 1);]

#strong[}]

#strong[iter++;]

#strong[}]

#strong[bubble\_rec\_info(begin, end - 1, compare, swap\_count,
cmp\_count, current\_rec + 1, max\_rec);]

#strong[}]

#strong[~]

#strong[void insertion\_iter\_info(void\*\* begin, void\*\* end, int(\*
compare)(void\*, void\*), int\* swap\_count, int\* cmp\_count)]

#strong[{]

#strong[void\*\* iter\_1 = begin + 1;]

#strong[while(iter\_1 \< end)]

#strong[{]

#strong[void\* key = \*iter\_1;]

#strong[void\*\* iter\_2 = iter\_1 - 1;]

#strong[while (iter\_2 \>= begin && ++(\*cmp\_count) &&
compare(\*iter\_2, key) == 1 )]

#strong[{]

#strong[\*(iter\_2 + 1) = \*iter\_2;]

#strong[iter\_2-\-;]

#strong[}]

#strong[\*(iter\_2 + 1) = key;]

#strong[iter\_1++;]

#strong[}]

#strong[}]

#strong[~]

#strong[void insertion\_rec\_info\_impl(void\*\* begin, void\*\* end,
void\*\* iter\_end, int(\* compare)(void\*, void\*), int\* swap\_count,
int\* cmp\_count,]

#strong[int current\_rec, int\* max\_rec)]

#strong[{]

#strong[if(end \<= iter\_end)]

#strong[{]

#strong[if(current\_rec \> \*max\_rec) \*max\_rec = current\_rec;]

#strong[return;]

#strong[}]

#strong[void\* key = \*iter\_end;]

#strong[void\*\* iter\_2 = iter\_end - 1;]

#strong[while (iter\_2 \>= begin && ++(\*cmp\_count) &&
compare(\*iter\_2, key) == 1)]

#strong[{]

#strong[\*(iter\_2 + 1) = \*iter\_2;]

#strong[iter\_2-\-;]

#strong[}]

#strong[\*(iter\_2 + 1) = key;]

#strong[insertion\_rec\_info\_impl(begin, end, iter\_end + 1, compare,
swap\_count, cmp\_count, current\_rec + 1, max\_rec);]

#strong[}]

#strong[~]

#strong[void insertion\_rec\_info(void\*\* begin, void\*\* end, int(\*
compare)(void\*, void\*), int\* swap\_count, int\* cmp\_count,]

#strong[int current\_rec, int\* max\_rec)]

#strong[{]

#strong[insertion\_rec\_info\_impl(begin, end, begin + 1, compare,
swap\_count, cmp\_count, current\_rec, max\_rec);]

#strong[}]

#strong[~]

#strong[void\*\* quicksort\_info\_partition(void\*\* begin, void\*\*
end, int(\* compare)(void\*, void\*), int\* swap\_count, int\*
cmp\_count)]

#strong[{]

#strong[void\* pivot = \*end;]

#strong[void\*\* pivot\_ptr = begin;]

#strong[~]

#strong[for(void\*\* iter\_i = begin; iter\_i \< end; iter\_i++)]

#strong[{]

#strong[\(\*cmp\_count)++;]

#strong[if(compare(\*iter\_i, pivot) == -1)]

#strong[{]

#strong[\(\*swap\_count)++;]

#strong[S\_swap(pivot\_ptr, iter\_i);]

#strong[pivot\_ptr++;]

#strong[}]

#strong[}]

#strong[\(\*swap\_count)++;]

#strong[S\_swap(pivot\_ptr, end);]

#strong[return pivot\_ptr;]

#strong[}]

#strong[~]

#strong[void quicksort\_info\_impl(void\*\* begin, void\*\* end, int(\*
compare)(void\*, void\*), int\* swap\_count, int\* cmp\_count,]

#strong[int current\_rec, int\* max\_rec)]

#strong[{]

#strong[if(begin \>= end)]

#strong[{]

#strong[if(current\_rec \> \*max\_rec) \*max\_rec = current\_rec;]

#strong[return;]

#strong[}]

#strong[void\*\* pivot\_ptr = quicksort\_info\_partition(begin, end,
compare, swap\_count, cmp\_count);]

#strong[quicksort\_info\_impl(begin, pivot\_ptr - 1, compare,
swap\_count, cmp\_count, current\_rec + 1, max\_rec);]

#strong[quicksort\_info\_impl(pivot\_ptr + 1, end, compare, swap\_count,
cmp\_count, current\_rec + 1, max\_rec);]

#strong[}]

#strong[~]

#strong[void quicksort\_info(void\*\* begin, void\*\* end, int(\*
compare)(void\*, void\*), int\* swap\_count, int\* cmp\_count,]

#strong[int current\_rec, int\* max\_rec)]

#strong[{ quicksort\_info\_impl(begin, end - 1, compare, swap\_count,
cmp\_count, current\_rec, max\_rec); }]

#strong[testing.h] (Функции тестирования) #strong[ \ \#pragma once]

#strong[~]

#strong[\#include \"book.h\"]

#strong[~]

#strong[void print\_books(book\*\* books, int count);]

#strong[~]

#strong[void copy\_ptr\_arr(void\*\* to, int count, void\*\* from);]

#strong[~]

#strong[void test\_sort(book\*\* books, int count,]

#strong[void (\*sorting\_func)(void\*\*, void\*\*, int(\*)(void\*,
void\*)),]

#strong[int(\*compare\_func)(void\*, void\*),]

#strong[char\* msg);]

#strong[~]

#strong[void test\_info\_sort(book\*\* books,]

#strong[int count,]

#strong[void (\*sorting\_func)(void\*\*, void\*\*, int(\*)(void\*,
void\*), int\*, int\*),]

#strong[int(\*compare\_func)(void\*, void\*),]

#strong[char\* msg);]

#strong[~]

#strong[void test\_info\_sort\_rec(book\*\* books,]

#strong[int count,]

#strong[void (\*sorting\_func)(void\*\*, void\*\*, int(\*)(void\*,
void\*), int\*, int\*, int, int\*),]

#strong[int(\*compare\_func)(void\*, void\*),]

#strong[char\* msg);]

#strong[testing.c]

#strong[\#include \"testing.h\"]

#strong[~]

#strong[\#include \<stdio.h\>]

#strong[\#include \<stdlib.h\>]

#strong[~]

#strong[void print\_books(book\*\* books, int count)]

#strong[{]

#strong[for(int i = 0; i \< count; i++)]

#strong[{]

#strong[printf(\"%s %s %d %d\\n\",]

#strong[books\[i\]-\>surname,]

#strong[books\[i\]-\>theme,]

#strong[books\[i\]-\>year,]

#strong[books\[i\]-\>page\_count]

#strong[);]

#strong[}]

#strong[}]

#strong[~]

#strong[void copy\_ptr\_arr(void\*\* to, int count, void\*\* from)]

#strong[{]

#strong[void\*\* end\_ptr = to + count;]

#strong[while(to \< end\_ptr)\*(to++) = \*(from++);]

#strong[}]

#strong[~]

#strong[void test\_sort(book\*\* books,]

#strong[int count,]

#strong[void (\*sorting\_func)(void\*\*, void\*\*, int(\*)(void\*,
void\*)),]

#strong[int(\*compare\_func)(void\*, void\*),]

#strong[char\* msg)]

#strong[{]

#strong[book\*\* arr\_for\_sorting = malloc(sizeof(book\*) \* count);]

#strong[copy\_ptr\_arr(arr\_for\_sorting, count, books);]

#strong[printf(msg);]

#strong[sorting\_func(arr\_for\_sorting, arr\_for\_sorting + count,
compare\_func);]

#strong[printf(\"\\nSorted array:\\n\\n\");]

#strong[print\_books(arr\_for\_sorting, count);]

#strong[free(arr\_for\_sorting);]

#strong[}]

#strong[~]

#strong[void test\_info\_sort(book\*\* books,]

#strong[int count,]

#strong[void (\*sorting\_func)(void\*\*, void\*\*, int(\*)(void\*,
void\*), int\*, int\*),]

#strong[int(\*compare\_func)(void\*, void\*),]

#strong[char\* msg)]

#strong[{]

#strong[book\*\* arr\_for\_sorting = malloc(sizeof(book\*) \* count);]

#strong[copy\_ptr\_arr(arr\_for\_sorting, count, books);]

#strong[printf(msg);]

#strong[int swap\_count = 0;]

#strong[int cmp\_count = 0;]

#strong[sorting\_func(arr\_for\_sorting, arr\_for\_sorting + count,
compare\_func, &swap\_count, &cmp\_count);]

#strong[printf(\"%d swaps, %d compares\\n\\nSorted array:\\n\\n\",
swap\_count, cmp\_count);]

#strong[print\_books(arr\_for\_sorting, count);]

#strong[}]

#strong[~]

#strong[void test\_info\_sort\_rec(book\*\* books,]

#strong[int count,]

#strong[void (\*sorting\_func)(void\*\*, void\*\*, int(\*)(void\*,
void\*), int\*, int\*, int, int\*),]

#strong[int(\*compare\_func)(void\*, void\*),]

#strong[char\* msg)]

#strong[{]

#strong[book\*\* arr\_for\_sorting = malloc(sizeof(book\*) \* count);]

#strong[copy\_ptr\_arr(arr\_for\_sorting, count, books);]

#strong[printf(msg);]

#strong[int swap\_count = 0;]

#strong[int cmp\_count = 0;]

#strong[int max\_rec = 0;]

#strong[sorting\_func(arr\_for\_sorting, arr\_for\_sorting + count,
compare\_func, &swap\_count, &cmp\_count, 0, &max\_rec);]

#strong[printf(\"%d swaps, %d compares, %d max rec\\n\\nSorted
array:\\n\\n\", swap\_count, cmp\_count, max\_rec);]

#strong[print\_books(arr\_for\_sorting, count);]

#strong[}]

#strong[~]

#strong[ \ ]

#strong[Отладка приложения]

Далее представлен вывод консоли, поскольку он не помещается в скриншоты.
Вы можете проверить вывод консоли самостоятельно с помощью exe файла.

Before sort:

Martin Clean Code Piter 2021 464

Richter CLR via C\# 2012 896

Shuuichi Saiki Kusuo no PSI Nan vol. 1 2012 193

Prata C Primer Plus 5th Edition 2004 1202

Marx Das Capital 1867 200

Gyasi Transcendent Kingdom 2020 288

Fujio Doraemon Vol 1 1969 657

Matthes Python Crash Course, 3rd Edition 2023 552

Heisig Remembering the Kanji vol. I 2001 522

Yong An Immense World 2022 464

Privalov Entrance to CVFT 1999 431

Yolen Dragon\'s Blood: The Pit Dragon Chronicles, Vol. 1 2021 320

Ulrickson A Brief Quadrivium 2023 302

Tokuno New Game vol. 01 2013 126

O\'Farrell Hamnet 2020 320

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

Yolen Dragon\'s Blood: The Pit Dragon Chronicles, Vol. 1 2021 320

O\'Farrell Hamnet 2020 320

Golden World of Warcraft: Arthas: Rise of the Lich King 2010 416

Privalov Entrance to CVFT 1999 431

Martin Clean Code Piter 2021 464

Yong An Immense World 2022 464

Nosonov Socio-economic geography 2nd Edition 2019 476

Heisig Remembering the Kanji vol. I 2001 522

Matthes Python Crash Course, 3rd Edition 2023 552

Fujio Doraemon Vol 1 1969 657

Richter CLR via C\# 2012 896

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

O\'Farrell Hamnet 2020 320

Prata C Primer Plus 5th Edition 2004 1202

Privalov Entrance to CVFT 1999 431

Richter CLR via C\# 2012 896

Shuuichi Saiki Kusuo no PSI Nan vol. 1 2012 193

Tokuno New Game vol. 01 2013 126

Ulrickson A Brief Quadrivium 2023 302

Yolen Dragon\'s Blood: The Pit Dragon Chronicles, Vol. 1 2021 320

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

Richter CLR via C\# 2012 896

Shuuichi Saiki Kusuo no PSI Nan vol. 1 2012 193

Tokuno New Game vol. 01 2013 126

Nosonov Socio-economic geography 2nd Edition 2019 476

Gyasi Transcendent Kingdom 2020 288

O\'Farrell Hamnet 2020 320

Martin Clean Code Piter 2021 464

Yolen Dragon\'s Blood: The Pit Dragon Chronicles, Vol. 1 2021 320

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

Richter CLR via C\# 2012 896

Shuuichi Saiki Kusuo no PSI Nan vol. 1 2012 193

Tokuno New Game vol. 01 2013 126

Nosonov Socio-economic geography 2nd Edition 2019 476

Gyasi Transcendent Kingdom 2020 288

O\'Farrell Hamnet 2020 320

Martin Clean Code Piter 2021 464

Yolen Dragon\'s Blood: The Pit Dragon Chronicles, Vol. 1 2021 320

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

Richter CLR via C\# 2012 896

Tokuno New Game vol. 01 2013 126

Nosonov Socio-economic geography 2nd Edition 2019 476

Gyasi Transcendent Kingdom 2020 288

O\'Farrell Hamnet 2020 320

Martin Clean Code Piter 2021 464

Yolen Dragon\'s Blood: The Pit Dragon Chronicles, Vol. 1 2021 320

Yong An Immense World 2022 464

Ulrickson A Brief Quadrivium 2023 302

Matthes Python Crash Course, 3rd Edition 2023 552

Press any key to continue . . .

#strong[Содержимое файлов]

books.txt -- исходный файл, из которого считываются книги.

#box(image("lab-5/assets/media/image1.png"))
