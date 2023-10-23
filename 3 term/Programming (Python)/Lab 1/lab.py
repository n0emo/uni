import copy
import json
import pickle
from functools import reduce
from typing import Any, Dict, List, Sequence, Tuple, TypeVar

T = TypeVar("T")

NumberList = Sequence[int | float]

# pylint: disable-all


# 1. Что будет результатом следующих выражений?
def code_result():
    print("agility"[2:5] + "taxonomy"[3:6])
    print([115, 202, 192, 334, 257][:4])
    print(len("crazy"[3 : 3 + 4]))
    print([9, 8, 7, 6, 5, 4, 3, 2, 1][-3:])
    print(type([False, True, False, True][2:3]))
    print("---".join("this is important".split()))
    print(int("".join("7/7/0/7".split("/"))))
    print("too soon to tell".replace("o", "*").replace("*", ""))


# 2. Напишите скрипт, вычисляющий двумя способами длину строки.
def str_len_1(s: str) -> int:
    return s.count("") - 1


def str_len_2(s: str) -> int:
    return len(s)


# 3. Напишите скрипт, который позволяет из строки собрать
# другую по следующим правилам: новая строка должна состоять
# из двух первых и двух последних элементов исходной строки.
# Если длина исходной строки меньше двух, то результатом будет
# пустая строка.
def new_str(s: str) -> str:
    if len(s) < 2:
        return ""
    return s[:2] + s[-2:]


# 4. Напишите скрипт, который заменяет произвольный символ/букву в строке на «$».
def str_replace_dollar(s: str, index: int) -> str:
    if not 0 <= index < len(s):
        return s
    return s[:index] + "$" + s[index + 1 :]


# 5. Напишите скрипт, который позволяет инвертировать
# последовательность элементов в строке.
def str_reverse(s: str) -> str:
    return s[::-1]


# 6. Напишите скрипт, который считает количество вхождений символа в строку.
# Например: «google.com» — {'o': 3, 'g': 2, '.': 1, 'e': 1, 'l': 1, 'm': 1, 'c': 1}
def count_symbols(s: str) -> Dict[str, int]:
    result = dict[str, int]()
    for c in s:
        if c in result:
            result[c] += 1
        else:
            result[c] = 1

    return dict(sorted(result.items(), key=lambda v: v[1], reverse=True))


# 7. Напишите скрипт, позволяющий из исходной строки собрать две новые.
# Первая строка должна состоять только из элементов с нечетными индексами
# исходной строки, а вторая — с четными.
def str_even_odd(s: str) -> Tuple[str, str]:
    return (s[::2], s[1::2])


# 8. Напишите скрипт, который удаляет задаваемый произвольный символ в строке.
def str_remove(s: str, index: int) -> str:
    if not 0 <= index < len(s):
        return s
    return s[:index] + s[index + 1 :]


# 9. Напишите скрипт, который позволяет переводить все символы
# исходной строки в верхний и нижний регистры.
def str_to_lower_upper(s: str) -> Tuple[str, str]:
    return (s.lower(), s.upper())


# 10. Напишите скрипт, выводящий все элементы строки с их номерами индексов.
def print_symbols(s: str) -> None:
    for index, char in enumerate(s):
        print(f"{index + 1}: {char}")


# 11. Напишите скрипт, проверяющий, содержится ли произвольный символ
# (элемент) или слово в строке.
def str_contains(s: str, c: str):
    return c in s


# 12. Выведите символ, который встречается в строке чаще, чем остальные.
def str_most_frequent_symbol(s: str) -> str:
    symbols = count_symbols(s)
    return max(symbols, key=symbols.get)  # pyright: ignore [reportGeneralTypeIssues]


# 13. Поменяйте регистр элементов строки.
def str_swap_case(s: str) -> str:
    return s.swapcase()


# 14. Вычислите сумму элементов (чисел) в списке двумя разными способами.
def list_sum_1(num_list: list) -> float:
    return sum(num_list)


def list_sum_2(num_list: list) -> float:
    return 0 if len(num_list) == 0 else reduce(lambda a, b: a + b, num_list)


