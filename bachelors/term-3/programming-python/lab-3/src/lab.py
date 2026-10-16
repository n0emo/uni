from collections.abc import Callable, Iterable
from functools import partial, reduce
from typing import OrderedDict


def compose2(f, g):
    return lambda *a, **kw: f(g(*a, **kw))


def compose(*functions):
    return reduce(compose2, functions)


# 1. Напишите функцию, вычисляющую максимальное из трех чисел.
max_num = max


# 2. Напишите функцию, которая возвращает сумму элементов списка.
sum_nums = sum


# 3. Напишите функцию, которая возвращает произведение элементов списка.
def product2(a: float, b: float) -> float: return a * b

product = partial(reduce, product2) 


# 4. Напишите функцию, которая возвращает инвертированную строку, подаваемую
# ей на вход.
def str_reverse(s: str) -> str:
    return s[::-1]


# 5. Напишите функцию для вычисления факториала задаваемого числа.
factorial = compose(
    product, 
    partial(range, 1),
    lambda n: n + 1 if n > 0 else 2, 
)


# 6. Напишите функцию, которая проверяет, входит ли задаваемое значение
# в определенный диапазон или нет.
def in_range(num: float, start: float, end: float) -> bool:
    return start <= num <= end


# 7. Напишите функцию, которая подсчитывает количество элементов в нижнем
# и верхнем регистрах у входной строки.
count_letters = compose(
    sum,
    lambda s: (1 if c.islower() or c.isupper() else 0 for c in s)
)


# 8. Напишите функцию, удаляющую повторяющиеся элементы в списке.
distinct = compose(list, OrderedDict.fromkeys)


# 9. Напишите функцию, выводящую элементы списка с четным индексом.
def even_indices(iterable: list) -> list:
    return iterable[::2]


# 10. Напишите функцию, которая проверяет, является ли строка палиндромом (читается
# одинаково как слева направо, так и наоборот).
def is_palindrome(a: str) -> bool:
    return a == a[::-1]


# 11. Напишите декоратор, обертывающий возвращаемое строковое значение функции
# в тег "<b> </b>".
def wrap_in_b_tag(func: Callable) -> Callable:
    return lambda s: f"<b>{func(s)}</b>"


# 12. Декорируйте функцию из первого упражнения таким образом, чтобы возвращаемое
# ей значение возводилось в квадрат.
def square_dec(func: Callable) -> Callable:
    return compose(lambda n: n * n, func)


# 13. Декорируйте функцию из четвертого упражнения таким образом, чтобы
# возвращалась строка в верхнем регистре.
def upper(func: Callable) -> Callable:
    return lambda s: func(s).upper()


# 14. Напишите декоратор, выводящий значения аргументов, подаваемых на вход
# декорируемой функции.
def log_args(func: Callable) -> Callable:
    def logged(*args, **kwargs):
        print("Arguments:", args)
        print("Keyword arguments:", kwargs)
        return func(*args, **kwargs)

    return logged


# 15. Напишите генераторную функцию, позволяющую проводить итерацию
# по значениям в диапазоне от 23 до 37.
def grange(start: int, end: int) -> Iterable:
    for i in range(start, end + 1):
        yield i


# 16. Напишите генераторную функцию, позволяющую проводить итерацию
# по значениям в диапазоне от 5 до 37 с шагом 4.
def grange_step(start: int, end: int, step: int) -> Iterable:
    for i in range(start, end + 1, step):
        yield i


# 17. Напишите генераторное выражение, позволяющее итерироваться
# по последовательности чисел от 0 до 15.
# see 15, 16 or 18


# 18. Напишите генераторное выражение, позволяющее итерироваться элементам списка
# [3, 0, 1, 3, 0, 4, 3, 3, 4, 56, 6, 1, 3] возводя их при этом в квадрат.
def square(lst: list) -> Iterable:
    for n in lst:
        yield n * n


# 19. Напишите генераторную функцию, позволяющую проводить итерацию
# по значениям в диапазоне от 0 до 100 с шагом, регулируемым в процессе
# ее работы.
def grange_func(start: int, end: int, step_f: Callable) -> Iterable:
    def get_steps():
        step_sum = 0
        index = 0
        while True:
            step = step_f(index)
            step_sum += step
            if step_sum <= end - start:
                yield step
            else:
                break
            index += 1

    current = start
    for step in get_steps():
        yield current
        current += step


# 20. Сформируйте список, используя для этого реализованные ранее генераторные
# функции из упражнений 15 и 16.
# see tests
