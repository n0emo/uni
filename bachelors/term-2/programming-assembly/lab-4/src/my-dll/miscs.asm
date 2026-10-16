.686
.model flat, stdcall

include windows.inc
include masm32.inc
includelib masm32.lib
include kernel32.inc
includelib kernel32.lib
include msvcrt.inc
includelib msvcrt.lib
include C:\masm32\macros\macros.asm

.data
	enter_element_msg db "Введите элемент [%d]: ", 0
	num_fmt db "%d", 0
	out_num_fmt db "%d ", 0
	newline db 13, 10, 0

.code
get_arr_from_console proc, arr: dword, arr_size: dword
	xor ebx, ebx ; Обнуление счётчика цикла
	loop_arr_input:
		; Вывод в консоль переменной счётчика, увеличенной на 1
		lea ecx, [ebx + 1]
		invoke crt_printf, addr enter_element_msg, ecx
		; Получение адреса в памяти (элемента массива)
		mov esi, arr
		lea esi, [esi + ebx * 4]
		invoke crt_scanf, addr num_fmt, esi
		; Условие цикла
		lea ebx, [ebx + 1]
		cmp ebx, arr_size
		jb loop_arr_input
	Ret
get_arr_from_console EndP

write_arr_to_console proc, arr: dword, arr_size:dword
	xor ebx, ebx ; Счётчик цикла
	main_loop:	
		; Получение индекса, вывод элемента в консоль
		mov esi, arr
		mov eax, [esi + ebx * 4]
		invoke crt_printf, addr out_num_fmt, eax
		; Условие цикла
		lea ebx, [ebx + 1]
		cmp ebx, arr_size
		jb main_loop
	invoke crt_printf, addr newline
	Ret
write_arr_to_console EndP

sort_arr proc, arr: dword, arr_size: dword 
	xor ecx, ecx ; Обнуление счётчика шлавного цикла
	main_loop:
		mov esi, arr 
		lea esi, [esi + ecx * 4] ; Индекс
		mov edx, ecx     	     ; Счётчик поиска мин. элемента
		min_loop:				 ; Цикл поиска мин. элемениа
			mov eax, [esi]       ; Минимальный элемент
			mov edi, arr 
			lea edi, [edi + edx * 4]
			cmp eax, [edi]		 ; Сравнение минимального элемента с текущим
			jl @f
			mov esi, edi		 ; Запись нового индекса мин. элемента в случае, если нашёлся элемент меньше
			@@:
			; Условие цикла поиска мин. элемента
			lea edx, [edx + 1]
			cmp edx, arr_size
			jb min_loop
		; Поменять местами элементы массива по индексам ecx и esi
		mov edi, arr
		lea edi, [edi + ecx * 4]
		mov ebx, [edi]
		mov eax, [esi]
		mov [esi], ebx
		; Условие главного цикла
		mov [edi], eax
		lea ecx, [ecx + 1]
		cmp ecx, arr_size
		jb main_loop
	Ret
sort_arr EndP

dllmain proc h: dword, reason: dword, unused: dword
	.if reason == DLL_PROCESS_ATTACH
		mov eax, 1
	.elseif	reason == DLL_PROCESS_DETACH
	.elseif	reason == DLL_THREAD_ATTACH
	.elseif	reason == DLL_THREAD_DETACH
	.endif
	Ret
dllmain EndP

end dllmain