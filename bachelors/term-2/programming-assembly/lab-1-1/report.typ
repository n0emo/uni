ФЕДЕРАЛЬНОЕ АГЕНСТВО ЖЕЛЕЗНОДОРОЖНОГО ТРАНСПОРТА

Федеральное государственное бюджетное образовательное учреждение высшего
образования

«ПЕТЕРБУРГСКИЙ ГОСУДАРСТВЕННЫЙ УНИВЕРСИТЕТ ПУТЕЙ СООБЩЕНИЯ Императора
Александра I»

Кафедра «Информационные и вычислительные системы»

Дисциплина «Программирование (Ассемблер)»

#strong[ОТЧЁТ]

#strong[ПО ЛАБОРАТОРНОЙ РАБОТЕ № 1 (Часть 1)]

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

Требуется написать программу, которая получает на входе сообщение. На
выходе программа выводит сначала введённое сообщение ближе к центру
консоли, а затем выводит заранее подготовленное сообщение после
введённой строки.

#strong[Код программы.]

\.386

\.model flat, stdcall

option casemap: none

\; Подключение основных библиотек

include windows.inc

include masm32.inc

includelib masm32.lib

include kernel32.inc

includelib kernel32.lib

include msvcrt.inc

includelib msvcrt.lib

\; Подключение макросов

include C:\\masm32\\macros\\macros.asm

\.data

~ ~ symbols\_count dd 0

~ ~ app\_name db \"Консось\",0

~ ~ hello\_world\_message db \"Hello мир!\",13,10,0

~ ~ hello\_world\_message\_size equ \$-hello\_world\_message

~ ~ pos label dword

~ ~ cord COORD \<\>

\.data?

~ ~ out\_handler HANDLE ?

~ ~ in\_handler HANDLE ?

~ ~ input\_string db 1024 dup(?)

~ ~ input\_string\_size dd ?

~ ~

\.code

\_main PROC

~ ~ \; Настройка консоли

~ ~ invoke SetConsoleOutputCP, 1251

~ ~ invoke SetConsoleCP, 1251

~ ~ invoke SetConsoleTitleA, Addr app\_name

~ ~

~ ~ \; Получение хэндлеров

~ ~ invoke GetStdHandle, STD\_OUTPUT\_HANDLE

~ ~ Mov out\_handler, EAX

~ ~ invoke GetStdHandle, STD\_INPUT\_HANDLE

~ ~ Mov in\_handler, EAX

~ ~

~ ~ \; Получение input\_string

~ ~ invoke ReadConsole, in\_handler, Addr input\_string, lengthof
input\_string, Addr input\_string\_size, 0

~ ~

~ ~ \; Установка позиции курсора на (13,6) и вывод сообщение \"Hello
мир\"

~ ~ mov cord.x, 13

~ ~ mov cord.y, 6

~ ~ invoke SetConsoleCursorPosition, out\_handler, pos

~ ~ invoke WriteConsoleA, out\_handler, Addr input\_string,
input\_string\_size, Addr symbols\_count, 0

~ ~

~ ~ \; Установка позиции курсора на (0,1) и вывод полученного ранее
input\_string

~ ~ mov cord.x, 0

~ ~ mov cord.y, 1

~ ~ invoke SetConsoleCursorPosition, out\_handler, pos

~ ~ invoke WriteConsoleA, out\_handler, Addr hello\_world\_message,
hello\_world\_message\_size, Addr symbols\_count, 0

~ ~

~ ~ \; Установка позиции курсора на (0,7) и вызов макроса inkey

~ ~ mov cord.x, 0

~ ~ mov cord.y, 7

~ ~ invoke SetConsoleCursorPosition, out\_handler, pos

~ ~ inkey \"Введите любую клавишу для продолжения...\"

~ ~

~ ~ ret

\_main ENDP

end \_main

#strong[Отладка программы.]

#box(image("programming-assembly/lab-1-1/assets/media/image1.png", height: 2.63578in, width: 6.12586in))

#strong[Выводы.]

Я научился устанавливать параметры консоли, вводить и выводить строки,
устанавливать позицию курсора.
