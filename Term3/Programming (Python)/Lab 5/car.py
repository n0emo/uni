from enum import Enum


# 3. Напишите класс, описывающий такой объект, как автомобиль. Продумайте, какие
# методы и переменные он должен иметь.
class Car:
    __speed: int
    __max_speed: int

    def __init__(self, max_speed):
        self.__max_speed = max_speed

    @property
    def speed(self):
        return self.__speed

    @property 
    def max_speed(self):
        return self.__max_speed

    def ride(self):
        self.__speed = self.__max_speed
        print("Поехали!")

    def stop(self):
        self.__speed = 0
        print("Остановились!")

# 5. Напишите класс, описывающий такой объект, как автомобиль. У него может быть
# различное количество состояний, реализуемых посредством перечислений.
# Добавьте методы, позволяющие экземпляру класса менять свое текущее состояние
# (например: остановка, движение, поворот налево и т. д.).
class CarState(Enum):
    STOPPED = 0
    RIDES = 1
    TURNS_LEFT = 2
    TURNS_RIGHT = 3
    
class CarWithState:
    __state: CarState
    __name: str

    def __init__(self, name: str) -> None:
        self.__state = CarState.STOPPED
        self.__name = name

    def display_state(self):
        state_str: str
        match self.__state:
            case CarState.STOPPED:
                state_str = "остановлена"
            case CarState.RIDES:
                state_str = "едет"
            case CarState.TURNS_LEFT:
                state_str = "поворачивает налево"
            case CarState.TURNS_RIGHT:
                state_str = "поворачивает направо"
            case _:
                raise Exception("self.__state was unknown.")

        print(f'Машина "{self.__name}" {state_str}')


    def ride(self):
        if self.__state == CarState.STOPPED:
            self.__state = CarState.RIDES

    def stop(self):
        self.__state = CarState.STOPPED

    def turn_left(self):
        if self.__state == CarState.RIDES or self.__state == CarState.TURNS_RIGHT:
            self.__state = CarState.TURNS_LEFT

    def turn_right(self):
        if self.__state == CarState.RIDES or self.__state == CarState.TURNS_LEFT:
            self.__state = CarState.TURNS_RIGHT

