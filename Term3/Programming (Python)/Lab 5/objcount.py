# 6. Напишите класс, который подсчитывает текущее количество его экземпляров в
# приложении. Для корректного отображения этого числа перегрузите у класса метод
# __del__ и напишите необходимую логику.
class Counter:
    __count: int = 0
    def __init__(self) -> None:
        Counter.__count += 1

    def __del__(self) -> None:
        global _count
        Counter.__count -= 1

    @staticmethod
    def count() -> int:
        return Counter.__count

