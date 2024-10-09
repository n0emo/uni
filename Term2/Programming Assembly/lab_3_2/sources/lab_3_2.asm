.686p											
.model flat, stdcall						
option casemap: none

; ����������� �������� ���������					
include windows.inc			 
include masm32.inc       		
includelib masm32.lib             
include kernel32.inc
includelib kernel32.lib 
include msvcrt.inc
includelib msvcrt.lib
include C:\masm32\macros\macros.asm

.data
	app_name db "������ ��� 3-1", 0
	; ������ ���������
	arr_size_msg db "������� ������ �������: ", 0
	enter_element_msg db "������� ������� [%d]: ", 0
	num_fmt db "%d", 0
	out_num_fmt db "%d ", 0 
	newline db 13, 10, 0
	array_size dd 0

.data?
 	array dd ?
 	
.code
get_arr_from_console proto, arr: dword, arr_size: dword
sort_arr proto, arr: dword, arr_size: dword
write_arr_to_console proto, arr: dword, arr_size: dword
  
main proc near
	; ��������� ���������� �������
 	invoke SetConsoleOutputCP, 1251
	invoke SetConsoleCP, 1251
	invoke SetConsoleTitleA, addr app_name
	; ����� ��������� � �������� ������ ������ �������
	invoke crt_printf, addr arr_size_msg
	; ������ ������� ������� � �������
	invoke crt_scanf, addr num_fmt, addr array_size
	; ������������ ��������� ������ � ����������� �� ��������� �������
	mov eax, array_size
	lea eax, [eax * 4]
	invoke crt_malloc, eax  ; malloc � eax ������� ��������� �� ���������� ������,
	mov array, eax  		; ������� ���������� � ���������� array
	; ��������� �������
	invoke get_arr_from_console, array, array_size ; ��������� �������� � �������
	invoke sort_arr, array, array_size			   ; ���������� �������
	invoke write_arr_to_console, array, array_size ; ����� ������� � �������
	; ������������ ������
	invoke crt_free, array
	; ����� ���������
	invoke crt_printf, addr newline
	inkey "������� ����� ������� ��� �����������..."
	ret
main EndP

get_arr_from_console proc, arr: dword, arr_size: dword
	print "Chto-to"
	xor ebx, ebx ; ��������� �������� �����
	loop_arr_input:
		; ����� � ������� ���������� ��������, ����������� �� 1
		lea ecx, [ebx + 1]
		invoke crt_printf, addr enter_element_msg, ecx
		; ��������� ������ � ������ (�������� �������)
		mov esi, arr
		lea esi, [esi + ebx * 4]
		invoke crt_scanf, addr num_fmt, esi
		; ������� �����
		lea ebx, [ebx + 1]
		cmp ebx, arr_size
		jb loop_arr_input
	Ret
get_arr_from_console EndP

sort_arr proc, arr: dword, arr_size: dword 
	xor ecx, ecx ; ��������� �������� �������� �����
	main_loop:
		mov esi, arr 
		lea esi, [esi + ecx * 4] ; ������
		mov edx, ecx     	     ; ������� ������ ���. ��������
		min_loop:				 ; ���� ������ ���. ��������
			mov eax, [esi]       ; ����������� �������
			mov edi, arr 
			lea edi, [edi + edx * 4]
			cmp eax, [edi]		 ; ��������� ������������ �������� � �������
			jl @f
			mov esi, edi		 ; ������ ������ ������� ���. �������� � ������, ���� ������� ������� ������
			@@:
			; ������� ����� ������ ���. ��������
			lea edx, [edx + 1]
			cmp edx, arr_size
			jb min_loop
		; �������� ������� �������� ������� �� �������� ecx � esi
		mov edi, arr
		lea edi, [edi + ecx * 4]
		mov ebx, [edi]
		mov eax, [esi]
		mov [esi], ebx
		; ������� �������� �����
		mov [edi], eax
		lea ecx, [ecx + 1]
		cmp ecx, arr_size
		jb main_loop
	Ret
sort_arr EndP

write_arr_to_console proc, arr: dword, arr_size:dword
	xor ebx, ebx ; ������� �����
	main_loop:	
		; ��������� �������, ����� �������� � �������
		mov esi, arr
		mov eax, [esi + ebx * 4]
		invoke crt_printf, addr out_num_fmt, eax
		; ������� �����
		lea ebx, [ebx + 1]
		cmp ebx, arr_size
		jb main_loop
	invoke crt_printf, addr newline
	Ret
write_arr_to_console EndP

end main
