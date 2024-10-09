from collections.abc import Callable


def check(func: Callable):
    def checked(pair):
        if pair.a == 0 or pair.b == 0:
            raise ValueError("a or b was 0")
        return func(pair)
    return checked

def safe_operation(func: Callable):
    def safe_op(safe_pair):
        try:
            return func(safe_pair)
        except ValueError:
            a = safe_pair.pair.a
            a = a if a != 0 else 1

            b = safe_pair.pair.b
            b = b if b != 0 else 1

            new_safe_pair = SafePair(Pair(a, b))
            return func(new_safe_pair)
    
    return safe_op

# Напишите класс, реализующий все арифметические операции над двумя
# значениями (a и b). В случае, если одно из значений при вызове операции равно
# нулю, генерируется исключение.
class Pair:
    __a: float
    __b: float

    def __init__(self, a: float, b: float) -> None:
        self.__a = a
        self.__b = b

    @property
    def a(self):
        return self.__a

    @property
    def b(self):
        return self.__b

    @check
    def add(self):
        return self.__a + self.__b

    @check
    def sub(self):
        return self.__a - self.__b

    @check
    def mul(self):
        return self.__a * self.__b

    @check
    def div(self):
        return self.__a / self.__b

# Напишите класс, реализующий такие арифметические действия, как деление и
# умножение. Если одно из значений при вызове операции равно нулю, генерируется
# исключение, значение ноль меняется на 1 и вычисление операции продолжается.
class SafePair:
    __pair: Pair

    def __init__(self, pair):
        self.__pair = pair

    @property
    def pair(self):
        return self.__pair

    @safe_operation
    def mul(self):
        return self.__pair.mul()

    @safe_operation
    def div(self):
        return self.__pair.div()
            
