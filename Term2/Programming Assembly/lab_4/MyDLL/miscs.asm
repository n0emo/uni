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
	enter_element_msg db "������� ������� [%d]: ", 0
	num_fmt db "%d", 0
	out_num_fmt db "%d ", 0
	newline db 13, 10, 0

.code
get_arr_from_console proc, arr: dword, arr_size: dword
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