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
include C:\masm32\macros\macros.asm ; �������

.data
	app_name db "������ ��� 2-2", 0
	; ������ ���������
	enter_num_msg db "������� �����: ",  0
	undefined_msg db "�� ����������", 13, 10, 0
	result_msg db "�������� �������: %d", 13, 10, 0
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
	; ��������� ���������� �������
 	invoke SetConsoleOutputCP, 1251
	invoke SetConsoleCP, 1251
	invoke SetConsoleTitleA, addr app_name
	; ��������� ���������
	invoke crt_printf, addr enter_num_msg
	invoke crt_scanf, addr num_fmt, addr arg
	; ����� ������ ������� � ����������� �� ����,
	; ������ ��� ������ ��������, ��� �
	cmp arg, a
	jge less_than_a
	invoke f_j, arg ; ����� ��������� j, ���� �������� ������ �
	jmp end_prog
	less_than_a:
	invoke f_i, arg ; ����� ��������� i, ���� ��������, ������ ��� ����� �
	; ����� ���������
	end_prog:
	invoke crt_printf, addr newline
	inkey "������� ����� ������� ��� �����������..."
	ret
main EndP

f_i proc near c, x: dword
	; ��������, ������ �� �������� � �������� �� -50 �� 50
	cmp arg, -50
	jl undefined
	cmp arg, 50
	jg undefined
	; ������� �� �������
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
	; ����� ����������
	invoke crt_printf, addr result_msg, eax
	ret
	; ����� "�� ����������", ���� �������� �� ������ � ��������
	undefined:
 		invoke crt_printf, addr undefined_msg
 		ret
f_i EndP

f_j proc near c, x: dword
	; ��������, ������ �� �������� � �������� �� -50 �� 50
	cmp arg, -50
	jl undefined
	cmp arg, -15
	jg undefined
	; ������� �� �������
	mov ebx, x
	add ebx, 10
	mov eax, 1000
	cdq
	idiv ebx
	; ����� ����������
 	invoke crt_printf, addr result_msg, eax
	Ret
	; ����� "�� ����������", ���� �������� �� ������ � ��������
	undefined:
 		invoke crt_printf, addr undefined_msg
 		ret
f_j EndP

end main

