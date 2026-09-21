МИНИСТЕРСТВО ТРАНСПОРТА РОССИЙСКОЙ ФЕДЕРАЦИИ

ФЕДЕРАЛЬНОЕ АГЕНТСТВО ЖЕЛЕЗНОДОРОЖНОГО ТРАНСПОРТА

Государственное бюджетное образовательное учреждение

высшего образования

«ПЕТЕРБУРГСКИЙ ГОСУДАРСТВЕННЫЙ УНИВЕРСИТЕТ

ПУТЕЙ СООБЩЕНИЯ ИМПЕРАТОРА АЛЕКСАНДРА I»

Кафедра «ИНФОРМАЦИОННЫЕ И ВЫЧИСЛИТЕЛЬНЫЕ СИСТЕМЫ»

Дисциплина: «Программирование(C)»

ОТЧЕТ

по лабораторной работе № 4

Вариант #emph[19]

Выполнил студент Шефнер А.

Факультета #emph[АИТ]

Группы #emph[ИВБ-211]

Санкт-Петербург

2023

#emph[#strong[ \ ]]

#strong[Постановка задачи]

Написать программу, которая читает данные произвольной размерности из
одного файла, преобразует прочитанные данныеи записывает получившийся
результат в другой файл.

При выполнении задания продемонстрировать применение различных функций
для работы с файлами (fprintf(), fscanf(), fgetc(), fputc(), fgets(),
fputs(),fwrite(),fread()).

Данные представить тремя вариантами:

a) Как двумерные динамические массивы

b) Как строки

c) Как структуры

Программа должна содержать несколько пользовательских функций,
помещенных в соответствующие отдельные файлы.

Текст программ снабдить поясняющими комментариями.

#strong[19 Вариант]

В файле содержится информация типа “автор” в следующем виде: фамилия
автора, направление (физика, программирование и т.п.), год издания,
число страниц. Считать информацию из файла, в другой файл записать
только информацию об книгах последних 5 лет издания.

#strong[ \ ]

#strong[Пояснения]

В главной функции вызываются функции test\_books\_1 и test\_books\_2.
Первая тестирует все функции из файлов books\_1.h и books\_1.c. В них
используется структура из book.h и функции стандартной библиотеки
fprintf и fscanf. Вторая тестирует все функции из файлов books\_2.h и
books\_2.c. В них используются массив строк, двумерный массив строк и
функции стандартной библиотеки fgets, fputs, fputc.

#strong[ \ ]

#strong[Код программы]

#strong[c\_lab\_4.c] (точка входа программы)

#strong[\#define \_CRT\_SECURE\_NO\_WARNINGS]

#strong[~]

#strong[\#include \<stdio.h\>]

#strong[\#include \<stdlib.h\>]

#strong[\#include \"books\_1.h\"]

#strong[\#include \"books\_2.h\"]

#strong[~]

#strong[int filter\_struct(book\* book)]

#strong[{]

#strong[return book-\>year \>= 2000;]

#strong[}]

#strong[~]

#strong[int filter\_line(char\*\* line)]

#strong[{]

#strong[return atoi(line\[2\]) \>= 2018;]

#strong[}]

#strong[~]

#strong[void test\_books\_1(void);]

#strong[~]

#strong[void test\_books\_2(void);]

#strong[~]

#strong[int main(int argc, char\* argv\[\])]

#strong[{]

#strong[test\_books\_1();]

#strong[system(\"pause\"); #emph[\/\/ NOLINT(concurrency-mt-unsafe)]]

#strong[return 0;]

#strong[}]

#strong[~]

#strong[void test\_books\_1(void)]

#strong[{]

#strong[int count;]

#strong[book\* books = get\_books\_from\_file(\"books.txt\", &count);]

#strong[for(int i = 0; i \< count; i++)]

#strong[{]

#strong[printf(\"%s - %s %d year (%d pages)\\n\", books\[i\].surname,
books\[i\].theme, books\[i\].year, books\[i\].page\_count);]

#strong[}]

#strong[~]

#strong[printf(\"\\n\\nfiltered:\\n\\n\");]

#strong[~]

#strong[int filtered\_count = 0;]

#strong[book\* filtered = filter\_books(books, filter\_struct, count,
&filtered\_count);]

#strong[write\_books\_to\_file(filtered, filtered\_count,
\"filtered.txt\");]

#strong[for(int i = 0; i \< filtered\_count; i++)]

