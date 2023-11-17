from io import StringIO
import json
from typing import Any, Dict, List, Set
json

# 14. Напишите класс, который позволяет работать с json-файлом, осуществляя его
# чтение, запись, добавление, удаление и изменение значений.
class JsonFile:
    __path: str

    def __init__(self, path: str) -> None:
        self.__path = path

    def write(self, obj) -> None:
        with open(self.__path, 'w') as file:
            json.dump(obj, file)

    def read(self) -> object:
        with open(self.__path, 'r') as file:
            return json.load(file)


# 19. Напишите класс, хранящий данные сотрудника фирмы и имеющий метод,
# возвращающий характеристики текущего сотрудника в виде словаря.
class Employee:
    __name: str
    __salary: int
    __department: str

    def __init__(self, name: str, salary: int, department: str) -> None:
        self.__name = name
        self.__salary = salary
        self.__department = department

    @property
    def name(self) -> str:
        return self.__name

    @name.setter
    def name(self, value: str) -> None:
        self.__name = value

    @property
    def salary(self) -> int:
        return self.__salary

    @salary.setter
    def salary(self, value: int) -> None:
        self.__salary= value

    @property
    def department(self) -> str:
        return self.__department

    @department.setter
    def department(self, value: str) -> None:
        self.__department = value

    def to_dict(self) -> Dict[str, Any]:
        return {
            "name": self.__name,
            "salary": self.__salary,
            "department": self.__department
        }


# 20. Напишите класс, представляющий собой записную книжку. Каждый элемент
# записной книжки должен содержать следующие поля: ФИО, номер телефона, e-
# mail, день рождения. Записная книжка может сохраняться на диск в виде json-
# файла, а также должна иметь метод загрузки данных из файла.
class NotebookItem:
    __name: str
    __phone: str
    __email: str
    __birthday: str

    def __init__(self, name: str, phone: str, email: str, birthday: str) -> None:
        self.__name = name
        self.__phone = phone
        self.__email = email
        self.__birthday = birthday

    @property
    def name(self) -> str:
        return self.__name

    @name.setter
    def name(self, value: str) -> None:
        self.__name = value

    @property
    def phone(self) -> str:
        return self.__phone

    @phone.setter
    def phone(self, value: str) -> None:
        self.__phone = value

    @property
    def email(self) -> str:
        return self.__email

    @email.setter
    def email(self, value: str) -> None:
        self.__email = value

    @property
    def birthday(self) -> str:
        return self.__birthday

    @birthday.setter
    def birthday(self, value: str) -> None:
        self.__birthday = value


class Notebook:
    __set: Set[NotebookItem]

    def __init__(self, lst: Set[NotebookItem]) -> None:
        self.__set = lst

    def add(self, item: NotebookItem):
        self.__set.add(item)

    def remove(self, name: str) -> None:
        self.__set = set(i for i in self.__set if not i.name == name)

    def json(self):
        return json.dumps(self.__set)

    @staticmethod
    def from_json(json_s: str) -> "Notebook":
        return Notebook(set(
            NotebookItem(o["name"], o["phone"], o["email"], o["birthday"]) 
            for o in json.loads(json_s)
        ))

