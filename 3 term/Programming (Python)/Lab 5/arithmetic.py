from _typeshed import SupportsRichComparison
from collections.abc import Callable
from typing import List, Tuple
import itertools
from common import compose # pyright: ignore
import functools
import math
import cmath

# 1. Напишите класс, позволяющий сформировать все уникальные подмножества из
# списка целых чисел, например: [2, 4, 10, 1].
class SubSets:
    __list: List[int]

    def __init__(self, lst: List[int]) -> None:
        self.__list = lst

    def get_subsets(self) -> List[List[float]]:
        def compose_subset(comb):
            for e in zip(comb, self.__list):
                if e[0]: yield e[1]

        pair_lists = [[False, True]] * len(self.__list)
        return list(map(
            compose(list, compose_subset),
            itertools.product(*pair_lists)
        ))


# 2. Напишите класс, реализующий все арифметические операции над двумя
# значениями (a и b).
class Operations:
    __a: float
    __b: float

    def __init__(self, a: float, b: float) -> None:
        self.__a = a
        self.__b = b

    def add(self) -> float:
        return self.__a + self.__b

    def sub(self) -> float:
        return self.__a - self.__b

    def mul(self) -> float:
        return self.__a * self.__b

    def div(self) -> float:
        return self.__a / self.__b


# 4. Напишите класс, описывающий такой объект, как прямоугольник. Перегрузите у
# реализованного класса методы сравнения (сравнивать по площади), после чего
# создайте два экземпляра класса и проверьте, как работают перегруженные методы.
class Rectangle:
    __side_a: float
    __side_b: float

    def __init__(self, a: float, b: float) -> None:
        self.__side_a = a
        self.__side_b = b

    def area(self) -> float:
        return self.__side_a * self.__side_b

    def __eq__(self, other: "Rectangle") -> bool:
        return self.area() == other.area()

    def __ne__(self, other: "Rectangle") -> bool:
        return self.area() != other.area()

    def __gt__(self, other: "Rectangle") -> bool:
        return self.area() > other.area()

    def __ge__(self, other: "Rectangle") -> bool:
        return self.area() >= other.area()

    def __lt__(self, other: "Rectangle") -> bool:
        return self.area() < other.area()

    def __le__(self, other: "Rectangle") -> bool:
        return self.area() <= other.area()


# 13. Напишите класс, хранящий целое число. Перегрузите у него методы
# арифметических операций. Объявите два экземпляра класса и проверьте, как
# работают перегруженные методы.

class IntNum:
    __num: int

    def __init__(self, num) -> None:
        self.__num = num

    @property
    def value(self) -> int:
        return self.__num

    def __add__(self, other) -> "IntNum":
        return IntNum(self.__num + other.__num)

    def __sub__(self, other) -> "IntNum":
        return IntNum(self.__num - other.__num)

    def __mul__(self, other) -> "IntNum":
        return IntNum(self.__num * other.__num)

    def __floordiv__(self, other) -> "IntNum":
        return IntNum(self.__num // other.__num)


# 15. Напишите класс, который находит прямоугольник с максимальной площадью из
# списка.
class MaxBy[T, K: SupportsRichComparison]:
    __func: Callable[[T], K]
    def __init__(self, func: Callable[[T], K]) -> None:
        self.__func = func

    def get(self, lst: List[T]):
        return max(lst, key=self.__func)

    @staticmethod
    def rect_area() -> "MaxBy[Rectangle, float]":
        return MaxBy(lambda r : r.area())


# 16. Напишите класс, осуществляющий преобразование целого числа из десятичной
# системы счисления в двоичную и наоборот.
class NumSysConverter:
    ALPHABET = "0123456789ABCDEF"
    __num: int

    def __init__(self, repr: str, base: int) -> None:
        if base > len(NumSysConverter.ALPHABET):
            raise ValueError(f"Unsupported base '{base}'.")
        self.__num = NumSysConverter.get_num(repr, base)

    def convert_to(self, base: int) -> str:
        if base > len(NumSysConverter.ALPHABET):
            raise ValueError(f"Unsupported base '{base}'")

        repr = ""
        num = self.__num
        while num:
            repr += self.ALPHABET[num % base]
            num //= base

        return repr[::-1]

            
    @staticmethod
    @functools.lru_cache
    def get_digit(d: str):
        return NumSysConverter.ALPHABET.find(d)
    
    @staticmethod
    @functools.lru_cache
    def get_num(repr: str, base: int) -> int:
        exp = 1
        num = 0
        for d in repr[::-1]:
            num += NumSysConverter.get_digit(d) * exp
            exp *= base
        return num


# 17. Напишите класс, вычисляющий наименьший общий делитель (НОД). Значения,
# участвующие в поиске НОД должны устанавливаться отдельными методами или
# посредством декоратора @property до вызова метода расчета.
class GcdFinder:
    __a: int | None
    __b: int | None

    def __init__(self) -> None:
        self.__a = None
        self.__b = None

    @property
    def a(self) -> int | None:
        return self.__a

    @a.setter
    def a(self, value: int) -> None: 
        self.__a = value

    @property
    def b(self) -> int | None:
        return self.__b

    @b.setter
    def b(self, value: int) -> None: 
        self.__b = value

    def find(self):
        if self.__a == None or self.__b == None:
            raise ValueError(f"Must set a and b befor finding GCD")

        return math.gcd(self.__a, self.__b)


# 18. Напишите класс, вычисляющий корни квадратного уравнения.
class QuadraticEquation:
    __a: complex
    __b: complex
    __c: complex

    def __init__(self, a: complex, b: complex, c: complex) -> None:
        self.__a = a
        self.__b = b
        self.__c = c

    @property
    @functools.lru_cache
    def discriminant(self) -> complex:
        return cmath.sqrt(self.__b * self.__b - 4 * self.__a * self.__c)

    @property
    @functools.lru_cache
    def solve(self) -> Tuple[complex, complex]:
        return (
            (-self.__b - self.discriminant) / 2 * self.__a,
            (-self.__b + self.discriminant) / 2 * self.__a
        )

