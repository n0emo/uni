ФЕДЕРАЛЬНОЕ АГЕНСТВО ЖЕЛЕЗНОДОРОЖНОГО ТРАНСПОРТА

Федеральное государственное бюджетное образовательное учреждение высшего
образования

«ПЕТЕРБУРГСКИЙ ГОСУДАРСТВЕННЫЙ УНИВЕРСИТЕТ ПУТЕЙ СООБЩЕНИЯ Императора
Александра I»

Кафедра «Информационные и вычислительные системы»

Дисциплина «Программирование С++»

#strong[ОТЧЁТ]

#strong[ПО ЛАБОРАТОРНОЙ РАБОТЕ № 2]

ВАРИАНТ 19

#figure(
  align(center)[#table(
    columns: (50.01%, 49.99%),
    align: (auto,auto,),
    table.header([Выполнил студент

      Факультет: АИТ

      Группа: ИВБ-211

      ], table.cell(align: right)[Шефнер А.],),
    table.hline(),
    [Проверил:], table.cell(align: right)[Проузин О.В.],
  )]
  , kind: table
  )

#strong[Санкт-Петербург]

#strong[2023]

Оценочный лист результатов ЛР № 2

Ф.И.О. студента \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_#underline[Шефнер
Альберт]\_\_\_\_\_

Группа
\_\_\_\_\_\_\_\_\_\_\_\_\_#underline[ИВБ-211]\_\_\_\_\_\_\_\_\_\_\_\_

#figure(
  align(center)[#table(
    columns: (5.85%, 22.05%, 21.5%, 21.59%, 17.06%, 11.95%),
    align: (center,auto,auto,auto,auto,auto,),
    table.header(table.cell(align: center)[#strong[№]

      #strong[п/п]

      ], table.cell(align: center)[#strong[Материалы необходимые для
      оценки знаний, умений]

      #strong[и навыков]

      ], table.cell(align: center)[#strong[Показатель]

      #strong[оценивания]

      ], table.cell(align: center)[#strong[Критерии]

      #strong[Оценивания]

      ], table.cell(align: center)[#strong[Шкала
      оценивания]], [#strong[Оценка]],),
    table.hline(),
    table.cell(align: center, rowspan: 6)[1], table.cell(align: center, rowspan: 6)[Лабораторная
    работа№], table.cell(align: center, rowspan: 2)[Соответствие
    методике
    выполнения], table.cell(align: center)[Соответствует], table.cell(align: center)[7], table.cell(rowspan: 2)[],
    table.cell(align: center)[Не
    соответствует], table.cell(align: center)[0],
    table.cell(align: center, rowspan: 2)[Срок
    выполнения], table.cell(align: center)[Выполнена в
    срок], table.cell(align: center)[2], table.cell(rowspan: 2)[],
    table.cell(align: center)[Выполнена с опозданием на 2
    недели], table.cell(align: center)[0],
    table.cell(align: center, rowspan: 2)[оформление], table.cell(align: center)[Соответствует
    требованиям], table.cell(align: center)[1

    0

    ], table.cell(rowspan: 2)[],
    table.cell(align: center)[Не
    соответствует], table.cell(align: center)[],
    table.cell(align: center)[], table.cell(align: center)[#strong[ИТОГО
    количество
    баллов]], table.cell(align: center)[], table.cell(align: center)[], [10], [],
  )]
  , kind: table
  )

Доцент кафедры

«Информационные и вычислительные

системы» Проурзин О.В. «\_\_» \_\_\_\_\_\_\_\_\_\_2023 г.

#strong[Цели работы:]

- освоить работу с указателями.

- Узнать основные методы обработки строк

#strong[Задание]

Создать тестовую функцию #strong[main ( )], которая реализует алгоритм,
показанный на рисунке:

#box(image("lab-2/assets/media/image1.emf", height: 4.625in, width: 3.84375in))#strong[Условие
ввода строк:]

Пока последние 2 символа не являются цифрами.

#strong[\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_]

#strong[Условие обработки строки]:

Всякие разные.

#strong[ \ ]

#strong[Используемые средства]

В качестве интегрированной среды разработки использовалась JetBrains
CLion.

Для работы в консоли с потоками ввода-вывода использовалась стандартная
библиотека \<iostream\>.

Для работы со строками использовалась библиотека \<cstring\>.

