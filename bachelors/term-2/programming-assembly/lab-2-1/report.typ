ФЕДЕРАЛЬНОЕ АГЕНСТВО ЖЕЛЕЗНОДОРОЖНОГО ТРАНСПОРТА

Федеральное государственное бюджетное образовательное учреждение высшего
образования

«ПЕТЕРБУРГСКИЙ ГОСУДАРСТВЕННЫЙ УНИВЕРСИТЕТ ПУТЕЙ СООБЩЕНИЯ Императора
Александра I»

Кафедра «Информационные и вычислительные системы»

Дисциплина «Программирование (Ассемблер)»

#strong[ОТЧЁТ]

#strong[ПО ЛАБОРАТОРНОЙ РАБОТЕ № 2 (Часть 1)]

#figure(
  align(center)[#table(
    columns: (50.01%, 49.99%),
    align: (auto,auto,),
    table.header([Выполнил студент

      Факультет: АИТ

      Группа: ИВБ-211

      ], table.cell(align: right)[Шефнер А.

      ],),
    table.hline(),
    [Проверил:

    ], table.cell(align: right)[Кукин М.Ю.

    ],
  )]
  , kind: table
  )

#strong[Санкт-Петербург]

#strong[2023]

#strong[Постановка задачи.]

Требуется написать программу, которая получает на входе год и выводит,
является ли этот год високосным.

#strong[Код программы.]

\.686p ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~

\.model flat, stdcall ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~

option casemap: none

\; Подключение основных библиотек ~ ~ ~ ~ ~ ~ ~ ~ ~ ~

include windows.inc ~ ~ ~ ~ ~

include masm32.inc ~ ~ ~ ~ ~ ~ ~

includelib masm32.lib ~ ~ ~ ~ ~ ~

include kernel32.inc

includelib kernel32.lib

include msvcrt.inc

includelib msvcrt.lib

\; Подключение макросов

include C:\\masm32\\macros\\macros.asm

\.data

~ ~ symbol\_count dd 0

~ ~ app\_name db \"Определитель високосности года студента группы
ИВБ-211 Шефнера Альберта tm\", 0

~ ~ message\_enter\_year db \"Введите год: \", 0

~ ~ message\_enter\_year\_size equ \$-message\_enter\_year

~ ~

~ ~ message\_is\_leap db \"Этот год високосный.\",13,10,0

~ ~ message\_is\_leap\_size equ \$-message\_is\_leap

~ ~ message\_is\_not\_leap db \"Этот год ВНИМАНИЕ не
високосный.\",13,10,0

~ ~ message\_is\_not\_leap\_size equ \$-message\_is\_not\_leap

~ ~ newline db 13, 10

\.data?

~ ~ year\_string db 1024 dup(?)

~ ~ year\_string\_size dd ?

~ ~ year dd ?

~ ~ out\_handler HANDLE ? ~ ~ ~ ~ ~ ~ ~ ~

~ ~ in\_handler HANDLE ?

~ ~

~.code

~\_main proc

\; Установка параметров консоли

~ ~ invoke SetConsoleOutputCP, 1251

~ ~ invoke SetConsoleCP, 1251

~ ~ invoke SetConsoleTitleA, addr app\_name

~ ~

\; Получение хэндлеров

~ ~ invoke GetStdHandle, STD\_INPUT\_HANDLE

~ ~ mov in\_handler, eax

~ ~ invoke GetStdHandle, STD\_OUTPUT\_HANDLE

~ ~ mov out\_handler, eax

processing\_number: ~

\; Вывод начального сообщения

~ ~ invoke WriteConsoleA, out\_handler, addr message\_enter\_year,
message\_enter\_year\_size, addr symbol\_count, 0

~ ~

\; Получение строки с годом

~ ~ invoke ReadConsole, in\_handler, addr year\_string, lengthof
year\_string, addr year\_string\_size, 0

~ ~

\; Удаление символа переноса строки из конца строки года

~ ~ lea esi, \[year\_string\]

~ ~ add esi, year\_string\_size

~ ~ sub esi, 2

~ ~ mov \[esi\], word ptr 0

~ ~

\; Перевод строки в число

~ ~ invoke atodw, addr year\_string

~ ~ mov year, eax

~ ~

\; Выход из программы в случае, если пользователь ввёл 0,

~ ~ cmp year, 0

~ ~ je main\_end

~ ~

\; Проверка делится ли год на 400

~ ~ mov dx, word ptr year + 2

~ ~ mov ax, word ptr year

~ ~ mov cx, 400

~ ~ div cx

~ ~

~ ~ \; Сравнение остатка

~ ~ cmp dx, 0

~ ~ jne check\_div\_100

~ ~ jmp is\_leap

\; Проверка делится ли год на 100

check\_div\_100:

~ ~ mov dx, word ptr year + 2

~ ~ mov ax, word ptr year

~ ~ mov cx, 100

~ ~ div cx

~ ~

~ ~ cmp dx, 0

~ ~ je is\_not\_leap

~ ~

\; Проверка делится ли год на 4

check\_div\_4:

~ ~ mov dx, word ptr year + 2

~ ~ mov ax, word ptr year

~ ~ mov cx, 4

~ ~ div cx

~ ~

~ ~ cmp dx, 0

~ ~ je is\_leap

~ ~ jmp is\_not\_leap

~ ~

\; Вывод результата определения високосности года

is\_leap:

~ ~ invoke WriteConsoleA, out\_handler, addr message\_is\_leap,
message\_is\_leap\_size, addr symbol\_count, 0

~ ~ jmp processing\_number

~ ~

is\_not\_leap:

~ ~ invoke WriteConsoleA, out\_handler, addr message\_is\_not\_leap,
message\_is\_not\_leap\_size, addr symbol\_count, 0

~ ~ jmp processing\_number

~ ~

main\_end:

~ ~ invoke WriteConsoleA, out\_handler, addr newline, 2, addr
symbol\_count, 0

~ ~ inkey \"Введите любую клавишу для продолжения...\"

~ ~ invoke WriteConsoleA, out\_handler, addr newline, 2, addr
symbol\_count, 0

~ ~ Ret

\_main EndP

end \_main

#strong[ \ ]

#strong[Отладка программы.]

#box(image("programming-assembly/lab-2-1/assets/media/image1.png", height: 4.47979in, width: 4.39645in))

#strong[Выводы.]

Я научился выполнять арифметическую операцию деления, выполнять условные
переходы, с помощью которых можно сделать как ветвления, так и циклы.
