.686p											
.model flat, stdcall						
option casemap: none

; Подключение основных библиотек					
include windows.inc			 
include masm32.inc       		
includelib masm32.lib             
include kernel32.inc
includelib kernel32.lib 
include msvcrt.inc
includelib msvcrt.lib
include C:\masm32\macros\macros.asm ; Макросы

.data
	app_name db "Шефнер Лаб 2-2", 0
	; Строки сообщений
	enter_num_msg db "Введите число: ",  0
	undefined_msg db "Не определено", 13, 10, 0
	result_msg db "Значение функции: %d", 13, 10, 0
	f_j_msg db "f_j", 13, 10, 0
	num_fmt db "%d", 0
	newline db 13, 10, 0
	
	arg dd 0

.const
	a equ 15

 .code
 f_i proto near c, x: dword
 f_j proto near c, x: dword
  
 main proc near
	; Установка параметров консоли
 	invoke SetConsoleOutputCP, 1251
	invoke SetConsoleCP, 1251
	invoke SetConsoleTitleA, addr app_name
	; Получение аргумента
	invoke crt_printf, addr enter_num_msg
	invoke crt_scanf, addr num_fmt, addr arg
	; Вывод нужной функции в зависимости от того,
	; больше или меньше аргумент, чем а
	cmp arg, a
	jge less_than_a
	invoke f_j, arg ; вызов процедуры j, если аргумент меньше а
	jmp end_prog
	less_than_a:
	invoke f_i, arg ; вызов процедуры i, если аргумент, больше или равен а
	; Конец программы
	end_prog:
	invoke crt_printf, addr newline
	inkey "Нажмите любую клавишу для продолжения..."
	ret
main EndP

f_i proc near c, x: dword
	; Проверка, входит ли аргумент в диапозон от -50 до 50
	cmp arg, -50
	jl undefined
	cmp arg, 50
	jg undefined
	; Рассчёт по формуле
	mov eax, x
	mov ebx, x
	imul ebx
	mov ecx, eax
	mov eax, 2
	imul ebx
	add eax, ecx
	mov ebx, 10
	cdq
	idiv ebx
	; Вывод результата
	invoke crt_printf, addr result_msg, eax
	ret
	; Вывод "не определено", если аргумент не входит в диапозон
	undefined:
 		invoke crt_printf, addr undefined_msg
 		ret
f_i EndP

f_j proc near c, x: dword
	; Проверка, входит ли аргумент в диапозон от -50 до 50
	cmp arg, -50
	jl undefined
	cmp arg, -15
	jg undefined
	; Рассчёт по формуле
	mov ebx, x
	add ebx, 10
	mov eax, 1000
	cdq
	idiv ebx
	; Вывод результата
 	invoke crt_printf, addr result_msg, eax
	Ret
	; Вывод "не определено", если аргумент не входит в диапозон
	undefined:
 		invoke crt_printf, addr undefined_msg
 		ret
f_j EndP

end main

