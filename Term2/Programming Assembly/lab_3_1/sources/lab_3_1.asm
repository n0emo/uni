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

.data
	; Строки сообщений
	app_name db "Шефнер Лаб 3-1", 0
	row_i db "Строка [%d]:", 13, 10, 0
	enter_element_fmt db "   элемент [%d,%d]: ", 0
	num_fmt db "%d", 0
	output_fmt db "%5d", 0
	enter_matrix db "Введите матрицу.", 13, 10, 13, 10, 0
	entered_matrix db 13, 10, "Введённая матрица:", 13, 10, 13, 10, 0
	element_sum db 13, 10, "Сумма элементов матрицы: %d.", 13, 10, 13, 10, 0
	newline db 13, 10, 0
	
	row dd 0
	sum dd 0

.const
	ROWS equ 4
	COLS equ 5
	COUNT_2D equ ROWS * COLS

.data?
 	arr dd COUNT_2D dup(?)
 	
 .code
 get_index proto near c, row_idx: dword, col_idx: dword
  
 main proc near
	; Установка параметров консоли
 	invoke SetConsoleOutputCP, 1251
	invoke SetConsoleCP, 1251
	invoke SetConsoleTitleA, addr app_name
	; Вывод сообщения с просьбой ввести матрицу
	invoke crt_printf, addr enter_matrix
	; Считывание массива с консоли
	xor ecx, ecx
	for_rows_in: ; цикл строк
		push ecx
		mov row, ecx
		lea ecx, [ecx + 1]
		invoke crt_printf, addr row_i, ecx
		xor edx, edx
		for_cols_in: ; цикл столбцов
			push edx
			; Увеличение индексов на 1 для вывода
			mov ecx, row
			lea ecx, [ecx + 1]
			lea edx, [edx + 1]
			invoke crt_printf, addr enter_element_fmt, ecx, edx	
			; Получение индекса
			invoke get_index, row, [esp]
			lea eax, [arr + eax]
			; Запись числа в память по индексу
			invoke crt_scanf, addr num_fmt, eax
			; Условие цикла столбцов
			pop edx
			lea edx, [edx + 1] ; lea быстрее inc
			cmp edx, COLS
			jb for_cols_in
		; Условие цикла строк
		pop ecx
		lea ecx, [ecx + 1]
		cmp ecx, ROWS
		jb for_rows_in
	; Печать двух новых линий и сообщения о матрице
	invoke crt_printf, addr entered_matrix
	; Вывод массива в консоль
	xor eax, eax
	for_rows_out: ; Цикл строк
		push eax
		mov row, eax
		xor edx, edx
		for_cols_out: ; Цикл столбцов
			push edx
			; Получение элемента
			invoke get_index, row, edx
			mov eax, [arr + eax]
			add sum, eax
			; Вывод элемента
			invoke crt_printf, addr output_fmt, eax
			; Условие цикла столбцов
			pop edx
			inc edx
			cmp edx, COLS
			jb for_cols_out
		; Переход на следующую строку после вывода цтроки матрицы
		invoke crt_printf, addr newline
		; Условие цикла строк
		pop eax
		inc eax
		cmp eax, ROWS
		jb for_rows_out
	; Вывод суммы элементов массива
	invoke crt_printf, addr element_sum, sum
	; Конец программы
	invoke crt_printf, addr newline
	inkey "Нажмите любую клавишу для продолжения..."
	ret
main EndP

; Вспомогательная процедура, которая вычисляет индекс одномерного массива в байтах
 get_index proc near c, row_idx: dword, col_idx: DWORD
 	mov eax, row_idx
 	mov ebx, COLS
 	mul ebx
 	mov ebx, col_idx
 	lea eax, [eax + ebx]
 	lea eax, [eax*4]
	Ret
get_index EndP

end main




