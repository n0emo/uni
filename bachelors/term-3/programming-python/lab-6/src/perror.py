# Реализуйте собственный класс исключения, которое будет генерироваться каждый
# раз, когда в строке, которая является аргументом для функции, присутствует
# символ «п».
class RussianPError(Exception):
   def __init__(self, message: str) -> None:
      super().__init__(message) 


def str_lower(s: str):
    if 'п' in s:
        raise RussianPError("'п' must not be in s")

    return s.lower()

