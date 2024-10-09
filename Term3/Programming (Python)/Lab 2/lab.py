# pylint: skip-file

from functools import partial, reduce
from typing import Any, Callable, List

# 1. Выведите все символы из строки «Данная часть была посвящена больше синтаксису
# python и вопросам документации кода», значения индексов которых делятся на 2.


def task_1(s: str) -> str:
    return s[::2]


# 2. Выведите все символы из строки «Данная часть была посвящена больше синтаксису
# Python и вопросам документации кода», значения индексов которых без остатка делятся
# на 3, но не делятся на 4.
def task_2(s: str) -> str:
    result = [s[i] if i % 3 == 0 and i % 4 != 0 else "" for i in range(len(s))]
    result = "".join(result)
    return result


# 3. Выведите все символы из строки «Данная часть была посвящена больше синтаксису
# Python и вопросам документации кода», значения индексов которых при делении на 6 дают
# остаток 2, 4, и 5.
def task_3(s: str) -> str:
    result = [s[i] if i % 6 in [2, 4, 5] else "" for i in range(len(s))]
    result = "".join(result)
    return result


# 4. Выведите числа из диапазона от 1 до 10, используя цикл for и while.
def task_4_for(count: int) -> None:
    for i in range(1, count + 1):
        print(f"{i} ", end="")
    print()


def task_4_while(count: int) -> None:
    counter = 1
    while counter <= count:
        print(f"{counter} ", end="")
        counter += 1
    print()


# 5. Выведите числа из диапазона от –20 до 20 с шагом 3, используя цикл for и while.
def task_5_for(start: int, end: int, step: int) -> None:
    for i in range(start, end + 1, step):
        print(f"{i} ", end="")
    print()


def task_5_while(start: int, end: int, step: int) -> None:
    counter = start
    while counter <= end:
        print(f"{counter} ", end="")
        counter += step
    print()


# 6. Посчитайте количество вхождений элемента со значением «3» в следующем списке:
# [3, 0, 1, 3, 0, 4, 3, 3, 4, 56, 6, 1, 3], используя цикл for, while и метод count.
def task_6_for(lst: list, elem: Any) -> int:
    count = 0
    for e in lst:
        count += 1 if e == elem else 0
    return count


def task_6_while(lst: list, elem: Any) -> int:
    count = 0
    counter = len(lst)
    while counter:
        counter -= 1
        if lst[counter] == elem:
            count += 1
    return count


def task_6_count(lst: list, elem: Any) -> int:
    return lst.count(elem)


# 7. Сформируйте список из элементов строки «список доступных атрибутов»,
# используя механизм списковых включений и цикл  for.
def task_7_comp(s: str) -> list:
    return [c for c in s]


def task_7_for(s: str) -> list:
    result = []
    for c in s:
        result.append(c)
    return result


# 8. Сформируйте единичную матрицу N × N, используя механизм списковых включений.
def task_8(size: int) -> List[List]:
    return [[int(col == row) for col in range(size)] for row in range(size)]


# 9. Напишите программу, выводящую элементы списка [3, 0, 1, 3, 0, 4, 3, 3, 4, 56, 6, 1, 3]
# в обратной последовательности.
def task_9(lst: list) -> list:
    return lst[::-1]


# 10. Напишите программу, которая выводит числе в диапазоне от 1 до 9, кроме 5 и 7.
def task_10(start: int, end: int, exclude: List[int]) -> None:
    numbers = [i for i in range(start, end + 1) if i not in exclude]
    strs = map(str, numbers)
    print(", ".join(strs))


# 11. Напишите программу, выводящую сумму элементов списка [3, 0, 1, 3, 0, 4, 3, 3, 4, 56, 6, 1, 3],
# используя цикл for, while и метод sum.
def task_11_for(lst: list[float]) -> float:
    res = 0
    for n in lst:
        res += n
    return res


def task_11_while(lst: list[float]) -> float:
    res = 0
    counter = len(lst) - 1
    while counter >= 0:
        res += lst[counter]
        counter -= 1
    return res


task_11_sum = sum


# 12. Напишите программу, выводящую сумму элементов списка [3, 0, 1, 3, 0, 4, 3, 3, 4, 56, 6, 1, 3],
# значения индексов которых делятся на без остатка на 3, используя цикл for и while.
def compose2(f, g):
    return lambda *args, **kwargs: f(g(*args, *kwargs))


def compose(*functions):
    return reduce(compose2, functions)


task_12 = compose(sum, partial(filter, lambda n: n % 3 == 0))


# 13. Сформируйте список, значения элементов которого находятся в диапазоне от 23 до 35.
def task_13(start: int, end: int) -> list[int]:
    return list(range(start, end + 1))


# 14. Сформируйте список, значения элементов которого находятся в диапазоне от 3 до 15
# с шагом 4.
def task_14(start: int, end: int, step: int) -> list[int]:
    return list(range(start, end + 1, step))


# 15. Сформируйте список, значения элементов которого находятся в диапазоне от 3 до 25 и
# без остатка делятся на 3.
def task_15(start: int, end: int, predicate: Callable[[int], bool]) -> list[int]:
    return list(filter(predicate, range(start, end + 1)))


# 16. Сформируйте словарь из двух списков  [3, 0, 1, 3, 0, 4, 3, 3, 4, 56, 6, 1, 3] и
# [2, 4, 7, 26, 33], используя встроенную функцию zip. Выведите словарь
# в консоль и объясните, почему он получился такого вида.
task_16 = compose(dict, zip)

# 17. Выведите различными способами в консоль элементы списка
# [3, 0, 1, 3, 0, 4, 3, 3, 4, 56, 6, 1, 3] с их индексами.
task_17 = compose(
    print,
    "\n".join,
    partial(map, (lambda i_n: f"{i_n[0]+1}: {i_n[1]}")),  # type: ignore
    enumerate,
)


# 18. Напишите программу, которая считывает целое число (месяц), после чего выводит
# сезон к которому этот месяц относится.
def task_18(month: int) -> str:
    match month:
        case 1 | 2 | 12:
            return "Winter"
        case 3 | 4 | 5:
            return "Spring"
        case 6 | 7 | 8:
            return "Summer"
        case 9 | 10 | 11:
            return "Autumn"
        case _:
            return "Unknown"


# 19. Напишите программу, выводящую среднее из трех значений.
def task_19(numbers: list[float]):
    numbers_len = len(numbers)
    match numbers:
        case []:
            return None
        case [n]:
            return n
        case [a, b]:
            return (a + b) / 2
        case _ if numbers_len % 2 == 1:
            return sorted(numbers)[numbers_len // 2]
        case _ if numbers_len % 2 == 0:
            second_index = len(numbers) // 2
            first_index = second_index - 1
            numbers = sorted(numbers)
            return (numbers[first_index] + numbers[second_index]) / 2


# 20. Напишите программу, выводящую таблицу умножения для задаваемого пользователем
# числа от 1 до 9 (включительно).
def task_20(num: int) -> None:
    strs = map(lambda i: f"{num} * {i} = {num * i}", range(1, 10))
    print("\n".join(strs))
