# Напишите функцию, возводящую строку в верхний регистр. Добавьте проверку на
# то, что на вход функции подается не пустая строка.
def str_upper(s: str) -> str:
    if not isinstance(s, str):
        raise ValueError("s must be str.")
    
    if s == "":
        raise ValueError("s must not be empty string.")

    return s.upper()

# Напишите функцию, проверяющую вхождение задаваемого элемента в список.
# Добавьте проверку на то, что список не пустой.
def in_list(lst: list, elem) -> bool:
    if not isinstance(lst, list):
        raise ValueError("lst must be List.")

    if len(lst) == 0:
        raise ValueError("lst must not be empty list.")

    return elem in lst
