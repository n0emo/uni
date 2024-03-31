from typing import Type, TypeVar

T = TypeVar('T', bound='DatabaseRecord')

class DatabaseRecord:
    id: int | None

    def __str__(self) -> str:
        return str(self.__dict__)

    def __init__(self, *args):
        cls = self.__class__
        assert len(args) == len(cls.__annotations__)
        self.id = None
        for (anot, arg) in zip(cls.__annotations__, args):
            self.__dict__[anot] = arg

    @classmethod
    def new_from_db(cls: Type[T], *args) -> T:
        obj = cls.__new__(cls)
        obj.__init__(*args[1:])
        obj.id = args[0] # type: ignore
        return obj

class Customer(DatabaseRecord):
    name: str
    surname: str
    address: str
    phone: str


class BookOrder(DatabaseRecord):
    customer_id: int
    datetime: str
    cost: float
    number_of_turns: int
    size_id: int
    material_id: int


class PaintingOrder(DatabaseRecord):
    customer_id: int
    cost: float
    width: int
    height: int
    datetime: str


class Material(DatabaseRecord):
    name: str
    description: str
    price: float
    stock: float


class Size(DatabaseRecord):
    name : str