# 15. Умножьте каждый элемент списка на произвольное число.
def list_multiply(num_list: NumberList, num: int) -> NumberList:
    return list(map(lambda n: n * num, num_list))


# 16. Найдите максимальное и минимальное числа, хранящиеся в списке.
def list_min_max(num_list: NumberList) -> Tuple[float, float]:
    return (min(num_list), max(num_list))


# 17. Напишите скрипт, удаляющий все повторяющиеся элементы из списка.
def list_distinct(num_list: NumberList) -> NumberList:
    return list(set(num_list))


# 18. Скопируйте список двумя различными способами.
def list_copy_1(lst: List) -> List:
    return copy.copy(lst)


def list_copy_2(lst: List) -> List:
    return [e for e in lst]


# 19. Напишите скрипт для слияния (конкатенации) двух
# списков различными способами.
def list_concat_1(list_a: List, list_b: List) -> List:
    result = copy.copy(list_a)
    result.extend(copy.copy(list_b))
    return result


def list_concat_2(list_a: List, list_b: List) -> List:
    result = []

    for e in list_a:
        result.append(e)

    for e in list_b:
        result.append((e))

    return result


# 20. Напишите скрипт, меняющий позициями элементы списка с индексами n и n + 1.
def list_replace(lst: List, n: int) -> None:
    if not 0 <= n < len(lst) - 1:
        raise Exception("n should be bigger than 0 and less than len(lst) - 1")

    temp = lst[n]
    lst[n] = lst[n + 1]
    lst[n + 1] = temp


# 21. Напишите скрипт, переводящий список из различного количества
# числовых целочисленных элементов в одно число.
# Пример списка: [15, 23, 150], результат: 1523150
def list_join(num_list: List[int]) -> int:
    str_list = map(str, num_list)
    s = "".join(str_list)
    return int(s)


# 22. Объявите и инициализируйте словарь различными способами.
def dictionary_init() -> None:
    dict_a = {"a": 1, "b": 2}

    dict_b = dict[int, str]()
    dict_b[3] = "c"
    dict_b[4] = "d"

    print(f"dict_a: {dict_a}")
    print(f"dict_b: {dict_b}")


# 23. Добавьте еще несколько пар «ключ: значение»
# в следующий словарь: {0: 10, 1: 20}.
def dict_add_script() -> None:
    starting_dict = {0: 10, 1: 20}

    starting_dict[3] = 53
    starting_dict[45] = 2
    starting_dict[10] = 10

    print(starting_dict)


# 24. Напишите скрипт, который из трех словарей создаст один новый.
def dict_concat(dict_a: Dict, dict_b: Dict, dict_c: Dict) -> Dict:
    result = copy.copy(dict_a)
    result.update(dict_b)
    result.update(dict_c)
    return result


# 25. Напишите скрипт, проверяющий, существует ли заданный ключ в словаре.
def dict_contains_key(dct: Dict, key: Any) -> bool:
    return key in dct


# 26. Напишите скрипт для удаления элемента словаря.
def dict_remove_key(dct: Dict, key: Any) -> None:
    dct.pop(key)


# 27. Напишите скрипт, который выводит максимальное и минимальное
# числа среди значений словаря.
def dict_min_max(dct: Dict[Any, float]) -> Tuple:
    min_res = min(dct, key=dct.get)  # pyright: ignore [reportGeneralTypeIssues]
    max_res = max(dct, key=dct.get)  # pyright: ignore [reportGeneralTypeIssues]
    return (min_res, max_res)


# 28. Объявите и инициализируйте кортеж различными способами, после чего распакуйте его.
def tuple_script() -> None:
    tuple_1 = (3, 5)
    tuple_2 = tuple([3, 5])

    print(tuple_1)
    print(tuple_2)


# 29. Напишите скрипт для добавления элементов в кортеж.
def tuple_add_element(tup: Tuple, elem: Any) -> Tuple:
    return (*tup, elem)


# 30. Напишите скрипт, конвертирующий список в кортеж.
def list_to_tuple(lst: list) -> Tuple:
    return tuple(lst)


# 31. Конвертируйте кортеж в словарь.
def tuple_to_dict(tup: Tuple[Tuple[T, Any], ...]) -> Dict[T, Any]:
    return dict(tup)


