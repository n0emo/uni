_count: int = 0


# 6. Напишите класс, который подсчитывает текущее количество его экземпляров в
# приложении. Для корректного отображения этого числа перегрузите у класса метод
# __del__ и напишите необходимую логику.
class Counter:
    def __init__(self) -> None:
        global _count
        _count += 1

    def __del__(self) -> None:
        global _count
        _count -= 1

    @property
    def count(self) -> int:
        global _count
        return _count
