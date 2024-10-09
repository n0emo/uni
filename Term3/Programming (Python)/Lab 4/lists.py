# 2. Напишите модуль, содержащий функции, которые выполняют следующие
# операции: проверка наличия элемента в списке, подсчет частоты вхождения
# элемента в список.


def in_list(lst: list, elem) -> bool:
    return elem in lst

def list_count(lst: list, elem) -> int:
    return lst.count(elem)
