IFNDEF LIB_MISCS
LIB_MISCS equ 1

get_arr_from_console PROTO, arr: DWORD, arr_size: DWORD

sort_arr PROTO, arr: DWORD, arr_size: DWORD 

write_arr_to_console PROTO, arr: DWORD, arr_size:DWORD

console_init MACRO app, codepage
	invoke SetConsoleCP, codepage
	invoke SetConsoleOutputCP, codepage
	invoke SetConsoleTitle, app 
EndM

ENDIF