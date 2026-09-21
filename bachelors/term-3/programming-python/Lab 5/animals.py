# 11. Напишите несколько производных классов от базового класса автомобилей
# (например: лошадь и тигр).

from typing import override
from interfaces import AnimalBase


class Horse(AnimalBase):
    def __init__(self) -> None:
        super().__init__()

    @override
    def feed(self, food: str, amount: int) -> None:
        match food.strip().lower():
            case "apple" | "apples":
                print(f"Horse just ate {amount} amount of {food}.")
            case _:
                print(f"Horse refused to eat {food}.")

    @override
    def make_sound(self):
        print("Neigh!!!")


class Tiger(AnimalBase):
    def __init__(self) -> None:
        super().__init__()

    @override
    def feed(self, food: str, amount: int) -> None:
        match food.strip().lower():
            case "pig" | "rabbit" | "gnu":
                print(f"Tiger just enjoed {amount} of {food}.")
            case "horse" | "lion":
                print(f"Tiger disliked {food}, but ate {amount} of.")
            case _:
                print(f"Tiger refused to eat {food}.")

    @override
    def make_sound(self) -> None:
        print("Roar!!!")

