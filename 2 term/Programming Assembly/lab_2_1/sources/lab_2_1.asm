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

; Подключение макросов
include C:\masm32\macros\macros.asm

.data
	symbol_count dd 0
	app_name db "Определитель високосности года студента группы ИВБ-211 Шефнера Альберта tm", 0
	message_enter_year db "Введите год: ", 0
	message_enter_year_size equ $-message_enter_year
	
	message_is_leap db "Этот год високосный.",13,10,0
	message_is_leap_size equ $-message_is_leap
	message_is_not_leap db "Этот год ВНИМАНИЕ не високосный.",13,10,0
	message_is_not_leap_size equ $-message_is_not_leap
	newline db 13, 10 

.data?
	year_string db 1024 dup(?)
	year_string_size dd ?
	year dd ?
	out_handler HANDLE ?                
 	in_handler HANDLE ?
 	
 .code
 _main proc
; Установка параметров консоли
 	invoke SetConsoleOutputCP, 1251
	invoke SetConsoleCP, 1251
	invoke SetConsoleTitleA, addr app_name
	
; Получение хэндлеров
	invoke GetStdHandle, STD_INPUT_HANDLE
	mov in_handler, eax
	invoke GetStdHandle, STD_OUTPUT_HANDLE
	mov out_handler, eax

processing_number:	
; Вывод начального сообщения
	invoke WriteConsoleA, out_handler, addr message_enter_year, message_enter_year_size, addr symbol_count, 0
	
; Получение строки с годом
	invoke ReadConsole, in_handler, addr year_string, lengthof year_string, addr year_string_size, 0
	
; Удаление символа переноса строки из конца строки года
	lea esi, [year_string]
	add esi, year_string_size
	sub esi, 2
	mov [esi], word ptr 0
	
; Перевод строки в число
	invoke atodw, addr year_string
	mov year, eax
	
; Выход из программы в случае, если пользователь ввёл 0, 
	cmp year, 0
	je main_end
	
; Проверка делится ли год на 400
	mov dx, word ptr year + 2
	mov ax, word ptr year
	mov cx, 400
	div cx
	
	; Сравнение остатка
	cmp dx, 0
	jne check_div_100
	jmp is_leap

; Проверка делится ли год на 100
check_div_100:
	mov dx, word ptr year + 2
	mov ax, word ptr year
	mov cx, 100
	div cx
	
	cmp dx, 0
	je is_not_leap
	
; Проверка делится ли год на 4
check_div_4:
	mov dx, word ptr year + 2
	mov ax, word ptr year
	mov cx, 4
	div cx
	
	cmp dx, 0
	je is_leap
	jmp is_not_leap
	
; Вывод результата определения високосности года
is_leap:
	invoke WriteConsoleA, out_handler, addr message_is_leap, message_is_leap_size, addr symbol_count, 0
	jmp processing_number
	
is_not_leap:
	invoke WriteConsoleA, out_handler, addr message_is_not_leap, message_is_not_leap_size, addr symbol_count, 0
	jmp processing_number
	
main_end:
	invoke WriteConsoleA, out_handler, addr newline, 2, addr symbol_count, 0
	inkey "Введите любую клавишу для продолжения..."
	invoke WriteConsoleA, out_handler, addr newline, 2, addr symbol_count, 0
	Ret
_main EndP
end _main
