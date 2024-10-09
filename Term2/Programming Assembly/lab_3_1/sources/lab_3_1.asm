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
	; ������ ���������
	app_name db "������ ��� 3-1", 0
	row_i db "������ [%d]:", 13, 10, 0
	enter_element_fmt db "   ������� [%d,%d]: ", 0
	num_fmt db "%d", 0
	output_fmt db "%5d", 0
	enter_matrix db "������� �������.", 13, 10, 13, 10, 0
	entered_matrix db 13, 10, "�������� �������:", 13, 10, 13, 10, 0
	element_sum db 13, 10, "����� ��������� �������: %d.", 13, 10, 13, 10, 0
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
	; ��������� ���������� �������
 	invoke SetConsoleOutputCP, 1251
	invoke SetConsoleCP, 1251
	invoke SetConsoleTitleA, addr app_name
	; ����� ��������� � �������� ������ �������
	invoke crt_printf, addr enter_matrix
	; ���������� ������� � �������
	xor ecx, ecx
	for_rows_in: ; ���� �����
		push ecx
		mov row, ecx
		lea ecx, [ecx + 1]
		invoke crt_printf, addr row_i, ecx
		xor edx, edx
		for_cols_in: ; ���� ��������
			push edx
			; ���������� �������� �� 1 ��� ������
			mov ecx, row
			lea ecx, [ecx + 1]
			lea edx, [edx + 1]
			invoke crt_printf, addr enter_element_fmt, ecx, edx	
			; ��������� �������
			invoke get_index, row, [esp]
			lea eax, [arr + eax]
			; ������ ����� � ������ �� �������
			invoke crt_scanf, addr num_fmt, eax
			; ������� ����� ��������
			pop edx
			lea edx, [edx + 1] ; lea ������� inc
			cmp edx, COLS
			jb for_cols_in
		; ������� ����� �����
		pop ecx
		lea ecx, [ecx + 1]
		cmp ecx, ROWS
		jb for_rows_in
	; ������ ���� ����� ����� � ��������� � �������
	invoke crt_printf, addr entered_matrix
	; ����� ������� � �������
	xor eax, eax
	for_rows_out: ; ���� �����
		push eax
		mov row, eax
		xor edx, edx
		for_cols_out: ; ���� ��������
			push edx
			; ��������� ��������
			invoke get_index, row, edx
			mov eax, [arr + eax]
			add sum, eax
			; ����� ��������
			invoke crt_printf, addr output_fmt, eax
			; ������� ����� ��������
			pop edx
			inc edx
			cmp edx, COLS
			jb for_cols_out
		; ������� �� ��������� ������ ����� ������ ������ �������
		invoke crt_printf, addr newline
		; ������� ����� �����
		pop eax
		inc eax
		cmp eax, ROWS
		jb for_rows_out
	; ����� ����� ��������� �������
	invoke crt_printf, addr element_sum, sum
	; ����� ���������
	invoke crt_printf, addr newline
	inkey "������� ����� ������� ��� �����������..."
	ret
main EndP

; ��������������� ���������, ������� ��������� ������ ����������� ������� � ������
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




