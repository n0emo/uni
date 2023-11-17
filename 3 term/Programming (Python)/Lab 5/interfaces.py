# 7. Напишите базовый класс, задающий интерфейс и часть характеристик (если надо)
# таких объектов, как геометрические фигуры, автомобиль и магазин, животное.

from abc import abstractmethod


class ShapeBase:
    @abstractmethod
    def area(self) -> float:
        ...

    @abstractmethod
    def perimeter(self) -> float:
        ...


class CarBase:
    @abstractmethod
    def drive(self) -> None:
        ...

    @abstractmethod
    def stop(self) -> None:
        ...

    @property
    @abstractmethod
    def name(self) -> str:
        ...


class ShopBase:
    @property
    @abstractmethod
    def items(self) -> dict:
        ...

    @property
    @abstractmethod
    def margin(self) -> int:
        ...


class ShopItem:
    name: str
    amount: int
    price: int

    def __init__(self, name: str, amount: int, price: int) -> None:
        self.name = name
        self.amount = amount
        self.price = price


class AnimalBase:
    @abstractmethod
    def feed(self, food: str, amount: int) -> None:
        ...

    @abstractmethod
    def make_sound(self) -> None:
        ...

