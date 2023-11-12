from typing import List
import itertools
from common import compose # pyright: ignore

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

