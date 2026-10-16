# 12. Напишите класс, доступ к атрибутам (переменным) которого осуществляется с
# помощью декоратора @property.

class PropertyHolder:
    __a: int
    __b: str

    def __init__(self, a: int, b: str) -> None:
        self.__a = a
        self.__b = b

    @property
    def a(self) -> int:
        return self.__a

    @a.setter
    def a(self, value: int) -> None:
        if not isinstance(value, int):
            raise ValueError("'a' must be int.")

        self.__a = value

    @property
    def b(self) -> str:
        return self.__b

    @b.setter
    def b(self, value: str) -> None:
        if not isinstance(value, str):
            raise ValueError("'b' must be str.")

        self.__b = value

