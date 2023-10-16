import copy
import typing

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
def count_symbols(s: str) -> typing.Dict[str, int]:
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
def str_even_odd(s: str) -> typing.Tuple[str, str]:
    return (s[::2], s[1::2])


# 8. Напишите скрипт, который удаляет задаваемый произвольный символ в строке.
def str_remove(s: str, index: int) -> str:
    if not 0 <= index < len(s):
        return s
    return s[:index] + s[index + 1 :]


# 9. Напишите скрипт, который позволяет переводить все символы
# исходной строки в верхний и нижний регистры.
def str_to_lower_upper(s: str) -> typing.Tuple[str, str]:
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
def str_most_popular_symbol(s: str) -> str:
    symbols = count_symbols(s)
    return max(symbols, key=symbols.get)  # pyright: ignore [reportGeneralTypeIssues]


Number = typing.Union[int, float]
NumberList = typing.List[Number]


# 14. Вычислите сумму элементов (чисел) в списке двумя разными способами.
def list_sum_1(num_list: list) -> Number:
    return sum(num_list)


def list_sum_2(num_list: list) -> Number:
    s = 0
    for n in num_list:
        s += n
    return s


# 15. Умножьте каждый элемент списка на произвольное число.
def list_multiply(num_list: NumberList, num: int) -> NumberList:
    return list(map(lambda n: n * num, num_list))


# 16. Найдите максимальное и минимальное числа, хранящиеся в списке.
def list_min_max(num_list: NumberList) -> typing.Tuple[Number, Number]:
    return (min(num_list), max(num_list))


# 17. Напишите скрипт, удаляющий все повторяющиеся элементы из списка.
def list_distinct(num_list: NumberList) -> NumberList:
    return list(set(num_list))


# 18. Скопируйте список двумя различными способами.
def list_copy_1(lst: typing.List) -> typing.List:
    return copy.deepcopy(lst)


def list_copy_2(lst: typing.List) -> typing.List:
    result = []

    for e in lst:
        if isinstance(e, typing.List):
            result.append(list_copy_2(e))
        else:
            result.append(e)

    return result


# 19. Напишите скрипт для слияния (конкатенации) двух
# списков различными способами.
def list_concat_1(list_a: typing.List, list_b: typing.List) -> typing.List:
    result = copy.deepcopy(list_a)
    result.extend(copy.deepcopy(list_b))
    return result


def list_concat_2(list_a: typing.List, list_b: typing.List) -> typing.List:
    list_a = copy.deepcopy(list_a)
    list_b = copy.deepcopy(list_b)
    result = []

    for e in list_a:
        result.append(e)

    for e in list_b:
        result.append((e))

    return result


# 20. Напишите скрипт, меняющий позициями элементы списка с индексами n и n + 1.
def list_replace(lst: typing.List, n: int) -> None:
    if n >= len(lst) - 1:
        raise Exception("n must be less than len(lst) - 1")

    temp = lst[n]
    lst[n] = lst[n + 1]
    lst[n + 1] = temp


# 21. Напишите скрипт, переводящий список из различного количества
# числовых целочисленных элементов в одно число.
# Пример списка: [15, 23, 150], результат: 1523150
def list_join(num_list: typing.List[int]) -> int:
    str_list = map(str, num_list)
    s = "".join(str_list)
    return int(s)


# 22. Объявите и инициализируйте словарь различными способами.
def dictionary_init() -> None:
    dict_a = {}
    dict_b = dict[int, str]()


# 23. Добавьте еще несколько пар «ключ: значение»
# в следующий словарь: {0: 10, 1: 20}.
def dict_add_script() -> None:
    starting_dict = {0: 10, 1: 20}

    starting_dict[3] = 53
    starting_dict[45] = 2
    starting_dict[10] = 10

    print(starting_dict)


# 24. Напишите скрипт, который из трех словарей создаст один новый.
def dict_concat(
    dict_a: typing.Dict, dict_b: typing.Dict, dict_c: typing.Dict
) -> typing.Dict:
    result = copy.deepcopy(dict_a)
    result.update(dict_b)
    result.update(dict_c)
    return result


# 25. Напишите скрипт, проверяющий, существует ли заданный ключ в словаре.
def dict_contains_key(dct: typing.Dict, key: typing.Any) -> bool:
    return key in dct


# 26. Напишите скрипт для удаления элемента словаря.
def dict_remove_key(dct: typing.Dict, key: typing.Any) -> None:
    dct.pop(key)


# 27. Напишите скрипт, который выводит максимальное и минимальное
# числа среди значений словаря.
def dict_min_max(dct: typing.Dict[typing.Any, Number]) -> typing.Tuple:
    min_res = min(dct, key=dct.get)  # pyright: ignore [reportGeneralTypeIssues]
    max_res = max(dct, key=dct.get)  # pyright: ignore [reportGeneralTypeIssues]
    return (min_res, max_res)


# 28. Объявите и инициализируйте кортеж различными способами, после чего распакуйте его.
def tuple_script() -> None:
    tuple_1 = (3, 5)

    tuple_2 = tuple([3, 5])

    print(tuple_1 == tuple_2)


# 29. Напишите скрипт для добавления элементов в кортеж.

# 30. Напишите скрипт, конвертирующий список в кортеж.

# 31. Конвертируйте кортеж в словарь.

# 32. Напишите скрипт, подсчитывающий количество элементов типа кортеж в списке.

# 33. Объявите и инициализируйте множество различными способами.

# 34. Добавьте элемент в множество.

# 35. Удалите элемент из множества.

# 36. Удалите повторяющиеся элементы из списка.

# 37. Напишите скрипт для объединения двух множеств.

# 38. Напишите скрипт, находящий длину множества двумя различными способами.

# 39. Напишите скрипт для проверки, входит ли элемент в множество.

# 40. Напишите скрипт для записи текста в файл.

# 41. Напишите скрипт для чтения текста из файла.

# 42. Напишите скрипт для добавления текста в файл и отображения содержимого файла.

# 43. Напишите скрипт для чтения последних n строк файла.

# 44. Напишите скрипт, подсчитывающий количество строк в файле.

# 45. Напишите скрипт, позволяющий найти самое встречаемое слово в файле.

# 46. Напишите скрипт, копирующий содержимое одного файла в другой.

# 47. Запишите словарь в файл посредством модуля pickle и прочитайте его.

# 48. Запишите список в файл посредством модуля pickle и прочитайте его.

# 49. Запишите словарь в файл посредством модуля json и прочитайте его.


if __name__ == "__main__":
    tuple_script()
