# 5. Напишите модуль, содержащий функции, которые выполняют следующие
# операции: подсчет количества элементов в словаре, проверку на наличие ключа в
# словаре.

def dict_len(dct: dict) -> int:
    return len(dct)

def key_in(dct: dict, key) -> bool:
    return key in dct.keys()
