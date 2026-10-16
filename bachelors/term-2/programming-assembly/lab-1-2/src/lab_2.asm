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
 	symbols_count dd 0                    
 	app_name db "консось",0 
	message_enter_num db "Введите десятичное число: ",0
	message_enter_num_size equ $-message_enter_num
	message_result db "Удвоенное число равно: ",0 	
	message_result_size equ $-message_result 
	newline db 13, 10 ;набор служебных символов для перевода строки	         

.data?								
	num_string db 1024 dup(?)           
 	num_string_size dd ?                 
	number dd ?						
 	in_handler HANDLE ?                
 	out_handler HANDLE ?                 
.code                              	

_main proc
; Настройка консоли
	invoke SetConsoleOutputCP, 1251
	invoke SetConsoleCP, 1251
	invoke SetConsoleTitleA, Addr app_name
	
; Получение хэндлеров
	invoke GetStdHandle, STD_OUTPUT_HANDLE
	mov out_handler, eax
	invoke GetStdHandle, STD_INPUT_HANDLE
	mov in_handler, eax
	
; Вывод сообщения с просьбой ввести число
	invoke WriteConsoleA, out_handler, Addr message_enter_num, message_enter_num_size, Addr symbols_count, 0
	invoke ReadConsole, in_handler, Addr num_string, lengthof num_string, Addr num_string_size, 0

; Удаление символов переноса строки в конце строки числа
	lea esi, [num_string]
	mov eax, num_string_size
	lea esi, [esi + eax - 2]
	mov [esi], word ptr 0
	
; Преобразование строки в число и его удвоение
	invoke atodw, Addr num_string
	; mov number, eax
	mov ebx, 2
	mul ebx

; Обратное преобразование числа в строку и увеличение размера на 1 для уверенности
	invoke dwtoa, eax, Addr num_string
	Add num_string_size, 1
	
; Вывод результата
	invoke WriteConsoleA, out_handler, Addr message_result, message_result_size, Addr symbols_count, 0
	invoke WriteConsoleA, out_handler, Addr num_string, num_string_size, Addr symbols_count, 0
	invoke WriteConsoleA, out_handler, Addr newline, 2, Addr symbols_count, 0

	inkey "Нажмите любую клавишу..."
	ret
_main EndP
end _main