# 32. Напишите скрипт, подсчитывающий количество элементов типа кортеж в списке.
def count_tuples(lst: List) -> int:
    return sum(isinstance(e, tuple) for e in lst)


# 33. Объявите и инициализируйте множество различными способами.
def set_script() -> None:
    set1 = {2, 4, 8, 9, 6}
    print(type(set1))
    print(set1)

    set2 = set([8, 6, 3, 4, 0])
    print(type(set2))
    print(set2)


# 34. Добавьте элемент в множество.
def set_add(st: set, elem: Any) -> None:
    st.add(elem)


# 35. Удалите элемент из множества.
def set_remove(st: set, elem: Any) -> None:
    st.remove(elem)


# 36. Удалите повторяющиеся элементы из списка.
# see task 17


# 37. Напишите скрипт для объединения двух множеств.
def set_union(set1: set, set2: set) -> set:
    result = set()
    result.update(set1)
    result.update(set2)
    return result


# 38. Напишите скрипт, находящий длину множества двумя различными способами.
def set_count_1(st: set) -> int:
    return len(st)


def set_count_2(st: set) -> int:
    return st.__len__()


# 39. Напишите скрипт для проверки, входит ли элемент в множество.
def set_contains(st: set, elem: Any) -> bool:
    return elem in st


# 40. Напишите скрипт для записи текста в файл.
def file_write(file_name: str, text: str) -> None:
    with open(file_name, "w") as file:
        file.write(text)


# 41. Напишите скрипт для чтения текста из файла.
def file_read(file_name: str) -> str:
    result: str
    with open(file_name, "r") as file:
        result = file.read()
    return result


# 42. Напишите скрипт для добавления текста в файл и отображения содержимого файла.
def file_append_script() -> None:
    file_name = input("Enter file name: ")
    text = input("Enter text to append:\n")

    with open(file_name, "a") as file:
        print(text, end="\n", file=file)

    with open(file_name, "r") as file:
        all_content = file.read()
        print("The contents of a file:")
        print(all_content)


# 43. Напишите скрипт для чтения последних n строк файла.
def file_get_last_n_strings(file_name: str, n: int):
    result = list()
    with open(file_name, "r") as file:
        result = file.readlines()[-n:]
    return result


# 44. Напишите скрипт, подсчитывающий количество строк в файле.
def file_newline_count(file_name: str) -> int:
    result = None
    with open(file_name, "r") as file:
        text = file.read()
        result = text.count("\n")
    return result


# 45. Напишите скрипт, позволяющий найти самое встречаемое слово в файле.
def file_most_frequent_word(file_name: str) -> str:
    text = None
    with open(file_name, "r") as file:
        text = file.read()

    filter_str = ",.!?;:-'\""
    for c in filter_str:
        text = text.replace(c, "")
    text = text.lower()
    words = filter(lambda s: len(s) > 2, text.split(" "))
    word_counts = {}
    for word in words:
        if word in word_counts:
            word_counts[word] += 1
        else:
            word_counts[word] = 0

    return dict_min_max(word_counts)[1]


# 46. Напишите скрипт, копирующий содержимое одного файла в другой.
def file_copy(src: str, dest: str) -> None:
    content = None
    with open(src, "rb") as file:
        content = file.read()

    with open(dest, "wb") as file:
        file.write(content)


# 47. Запишите словарь в файл посредством модуля pickle и прочитайте его.
def object_write_to_file_and_return_contents(obj: object, file_name: str) -> object:
    with open(file_name, "wb") as file:
        pickle.dump(obj, file)

    content = None
    with open(file_name, "rb") as file:
        content = pickle.load(file)

    return content


# 48. Запишите список в файл посредством модуля pickle и прочитайте его.
# see task 47


# 49. Запишите словарь в файл посредством модуля json и прочитайте его.
def file_serialize_and_return_content(obj: object, file_name: str) -> str:
    with open(file_name, "w") as file:
        json.dump(obj, file)

    content = None
    with open(file_name, "r") as file:
        content = file.read()

    return content


if __name__ == "__main__":
    tuple_script()
