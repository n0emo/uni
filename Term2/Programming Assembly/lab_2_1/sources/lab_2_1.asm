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

; ����������� ��������
include C:\masm32\macros\macros.asm

.data
	symbol_count dd 0
	app_name db "������������ ������������ ���� �������� ������ ���-211 ������� �������� tm", 0
	message_enter_year db "������� ���: ", 0
	message_enter_year_size equ $-message_enter_year
	
	message_is_leap db "���� ��� ����������.",13,10,0
	message_is_leap_size equ $-message_is_leap
	message_is_not_leap db "���� ��� �������� �� ����������.",13,10,0
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
; ��������� ���������� �������
 	invoke SetConsoleOutputCP, 1251
	invoke SetConsoleCP, 1251
	invoke SetConsoleTitleA, addr app_name
	
; ��������� ���������
	invoke GetStdHandle, STD_INPUT_HANDLE
	mov in_handler, eax
	invoke GetStdHandle, STD_OUTPUT_HANDLE
	mov out_handler, eax

processing_number:	
; ����� ���������� ���������
	invoke WriteConsoleA, out_handler, addr message_enter_year, message_enter_year_size, addr symbol_count, 0
	
; ��������� ������ � �����
	invoke ReadConsole, in_handler, addr year_string, lengthof year_string, addr year_string_size, 0
	
; �������� ������� �������� ������ �� ����� ������ ����
	lea esi, [year_string]
	add esi, year_string_size
	sub esi, 2
	mov [esi], word ptr 0
	
; ������� ������ � �����
	invoke atodw, addr year_string
	mov year, eax
	
; ����� �� ��������� � ������, ���� ������������ ��� 0, 
	cmp year, 0
	je main_end
	
; �������� ������� �� ��� �� 400
	mov dx, word ptr year + 2
	mov ax, word ptr year
	mov cx, 400
	div cx
	
	; ��������� �������
	cmp dx, 0
	jne check_div_100
	jmp is_leap

; �������� ������� �� ��� �� 100
check_div_100:
	mov dx, word ptr year + 2
	mov ax, word ptr year
	mov cx, 100
	div cx
	
	cmp dx, 0
	je is_not_leap
	
; �������� ������� �� ��� �� 4
check_div_4:
	mov dx, word ptr year + 2
	mov ax, word ptr year
	mov cx, 4
	div cx
	
	cmp dx, 0
	je is_leap
	jmp is_not_leap
	
; ����� ���������� ����������� ������������ ����
is_leap:
	invoke WriteConsoleA, out_handler, addr message_is_leap, message_is_leap_size, addr symbol_count, 0
	jmp processing_number
	
is_not_leap:
	invoke WriteConsoleA, out_handler, addr message_is_not_leap, message_is_not_leap_size, addr symbol_count, 0
	jmp processing_number
	
main_end:
	invoke WriteConsoleA, out_handler, addr newline, 2, addr symbol_count, 0
	inkey "������� ����� ������� ��� �����������..."
	invoke WriteConsoleA, out_handler, addr newline, 2, addr symbol_count, 0
	Ret
_main EndP
end _main
