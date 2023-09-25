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
include C:\masm32\macros\macros.asm

include ..\MyDLL\miscs.inc
includelib ..\MyDLL\miscs.lib

.data
	app_name db "Шефнер Лаб 3-2 с библиоекой", 0
	; Строки сообщений
	arr_size_msg db "Введите размер массива: ", 0
	num_fmt db "%d", 0
	newline db 13, 10, 0
	array_size dd 0

.data?
 	array dd ?
 	
.code

main proc near
	; Установка параметров консоли
 	console_init addr app_name, 1251
	; Вывод сообщения с просьбой ввести размер массива
	invoke crt_printf, addr arr_size_msg
	; Чтение размера массива с консоли
	invoke crt_scanf, addr num_fmt, addr array_size
	; Динамическое выделение памяти в зависимости от введённого размера
	mov eax, array_size
	lea eax, [eax * 4]
	invoke crt_malloc, eax  ; malloc в eax записал указатель на выделенную память,
	mov array, eax  		; который помещается в переменную array
	; Обработка массива
	invoke get_arr_from_console, array, array_size ; Получение элементо с консоли
	invoke sort_arr, array, array_size			   ; Сортировка массива
	invoke write_arr_to_console, array, array_size ; Вывод массива в консоль
	; Освобождение памяти
	invoke crt_free, array
	; Конец программы
	invoke crt_printf, addr newline
	inkey "Нажмите любую клавишу для продолжения..."
	ret
main EndP

end main
