.386
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
	symbols_count dd 0
	app_name db "Консось", 0
	hello_world_message db "Hello мир!", 13, 10, 0
	hello_world_message_size equ $-hello_world_message
	pos label dword
	cord COORD <>
	
.data?
	out_handler HANDLE ?
	in_handler HANDLE ?
	input_string db 1024 dup(?)
	input_string_size dd ?
	
.code
_main PROC
	; Настройка консоли
	invoke SetConsoleOutputCP, 1251
	invoke SetConsoleCP, 1251
	invoke SetConsoleTitleA, Addr app_name
	
	; Получение хэндлеров
	invoke GetStdHandle, STD_OUTPUT_HANDLE
	mov out_handler, EAX
	invoke GetStdHandle, STD_INPUT_HANDLE
	mov in_handler, EAX
	
	; Получение input_string
	invoke ReadConsole, in_handler, Addr input_string, lengthof input_string, Addr input_string_size, 0
	
	; Установка позиции курсора на (13,6) и вывод полученного ранее input_string
	mov cord.x, 13
	mov cord.y, 6
	invoke SetConsoleCursorPosition, out_handler, pos
	invoke WriteConsoleA, out_handler, Addr input_string, input_string_size, Addr symbols_count, 0
	
	; Установка позиции курсора на (0,1) и вывод сообщение "Hello мир"
	mov cord.x, 0
	mov cord.y, 1
	invoke SetConsoleCursorPosition, out_handler, pos
	invoke WriteConsoleA, out_handler, Addr hello_world_message, hello_world_message_size, Addr symbols_count, 0
	
	; Установка позиции курсора на (0,7) и вызов макроса inkey
	mov cord.x, 0
	mov cord.y, 7
	invoke SetConsoleCursorPosition, out_handler, pos
	inkey "Введите любую клавишу для продолжения..."
	
	ret
_main ENDP
end _main
