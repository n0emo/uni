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

include ..\MyDLL\miscs.inc
includelib ..\MyDLL\miscs.lib

.data
	app_name db "������ ��� 3-2 � ����������", 0
	; ������ ���������
	arr_size_msg db "������� ������ �������: ", 0
	num_fmt db "%d", 0
	newline db 13, 10, 0
	array_size dd 0

.data?
 	array dd ?
 	
.code

main proc near
	; ��������� ���������� �������
 	console_init addr app_name, 1251
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

end main
