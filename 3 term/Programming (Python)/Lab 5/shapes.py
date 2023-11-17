# 8. Напишите несколько производных классов от базового класса геометрических
# фигур (например: прямоугольник и квадрат).
import math
from typing import override

from interfaces import ShapeBase


class Rectangle(ShapeBase):
    __side_a: float
    __side_b: float

    def __init__(self, a: float, b: float) -> None:
        super().__init__()
        self.__side_a = a
        self.__side_b = b

    @override
    def area(self) -> float:
        return self.__side_a * self.__side_b

    @override
    def perimeter(self) -> float:
        return 2 * (self.__side_a + self.__side_b)


class Square(ShapeBase):
    __side: float

    def __init__(self, side: float) -> None:
        super().__init__()
        self.__side = side

    @override
    def area(self) -> float:
        return self.__side * self.__side

    @override
    def perimeter(self) -> float:
        return 4 * self.__side


class Circle(ShapeBase):
    __radius: float

    def __init__(self, radius: float) -> None:
        super().__init__()
        self.__radius = radius

    @override
    def area(self) -> float:
        return self.__radius * self.__radius * math.pi

    @override
    def perimeter(self) -> float:
        return self.__radius * 2 * math.pi