#strong[{]

#strong[printf(\"%s - %s %d year (%d pages)\\n\", filtered\[i\].surname,
filtered\[i\].theme, filtered\[i\].year, filtered\[i\].page\_count);]

#strong[}]

#strong[~]

#strong[free(books);]

#strong[free(filtered);]

#strong[}]

#strong[~]

#strong[void test\_books\_2(void)]

#strong[{]

#strong[int count;]

#strong[char\*\* lines = get\_lines(\"books.txt\", &count);]

#strong[~]

#strong[printf(\"Lines readden from file\\n\\n\");]

#strong[for(int i = 0; i \< count; i++)]

#strong[{]

#strong[printf(\"%s\\n\", lines\[i\]);]

#strong[}]

#strong[char\*\*\* chopped\_lines = chop\_lines(lines, count);]

#strong[~]

#strong[printf(\"\\n\\nChopped lines:\\n\\n\");]

#strong[for(int i = 0; i \< count; i++)]

#strong[{]

#strong[printf(\"%s|%s|%s|%s\\n\",]

#strong[chopped\_lines\[i\]\[0\],]

#strong[chopped\_lines\[i\]\[1\],]

#strong[chopped\_lines\[i\]\[2\],]

#strong[chopped\_lines\[i\]\[3\]]

#strong[);]

#strong[}]

#strong[~]

#strong[int filtered\_count;]

#strong[char\*\*\* filtered\_lines = filter\_chopped\_lines(]

#strong[chopped\_lines,]

#strong[filter\_line,]

#strong[count,]

#strong[&filtered\_count]

#strong[);]

#strong[printf(\"\\n\\nFiltered lines:\\n\\n\");]

#strong[for(int i = 0; i \< filtered\_count; i++)]

#strong[{]

#strong[printf(\"%s|%s|%s|%s\\n\",]

#strong[filtered\_lines\[i\]\[0\],]

#strong[filtered\_lines\[i\]\[1\],]

#strong[filtered\_lines\[i\]\[2\],]

#strong[filtered\_lines\[i\]\[3\]]

#strong[);]

#strong[}]

#strong[~]

#strong[write\_chopped\_lines(\"output.txt\", filtered\_lines,
filtered\_count);]

#strong[~]

#strong[printf(\"\\n\\nData successfully written to file.\\n\\n\");]

#strong[free\_lines(lines, count);]

#strong[free\_chopped\_lines(chopped\_lines, count);]

#strong[free\_chopped\_lines(filtered\_lines, filtered\_count);]

#strong[}]

#strong[book.h] (структура book)

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

#strong[typedef struct book]

#strong[{]

#strong[char surname\[SURNAME\_CHAR\_NUMBER\];]

#strong[char theme\[THEME\_CHAR\_NUMBER\];]

#strong[unsigned short year;]

#strong[unsigned short page\_count;]

#strong[} book;]

#strong[books\_1.h] (через структуру, fprintf и fscanf)

#strong[\#pragma once]

#strong[\#include \"book.h\"]

#strong[~]

#strong[book\* get\_books\_from\_file(const char\* path, int\* count);]

#strong[~]

#strong[book\* filter\_books(book\* books, int (\*filter)(book\*), int
count, int\* out\_count);]

#strong[~]

#strong[void write\_books\_to\_file(book\* books, int count, char\*
path);]

#strong[books\_1.c]

#strong[\#define \_CRT\_SECURE\_NO\_WARNINGS]

~

#strong[\#include \"books\_1.h\"]

~

#strong[\#include \<stdio.h\>]

#strong[\#include \<stdlib.h\>]

#strong[\#include \<string.h\>]

~

#strong[void] #strong[replace\_char]\(#strong[char] str\[\],
#strong[char] from, #strong[char] to, #strong[int] size)

{

#strong[for]\(#strong[int] i = 0; i \< size; i++)

{

#strong[if]\(str\[i\] == from) str\[i\] = to;

}

}

~

book\* #strong[get\_books\_from\_file]\(#strong[const] #strong[char]\*
path, #strong[int]\* count)

