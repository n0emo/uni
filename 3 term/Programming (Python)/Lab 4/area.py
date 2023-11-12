# 4. Напишите модуль, содержащий функции, которые выполняют следующие
# операции: подсчет площади круга, прямоугольника и треугольника.

import math

def area_of_circle(radius: float) -> float:
    return math.pi * radius * radius

def area_of_rectangle(side_a: float, side_b: float) -> float:
    return side_a * side_b

def area_of_triangle(side_a: float, side_b: float, side_c: float) -> float:
    halfperim = (side_a + side_b + side_c) / 2
    area = math.sqrt(
        halfperim * (halfperim - side_a) * (halfperim - side_b) * (halfperim - side_c)
    )

    return area

