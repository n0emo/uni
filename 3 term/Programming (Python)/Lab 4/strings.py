# 3. Напишите модуль, содержащий функции, которые выполняют следующие
# операции: проверку, является ли строка палиндромом, подсчет длины строки,
# перевод всех символов в нижний регистр.

def is_palindrome(s: str) -> bool:
    return s == s[::-1]

def str_len(s: str) -> int:
    return len(s)

def str_lower(s: str) -> str:
    return s.lower()