#strong[ \ ]

#strong[UML-диаграмма программы:]

#box(image("lab-2/assets/media/image2.png", height: 3.61458in, width: 4.5in))

#strong[ \ ]

#strong[Код программы с комментариями]

#strong[main.cpp:]

\#include \<iostream\> \ \#include \"NString.h\" \ \ bool
check\_str(NString \*str); \ void process\_str(NString \*str); \ NString
get\_string(); \ void clear(); \ void pause(); \ \ char tmp\[80\]; \ \
int main() { \ while (true) { \ clear(); \ /\/ мне не хочется
придумывать пустой конструктор \ /\/ имея умный указатель, как я понял
это будет \ /\/ боль на 100+ строчек, поэтому сделать \ /\/ глобальную
переменную str не выйдет. \ NString str = get\_string(); \ if
(!check\_str(&str)) break; \ process\_str(&str); \ pause(); \ } \ return
0; \ } \ \ /\/ лучше дать имя в коде, чем писать комментарий что делает
эта строчка \ void clear() { \ system(\"cls\"); \ } \ \ NString
get\_string() { \ std::cout \<\< \"Enter a string (80 char max):\\n\"; \
std::cin.getline(tmp, 80); \ return NString(tmp); \ } \ \ /\/ проверка
на то, являются ли 2 последних символа числами \ bool check\_str(NString
\*str) { \ size\_t len = str-\>size(); \ if (len \<= 1) { \ return true;
\ } \ return !(str-\>get()\[len - 1\] \>= \'0\' && str-\>get()\[len -
1\] \<= \'9\' && str-\>get()\[len - 2\] \>= \'0\' && \ str-\>get()\[len
\- 2\] \<= \'9\'); \ } \ \ /\/ вывести все методы, которые я смог
придумать \ void process\_str(NString \*str) { \ std::cout \<\<
str-\>get() \<\< std::endl; \ std::cout \<\< str-\>to\_lowercase().get()
\<\< std::endl; \ std::cout \<\< str-\>capitalize().get() \<\<
std::endl; \ std::cout \<\< str-\>fill(\'\_\').get() \<\< std::endl; \
std::cout \<\< str-\>reverse().get() \<\< std::endl; \ std::cout \<\<
str-\>caesar\_cypher(5).get() \<\< std::endl; \ std::cout \<\<
str-\>caesar\_cypher(5).caesar\_cypher(-5).get() \<\< std::endl; \
std::cout \<\< str-\>replace\_numbers(\'\#\').get() \<\< std::endl; \ }
\ \ void pause() { \ system(\"pause\"); \ } \ \ void free() { \ \ }

#strong[NString.h:]

\#ifndef NSTRING\_NSTRING\_H \ \#define NSTRING\_NSTRING\_H \ \
\#include \<memory\> \ \ \ class NString { \ public: \ explicit
NString(const char \*string); \ \ /\/\~NString() = default; \ \ const
char \*get() const { \ return string.get(); \ } \ \ size\_t size()
const; \ \ NString capitalize() const; \ \ NString to\_lowercase()
const; \ \ NString concatenate(NString second\_string) const; \ \
NString fill(char new\_symbol) const; \ \ NString reverse() const; \ \
NString caesar\_cypher(int amount) const; \ \ NString
replace\_numbers(char new\_symbol) const; \ \ NString operator+(const
NString &right) const; \ \ private: \ std::unique\_ptr\<const char\[\]\>
string; \ \ static char \*cstr\_concatenation(const char \*str\_a, const
char \*str\_b); \ \ static char trimChar(char c); \ }; \ \ \ \#endif
\/\/NSTRING\_NSTRING\_H

#strong[ \ ]

#strong[NString.cpp:]

\#include \"NString.h\" \ \#include \<cstring\> \ \
NString::NString(const char \*string) { \ this-\>string =
std::unique\_ptr\<const char\[\]\>(string); \ } \ \ size\_t
NString::size() const { \ return strlen(this-\>get()); \ } \ \ NString
NString::to\_lowercase() const { \ size\_t size = this-\>size() + 1; \
char \*new\_string = new char\[size\]; \ for (int i = 0; i \< size - 1;
i++) { \ char tmp = this-\>string\[i\]; \ if (tmp \>= \'A\' && tmp \<=
\'Z\') { \ tmp += 32; \ } \ new\_string\[i\] = tmp; \ } \
new\_string\[size - 1\] = 0; \ return NString(new\_string); \ } \ \
NString NString::concatenate(NString second\_string) const { \ const
char \*result\_str = cstr\_concatenation(this-\>get(),
second\_string.get()); \ return NString(result\_str); \ } \ \ NString
NString::capitalize() const { \ size\_t size = this-\>size() + 1; \ char
\*new\_string = new char\[size\]; \ bool need\_capitalize = true; \ \
for (int i = 0; i \< size - 1; i++) { \ char tmp = this-\>string\[i\]; \
if (this-\>string\[i\] == \'.\') { \ need\_capitalize = true; \ } else
if (need\_capitalize) { \ if (tmp \>= \'a\' && tmp \<= \'z\') { \ tmp -=
32; \ } else if (tmp != \' \') { \ need\_capitalize = false; \ } \ }
else { \ if (tmp \>= \'A\' && tmp \<= \'Z\') { \ tmp += 32; \ } \ } \
new\_string\[i\] = tmp; \ } \ \ new\_string\[size - 1\] = 0; \ return
NString(new\_string); \ } \ \ char \*NString::cstr\_concatenation(const
char \*str\_a, const char \*str\_b) { \ size\_t size\_a =
strlen(str\_a); \ size\_t size\_b = strlen(str\_b); \ size\_t size =
size\_a + size\_b + 1; \ char \*new\_string = new char\[size\]; \ \ int
index = 0; \ for (int i = 0; i \< size\_a; i++, index++) { \
new\_string\[index\] = str\_a\[i\]; \ } \ for (int i = 0; i \< size\_b;
i++, index++) { \ new\_string\[index\] = str\_b\[i\]; \ } \ \
new\_string\[size - 1\] = 0; \ return new\_string; \ } \ \ NString
NString::fill(const char new\_symbol) const { \ size\_t size =
this-\>size() + 1; \ char \*new\_string = new char\[size\]; \ for (int i
\= 0; i \< size; i++) { \ if (this-\>get()\[i\] == \' \') { \
new\_string\[i\] = new\_symbol; \ } else { \ new\_string\[i\] =
this-\>get()\[i\]; \ } \ } \ return NString(new\_string); \ } \ \
NString NString::reverse() const { \ size\_t count = this-\>size(); \
char \*new\_string = new char\[count + 1\]; \ for (int i = 0; i \<
count; i++) { \ new\_string\[i\] = this-\>get()\[count - i - 1\]; \ } \
new\_string\[count\] = \'\\0\'; \ return NString(new\_string); \ } \ \
NString NString::caesar\_cypher(const int amount) const { \ size\_t size
\= this-\>size() + 1; \ char \*new\_string = new char\[size\]; \ for
(int i = 0; i \< size; i++) { \ char tmp = this-\>get()\[i\]; \ if (tmp
\>= \'a\' && tmp \<= \'z\') { \ tmp -= \'a\'; \ tmp += amount; \ tmp =
trimChar(tmp); \ tmp += \'a\'; \ } \ if (tmp \>= \'A\' && tmp \<= \'Z\')
{ \ tmp -= \'A\'; \ tmp += amount; \ tmp = trimChar(tmp); \ tmp +=
\'A\'; \ } \ new\_string\[i\] = tmp; \ } \ return NString(new\_string);
\ } \ \ NString NString::replace\_numbers(const char new\_symbol) const
{ \ size\_t size = this-\>size() + 1; \ char \*new\_string = new
char\[size\]; \ for (int i = 0; i \< size; i++) { \ char tmp =
this-\>get()\[i\]; \ if (tmp \>= \'0\' && tmp \<= \'9\') { \ tmp =
new\_symbol; \ } \ new\_string\[i\] = tmp; \ } \ return
NString(new\_string); \ } \ \ NString NString::operator+(const NString
&right) const { \ const char \*result\_str =
cstr\_concatenation(this-\>get(), right.get()); \ return
NString(result\_str); \ } \ \ char NString::trimChar(char c) { \ if (c
\>= 26) c -= 26; \ else if (c \< 0) c += 26; \ return c; \ }

#strong[ \ ]

#strong[Тестовые примеры]

#box(image("lab-2/assets/media/image3.png", height: 2.46667in, width: 6.72847in))