{

FILE\* file;

file = fopen(path, \"r\");

fscanf(file, \"%i\\n\", count);

book\* books = malloc(sizeof(book) \* \*count);

#strong[for]\(#strong[int] i = 0; i \< \*count; i++)

{

#strong[char]\* surname\[SURNAME\_CHAR\_NUMBER\];

#strong[char]\* theme\[THEME\_CHAR\_NUMBER\];

#strong[unsigned] #strong[short] year;

#strong[unsigned] #strong[short] page\_count;

fscanf(file, SURNAME\_FORMAT \" \" THEME\_FORMAT \" \" YEAR\_FORMAT \"
\" PAGE\_FORMAT \"\\n\",

surname,

theme,

&year,

&page\_count

);

strcpy(books\[i\].surname, surname);

strcpy(books\[i\].theme, theme);

replace\_char(books\[i\].theme, \'\_\', \' \', THEME\_CHAR\_NUMBER);

books\[i\].year = year;

books\[i\].page\_count = page\_count;

}

fclose(file);

#strong[return] books;

}

~

book\* #strong[filter\_books]\(book\* books, #strong[int]\(\*
filter)(book\*), #strong[int] count, #strong[int]\* out\_count)

{

\*out\_count = 0;

#strong[short]\* suitable\_books = malloc(sizeof(#strong[short]) \*
count);

#strong[for]\(#strong[int] i = 0; i \< count; i++)

{

suitable\_books\[i\] = filter(&books\[i\]);

#strong[if]\(suitable\_books\[i\]) (\*out\_count)++;

}

~

book\* filtered\_books = malloc(sizeof(book) \* (\*out\_count));

#strong[for]\(#strong[int] i = 0, j = 0; i \< count; i++)

{

#strong[if]\(suitable\_books\[i\])

{

filtered\_books\[j\] = books\[i\];

j++;

}

}

free(suitable\_books);

#strong[return] filtered\_books;

}

~

#strong[void] #strong[write\_books\_to\_file]\(book\* books,
#strong[int] count, #strong[char]\* path)

{

FILE\* file;

file = fopen(path, \"w\");

fprintf(file, \"%d\\n\", count);

#strong[for]\(#strong[int] i = 0; i \< count; i++)

{

#strong[char] theme\[THEME\_CHAR\_NUMBER\];

strcpy(theme, books\[i\].theme);

replace\_char(theme, \' \', \'\_\', THEME\_CHAR\_NUMBER);

fprintf(file, SURNAME\_FORMAT \" \" THEME\_FORMAT \" \" YEAR\_FORMAT \"
\" PAGE\_FORMAT \"\\n\", books\[i\].surname, theme, books\[i\].year,
books\[i\].page\_count);

}

fclose(file);

}

#strong[books\_2.h] (через массив строк, двумерный массив, fgets, fputc
и fputc)

#strong[\#pragma once]

~

#strong[\#define SURNAME\_CHARS 20]

#strong[\#define THEME\_CHARS 50]

#strong[\#define YEARS\_CHARS 5]

#strong[\#define PAGES\_CHARS 5]

~

#emph[\/\/ lines are allocated with malloc, so don\'t forget to free.]

#strong[char]\*\* #strong[get\_lines]\(#strong[char]\* path,
#strong[int]\* count);

~

#strong[char]\*\*\* #strong[chop\_lines]\(#strong[char]\*\* lines,
#strong[int] count);

~

#strong[char]\*\*\* #strong[filter\_chopped\_lines]\(

#strong[char]\*\*\* chopped\_lines,

#strong[int] (\*filter)(#strong[char]\*\*),

#strong[int] count,

#strong[int]\* filtered\_count

);

~

#strong[void] #strong[write\_chopped\_lines]\(#strong[char]\* path,
#strong[char]\*\*\* chopped\_lines, #strong[int] count);

~

#strong[void] #strong[free\_lines]\(#strong[char]\*\* lines,
#strong[int] count);

~

#strong[void] #strong[free\_chopped\_lines]\(#strong[char]\*\*\* lines,
#strong[int] count);

#strong[books\_2.c]

#emph[\/\/ ReSharper disable CppDeprecatedEntity]

#emph[\/\/ ReSharper disable
CppClangTidyClangDiagnosticDeprecatedDeclarations]

#strong[\#define \_CRT\_SECURE\_NO\_WARNINGS]

~

#strong[\#include \"books\_2.h\"]

~

#strong[\#include \<stdio.h\>]

#strong[\#include \<stdlib.h\>]

#strong[\#include \<string.h\>]

~

#strong[const] #strong[int] len = SURNAME\_CHARS + THEME\_CHARS +
YEARS\_CHARS + PAGES\_CHARS + 3;

~

#strong[char]\*\* #strong[get\_lines]\(#strong[char]\* path,
#strong[int]\* count)

{

FILE\* file = fopen(path, \"r\");

~

#strong[char] len\_str\[10\];

fgets(len\_str, 10, file);

\*count = atoi(len\_str);

#strong[char]\*\* lines = malloc(sizeof(#strong[char]\*) \* \*count);

#strong[for]\(#strong[int] i = 0; i \< \*count; i++)

{

#strong[char]\* tmp = malloc(sizeof(#strong[char]) \*( len + 2));

fgets(tmp, len + 2, file);

tmp\[len\] = \'\\0\';

lines\[i\] = (#strong[char]\*)malloc(sizeof(#strong[char]) \* len + 1);

strcpy(lines\[i\], tmp);

free(tmp);

}

#strong[return] lines;

}

~

#strong[char]\*\*\* #strong[chop\_lines]\(#strong[char]\*\* lines,
#strong[int] count)

{

#strong[char]\*\*\* chopped\_lines = malloc(sizeof(#strong[char]\*\*) \*
count);

#strong[for]\(#strong[int] i = 0; i \< count; i++)

{

chopped\_lines\[i\] = malloc(sizeof(#strong[char]\*) \* 4);

~

chopped\_lines\[i\]\[0\] = malloc(sizeof(#strong[char]) \*
SURNAME\_CHARS + 1);

chopped\_lines\[i\]\[1\] = malloc(sizeof(#strong[char]) \* THEME\_CHARS
\+ 1);

chopped\_lines\[i\]\[2\] = malloc(sizeof(#strong[char]) \* YEARS\_CHARS
\+ 1);

chopped\_lines\[i\]\[3\] = malloc(sizeof(#strong[char]) \* PAGES\_CHARS
\+ 1);

~

#strong[int] str\_index = 0;

#strong[for]\(#strong[int] j = 0; j \< SURNAME\_CHARS; j++)

{

chopped\_lines\[i\]\[0\]\[j\] = lines\[i\]\[str\_index++\];

}

str\_index++;

#strong[for]\(#strong[int] j = 0; j \< THEME\_CHARS; j++)

{

chopped\_lines\[i\]\[1\]\[j\] = lines\[i\]\[str\_index++\];

}

str\_index++;

#strong[for]\(#strong[int] j = 0; j \< YEARS\_CHARS; j++)

{

chopped\_lines\[i\]\[2\]\[j\] = lines\[i\]\[str\_index++\];

}

str\_index++;

#strong[for]\(#strong[int] j = 0; j \< PAGES\_CHARS; j++)

{

chopped\_lines\[i\]\[3\]\[j\] = lines\[i\]\[str\_index++\];

}

~

chopped\_lines\[i\]\[0\]\[SURNAME\_CHARS\] = \'\\0\';

chopped\_lines\[i\]\[1\]\[THEME\_CHARS\] = \'\\0\';

chopped\_lines\[i\]\[2\]\[YEARS\_CHARS\] = \'\\0\';

chopped\_lines\[i\]\[3\]\[PAGES\_CHARS\] = \'\\0\';

}

#strong[return] chopped\_lines;

}

~

#strong[char]\*\*\* #strong[filter\_chopped\_lines]\(#strong[char]\*\*\*
chopped\_lines, #strong[int]\(\*filter)(#strong[char]\*\*), #strong[int]
count, #strong[int]\* filtered\_count)

{

\*filtered\_count = 0;

#strong[short]\* suitable\_lines =
(#strong[short]\*)malloc(sizeof(#strong[short]) \* count);

#strong[for]\(#strong[int] i = 0; i \< count; i++)

{

suitable\_lines\[i\] = filter(chopped\_lines\[i\]);

#strong[if]\(suitable\_lines\[i\]) (\*filtered\_count)++;

}

~

#strong[char]\*\*\* filtered\_lines = malloc(sizeof(#strong[char]\*\*)
\* (\*filtered\_count));

#strong[for]\(#strong[int] i = 0, j = 0; i \< count; i++)

{

#strong[if]\(suitable\_lines\[i\])

{

filtered\_lines\[j\] = malloc(sizeof(#strong[char]\*) \* 4);

~

filtered\_lines\[j\]\[0\] = malloc(sizeof(#strong[char]) \*
SURNAME\_CHARS + 1);

filtered\_lines\[j\]\[1\] = malloc(sizeof(#strong[char]) \* THEME\_CHARS
\+ 1);

filtered\_lines\[j\]\[2\] = malloc(sizeof(#strong[char]) \* YEARS\_CHARS
\+ 1);

filtered\_lines\[j\]\[3\] = malloc(sizeof(#strong[char]) \* PAGES\_CHARS
\+ 1);

strcpy(filtered\_lines\[j\]\[0\], chopped\_lines\[i\]\[0\]);

strcpy(filtered\_lines\[j\]\[1\], chopped\_lines\[i\]\[1\]);

strcpy(filtered\_lines\[j\]\[2\], chopped\_lines\[i\]\[2\]);

strcpy(filtered\_lines\[j\]\[3\], chopped\_lines\[i\]\[3\]);

j++;

}

}

free(suitable\_lines);

#strong[return] filtered\_lines;

}

~

#strong[void] #strong[write\_chopped\_lines]\(#strong[char]\* path,
#strong[char]\*\*\* chopped\_lines, #strong[int] count)

{

FILE\* file = fopen(path, \"w\");

#strong[char] count\_str\[10\];

\_itoa(count, count\_str, 20);

fputs(count\_str, file);

fputc(\'\\n\', file);

~

#strong[for]\(#strong[int] i = 0; i \< count; i++)

{

fputs(chopped\_lines\[i\]\[0\], file);

fputc(\' \', file);

fputs(chopped\_lines\[i\]\[1\], file);

fputc(\' \', file);

fputs(chopped\_lines\[i\]\[2\], file);

fputc(\' \', file);

fputs(chopped\_lines\[i\]\[3\], file);

fputc(\' \', file);

fputc(\'\\n\', file);

}

}

~

#strong[void] #strong[free\_lines]\(#strong[char]\*\* lines,
#strong[int] count)

{

#strong[for]\(#strong[int] i = 0; i \< count; i++)

{

free(lines\[i\]);

}

free(lines);

}

~

#strong[void] #strong[free\_chopped\_lines]\(#strong[char]\*\*\* lines,
#strong[int] count)

{

#strong[for]\(#strong[int] i = 0; i \< count; i++)

{

#strong[for]\(#strong[int] j = 0; j \< 4; j++)

{

free(lines\[i\]\[j\]);

}

free(lines\[i\]);

}

free(lines);

}

#strong[ \ ]

#strong[Отладка приложения.]

Далее представлен вывод консоли, поскольку он не помещается в скриншоты.
Вы можете проверить вывод консоли самостоятельно с помощью exe файла.

books\_1

Martin - Clean Code Piter 2021 year (464 pages)

Richter - CLR via C\# 2012 year (896 pages)

Shuuichi - Saiki Kusuo no PSI Nan vol. 1 2012 year (193 pages)

Prata - C Primer Plus 5th Edition 2004 year (1202 pages)

Marx - Das Capital 1867 year (200 pages)

Gyasi - Transcendent Kingdom 2020 year (288 pages)

Fujio - Doraemon Vol 1 1969 year (657 pages)

Matthes - Python Crash Course, 3rd Edition 2023 year (552 pages)

Heisig - Remembering the Kanji vol. I 2001 year (522 pages)

Yong - An Immense World 2022 year (464 pages)

Privalov - Entrance to CVFT 1999 year (431 pages)

Yolen - Dragon\'s Blood: The Pit Dragon Chronicles, Vol. 1 2021 year
(320 pages)

Ulrickson - A Brief Quadrivium 2023 year (302 pages)

Tokuno - New Game vol. 01 2013 year (126 pages)

O\'Farrell - Hamnet 2020 year (320 pages)

Golden - World of Warcraft: Arthas: Rise of the Lich King 2010 year (416
pages)

Nosonov - Socio-economic geography 2nd Edition 2019 year (476 pages)

filtered:

Martin - Clean Code Piter 2021 year (464 pages)

Richter - CLR via C\# 2012 year (896 pages)

Shuuichi - Saiki Kusuo no PSI Nan vol. 1 2012 year (193 pages)

Prata - C Primer Plus 5th Edition 2004 year (1202 pages)

Gyasi - Transcendent Kingdom 2020 year (288 pages)

Matthes - Python Crash Course, 3rd Edition 2023 year (552 pages)

Heisig - Remembering the Kanji vol. I 2001 year (522 pages)

Yong - An Immense World 2022 year (464 pages)

Yolen - Dragon\'s Blood: The Pit Dragon Chronicles, Vol. 1 2021 year
(320 pages)

Ulrickson - A Brief Quadrivium 2023 year (302 pages)

Tokuno - New Game vol. 01 2013 year (126 pages)

O\'Farrell - Hamnet 2020 year (320 pages)

Golden - World of Warcraft: Arthas: Rise of the Lich King 2010 year (416
pages)

Nosonov - Socio-economic geography 2nd Edition 2019 year (476 pages)

books\_2

Lines readden from file

Martin Clean\_Code\_Piter 2021 464

Richter CLR\_via\_C\# 2012 896

Shuuichi Saiki\_Kusuo\_no\_PSI\_Nan\_vol.\_1 2012 193

Prata C\_Primer\_Plus\_5th\_Edition 2004 1202

Marx Das\_Capital 1867 200

Gyasi Transcendent\_Kingdom 2020 288

Fujio Doraemon\_Vol\_1 1969 657

Matthes Python\_Crash\_Course,\_3rd\_Edition 2023 552

Heisig Remembering\_the\_Kanji\_vol.\_I 2001 522

Yong An\_Immense\_World 2022 464

Privalov Entrance\_to\_CVFT 1999 431

Yolen Dragon\'s\_Blood:\_The\_Pit\_Dragon\_Chronicles,\_Vol.\_1 2021 320

Ulrickson A\_Brief\_Quadrivium 2023 302

Tokuno New\_Game\_vol.\_01 2013 126

O\'Farrell Hamnet 2020 320

Golden World\_of\_Warcraft:\_Arthas:\_Rise\_of\_the\_Lich\_King 2010 416

Nosonov Socio-economic\_geography\_2nd\_Edition 2019 476

Chopped lines:

Martin| Clean\_Code\_Piter| 2021| 464

Richter| CLR\_via\_C\#| 2012| 896

Shuuichi| Saiki\_Kusuo\_no\_PSI\_Nan\_vol.\_1| 2012| 193

Prata| C\_Primer\_Plus\_5th\_Edition| 2004| 1202

Marx| Das\_Capital| 1867| 200

Gyasi| Transcendent\_Kingdom| 2020| 288

Fujio| Doraemon\_Vol\_1| 1969| 657

Matthes| Python\_Crash\_Course,\_3rd\_Edition| 2023| 552

Heisig| Remembering\_the\_Kanji\_vol.\_I| 2001| 522

Yong| An\_Immense\_World| 2022| 464

Privalov| Entrance\_to\_CVFT| 1999| 431

Yolen| Dragon\'s\_Blood:\_The\_Pit\_Dragon\_Chronicles,\_Vol.\_1| 2021|
320

Ulrickson| A\_Brief\_Quadrivium| 2023| 302

Tokuno| New\_Game\_vol.\_01| 2013| 126

O\'Farrell| Hamnet| 2020| 320

Golden| World\_of\_Warcraft:\_Arthas:\_Rise\_of\_the\_Lich\_King| 2010|
416

Nosonov| Socio-economic\_geography\_2nd\_Edition| 2019| 476

Filtered lines:

Martin| Clean\_Code\_Piter| 2021| 464

Gyasi| Transcendent\_Kingdom| 2020| 288

Matthes| Python\_Crash\_Course,\_3rd\_Edition| 2023| 552

Yong| An\_Immense\_World| 2022| 464

Yolen| Dragon\'s\_Blood:\_The\_Pit\_Dragon\_Chronicles,\_Vol.\_1| 2021|
320

Ulrickson| A\_Brief\_Quadrivium| 2023| 302

O\'Farrell| Hamnet| 2020| 320

Nosonov| Socio-economic\_geography\_2nd\_Edition| 2019| 476

Data successfully written to file.

Press any key to continue . . .

#strong[Содержимое файлов.]

books.txt -- исходный файл, из которого считываются книги.

#box(image("lab-4/assets/media/image1.png"))

filtered\_1.txt -- результат работы функций из books\_1.

Условие: год выпуска книги больше или равен 2000.

#box(image("lab-4/assets/media/image2.png"))

#box(image("lab-4/assets/media/image3.png"))

filtered\_2.txt -- результат работы функций из books\_2.

Условие: год книги больше или равен 2018.

#box(image("lab-4/assets/media/image4.png"))

#box(image("lab-4/assets/media/image5.png"))
