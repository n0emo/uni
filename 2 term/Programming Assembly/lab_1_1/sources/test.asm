.386
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
	symbols_count dd 0
	app_name db "�������", 0
	hello_world_message db "Hello ���!", 13, 10, 0
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
	; ��������� �������
	invoke SetConsoleOutputCP, 1251
	invoke SetConsoleCP, 1251
	invoke SetConsoleTitleA, Addr app_name
	
	; ��������� ���������
	invoke GetStdHandle, STD_OUTPUT_HANDLE
	mov out_handler, EAX
	invoke GetStdHandle, STD_INPUT_HANDLE
	mov in_handler, EAX
	
	; ��������� input_string
	invoke ReadConsole, in_handler, Addr input_string, lengthof input_string, Addr input_string_size, 0
	
	; ��������� ������� ������� �� (13,6) � ����� ����������� ����� input_string
	mov cord.x, 13
	mov cord.y, 6
	invoke SetConsoleCursorPosition, out_handler, pos
	invoke WriteConsoleA, out_handler, Addr input_string, input_string_size, Addr symbols_count, 0
	
	; ��������� ������� ������� �� (0,1) � ����� ��������� "Hello ���"
	mov cord.x, 0
	mov cord.y, 1
	invoke SetConsoleCursorPosition, out_handler, pos
	invoke WriteConsoleA, out_handler, Addr hello_world_message, hello_world_message_size, Addr symbols_count, 0
	
	; ��������� ������� ������� �� (0,7) � ����� ������� inkey
	mov cord.x, 0
	mov cord.y, 7
	invoke SetConsoleCursorPosition, out_handler, pos
	inkey "������� ����� ������� ��� �����������..."
	
	ret
_main ENDP
end _main
