# 9. Напишите несколько производных классов от базового класса автомобилей
# (например: легковой и грузовой автомобиль).

from typing import override

from interfaces import CarBase


class SportCar(CarBase):
    __name: str
    __wheels_need_replace: bool

    def __init__(self, name: str) -> None:
        super().__init__()

        self.__name = name
        self.__wheels_need_replace = False

    @override
    def drive(self) -> None:
        if self.__wheels_need_replace:
            print("Cannot move! Replace wheels.")
        else:
            self.__wheels_need_replace = True
            print("Need for speed!")

    @override
    def stop(self) -> None:
        print(f"Sportcar '{self.__name}' stopped! Why?")

    @property
    @override
    def name(self) -> str:
        return self.__name

    def replace_wheels(self) -> None:
        self.__wheels_need_replace = False
        print("Wheels successfully replaced!")


class AutoVaz(CarBase):
    __carriage: float
    __max_carriage: float

    def __init__(self, max_carriage) -> None:
        super().__init__()

        self.__carriage = 0.0
        self.__max_carriage = max_carriage

    @override
    def drive(self) -> None:
        print(f"AutoVaz {self.name} tronulsya...")

    @override
    def stop(self) -> None:
        print(f"AutoVaz {self.name} ostanovilsya...")

    @property
    @override
    def name(self) -> str:
        return "Lastochka"

    def load(self, amount: float) -> None:
        if self.__carriage + amount > self.__max_carriage:
            print(f"AutoVaz {self.name} cannot hold that much!")
        else:
            self.__carriage += amount
            print(f"AutoVaz {self.name} successfully loaded.")

    def unload(self) -> float:
        carriage = self.__carriage
        self.__carriage = 0
        print(f"AutoVaz {self.name} unloaded.")
        return carriage

    @property
    def carriage(self) -> float:
        return self.__carriage

