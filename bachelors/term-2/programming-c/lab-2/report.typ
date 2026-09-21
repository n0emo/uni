МИНИСТЕРСТВО ТРАНСПОРТА РОССИЙСКОЙ ФЕДЕРАЦИИ

ФЕДЕРАЛЬНОЕ АГЕНТСТВО ЖЕЛЕЗНОДОРОЖНОГО ТРАНСПОРТА

Государственное бюджетное образовательное учреждение

высшего образования

«ПЕТЕРБУРГСКИЙ ГОСУДАРСТВЕННЫЙ УНИВЕРСИТЕТ

ПУТЕЙ СООБЩЕНИЯ ИМПЕРАТОРА АЛЕКСАНДРА I»

Кафедра «ИНФОРМАЦИОННЫЕ И ВЫЧИСЛИТЕЛЬНЫЕ СИСТЕМЫ»

Дисциплина: «Программирование(C)»

ОТЧЕТ

по лабораторной работе № 2

Вариант #emph[19]

Выполнил студент Шефнер А.

Факультета #emph[АИТ]

Группы #emph[ИВБ-211]

Санкт-Петербург

2023

#emph[#strong[ \ ]]

#strong[Постановка задачи (вариант 19)]

Дана кусочно-разрывная функция, т.е. имеющая различное аналитическое
представление в зависимости от диапазона.

Написать функциональное представление для этой функции на всем
диапазоне, табулировать функцию, вычислить площадь под этой функцией.

Функция:

$ f\(x\)= {2 s i n x\;x < med - 2\
x\;med - 2 lt.eq x < 1\
ln\(1 + x\)\;x gt.eq 1 med $

#box(image("lab-2/assets/media/image1.png", height: 3.55764in, width: 4.54236in))

Входные данные: заданные функции у1, у2, у3 передаваемые как параметры,
границы диапазонов a, b, x1, x2.

Выходные данные: листинг функции y(x, y1, y2, y3, x1, x2), значения
площади под каждой функцией с1, с2, с3 и под всей функцией.

#strong[ \ Код программы]

#strong[main.c]

\#include \<stdio.h\> \ \#include \"funcs.h\" \ \ double
func\_default(double x); \ \ double x1; \ double x2; \ double c1; \
double c2; \ double c3; \ double c4; \ double a, b, dx; \ \ int main() {
\ x1 = -2; \ x2 = 1; \ a = -5.67; \ b = 9.5; \ dx = 0.001; \ \
printf\_s(\"\\nResults for:\\nx1 = %lf, x2 = %lf\\na = %lf, b = %lf\\ndx
\= %lf\\n\", x1, x2, a, b, dx); \ c1 = calc\_area(func\_1, a, x1, dx); \
c2 = calc\_area(func\_2, x1, x2, dx); \ c3 = calc\_area(func\_3, x2, b,
dx); \ c4 = calc\_area(func\_default, a, b, dx); \ \ printf\_s(\"func 1
area between a and x1: %lf\\n\", c1); \ printf\_s(\"func 2 area between
x1 and x2: %lf\\n\", c2); \ printf\_s(\"func 3 area between x2 and b:
%lf\\n\", c3); \ printf\_s(\"function area between a and b: %lf\\n\",
c4);

return 0; \ } \ \ double func\_default(double x) { \ return func(x, \
func\_1, \ func\_2, \ func\_3, \ x1, \ x2); \ }

#strong[ \ ]

#strong[funcs.h]

\#ifndef C\_LAB\_2\_FUNCS\_H \ \#define C\_LAB\_2\_FUNCS\_H \ \ double
calc\_area(double (\*f)(double), double a, double b, double dx); \ \
double func(double x, \ double (\*f1)(double), \ double (\*f2)(double),
\ double(\*f3)(double), \ double x1, \ double x2); \ \ double
func\_1(double x); \ \ double func\_2(double x); \ \ double
func\_3(double x); \ \ \#endif

#strong[ \ ]

#strong[funcs.c]

\#include \"funcs.h\" \ \#include \"math.h\" \ \ double
calc\_area(double (\*f)(double), double a, double b, double dx) { \
double sum = 0; \ while(a \< b + (dx / 2)) { \ sum += dx \* f(a); \ a +=
dx; \ } \ \ return sum; \ } \ \ double func(double x, \ double
(\*f1)(double), \ double (\*f2)(double), \ double(\*f3)(double), \
double x1, \ double x2) { \ if(x \< x1) return f1(x); \ if(x \< x2)
return f2(x); \ return f3(x); \ } \ \ double func\_1(double x) { \
return 2 \* sin(x); \ } \ \ double func\_2(double x) { \ return x; \ } \
\ double func\_3(double x) { \ return log(++x); \ }

#strong[ \ ]

#strong[Отладка приложения:]

#box(image("lab-2/assets/media/image2.png", height: 4.69306in, width: 6.80625in))

#strong[ \ ]

#strong[Проверка в другом приложении (WolframAlpha)]

#box(image("lab-2/assets/media/image3.png", height: 3.02083in, width: 3.5625in))#box(image("lab-2/assets/media/image4.png", height: 2.83373in, width: 3.06293in))

#box(image("lab-2/assets/media/image5.png", height: 3.49007in, width: 3.27129in))

#box(image("lab-2/assets/media/image6.png", height: 1.45854in, width: 3.89638in))
