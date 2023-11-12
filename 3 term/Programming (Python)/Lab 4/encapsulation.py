# 6. Напишите модуль, содержащий внутренние имена, значения которых можно
# получить через функции верхнего уровня модуля.

__secret__: str = "X452lu"

def get_secret() -> str:
    global __secret__
    return __secret__;

def set_secret(new: str) -> None:
    if not isinstance(new, str):
        raise ValueError("New secret must be 'str'");
    
    global __secret__
    __secret__ = new
