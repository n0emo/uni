ФЕДЕРАЛЬНОЕ АГЕНСТВО ЖЕЛЕЗНОДОРОЖНОГО ТРАНСПОРТА

Федеральное государственное бюджетное образовательное учреждение высшего
образования

«ПЕТЕРБУРГСКИЙ ГОСУДАРСТВЕННЫЙ УНИВЕРСИТЕТ ПУТЕЙ СООБЩЕНИЯ Императора
Александра I»

Кафедра «Информационные и вычислительные системы»

Дисциплина «Программирование (Ассемблер)»

#strong[ОТЧЁТ]

#strong[ПО ЛАБОРАТОРНОЙ РАБОТЕ № 1 (Часть 2)]

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

Требуется написать программу, которая получает на входе число, удваивает
его и выводит обратно в консоль.

#strong[Код программы.]

\.686p

\.model flat, stdcall

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

~ ~ symbols\_count dd 0 ~ ~ ~ ~ ~ ~ ~ ~ ~ ~

~ ~ app\_name db \"консось\",0

~ ~ message\_enter\_num db \"Введите десятичное число: \",0

~ ~ message\_enter\_num\_size equ \$-message\_enter\_num

~ ~ message\_result db \"Удвоенное число равно: \",0 ~

~ ~ message\_result\_size equ \$-message\_result

~ ~ newline db 13, 10 ~ ~ ~ ~ ~ ~ ~ \;набор служебных символов для
перевода строки ~ ~ ~ ~ ~ ~

\.data? ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~

~ ~ num\_string db 1024 dup(?) ~ ~ ~ ~ ~

~ ~ num\_string\_size dd ? ~ ~ ~ ~ ~ ~ ~ ~

~ ~ number dd ? ~ ~ ~ ~ ~ ~ ~ ~ ~ ~

~ ~ in\_handler HANDLE ? ~ ~ ~ ~ ~ ~ ~ ~

~ ~ out\_handler HANDLE ? ~ ~ ~ ~ ~ ~ ~ ~

\.code ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~

\_main proc

\; Настройка консоли

~ ~ invoke SetConsoleOutputCP, 1251

~ ~ invoke SetConsoleCP, 1251

~ ~ invoke SetConsoleTitleA, Addr app\_name

~ ~

\; Получение хэндлеров

~ ~ invoke GetStdHandle, STD\_OUTPUT\_HANDLE

~ ~ mov out\_handler, eax

~ ~ invoke GetStdHandle, STD\_INPUT\_HANDLE

~ ~ mov in\_handler, eax

~ ~

\; Вывод сообщения с просьбой ввести число

~ ~ invoke WriteConsoleA, out\_handler, Addr message\_enter\_num,
message\_enter\_num\_size, Addr symbols\_count, 0

~ ~ invoke ReadConsole, in\_handler, Addr num\_string, lengthof
num\_string, Addr num\_string\_size, 0

\; Удаление символов переноса строки в конце строки числа

~ ~ lea esi, \[num\_string\]

~ ~ add esi, num\_string\_size

~ ~ sub esi, 2

~ ~ mov \[esi\], word ptr 0

~ ~

\; Преобразование строки в число и его удвоение

~ ~ invoke atodw, Addr num\_string

~ ~ mov number, eax

~ ~ mov ebx, 2

~ ~ mul ebx

\; Обратное преобразование числа в строку и увеличение размера на 1 для
уверенности

~ ~ invoke dwtoa, eax, Addr num\_string

~ ~ Add num\_string\_size, 1

~ ~

\; Вывод результата

~ ~ invoke WriteConsoleA, out\_handler, Addr message\_result,
message\_result\_size, Addr symbols\_count, 0

~ ~ invoke WriteConsoleA, out\_handler, Addr num\_string,
num\_string\_size, Addr symbols\_count, 0

~ ~ invoke WriteConsoleA, out\_handler, Addr newline, 2, Addr
symbols\_count, 0

~ ~ inkey \"Нажмите любую клавишу...\"

~ ~ ret

\_main EndP

end \_main

#strong[Отладка программы.]

#box(image("programming-assembly/lab-1-2/assets/media/image1.png", height: 1.75024in, width: 3.72969in))

#strong[Выводы.]

Я переводить строку в число и обратно, выполнять арифметические операции
сложения, вычитания и умножения.
