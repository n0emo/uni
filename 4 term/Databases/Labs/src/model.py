import datetime as dt


class Customer:
    id: int | None
    name: str
    surname: str
    address: str
    phone: str

    def __init__(
        self,
        name: str,
        surname: str,
        address: str,
        phone: str,
        id: int | None = None,
    ) -> None:
        self.id = id
        self.name = name
        self.surname = surname
        self.address = address
        self.phone = phone

    @staticmethod
    def new_from_db(
        id: int,
        name: str,
        surname: str,
        address: str,
        phone: str,
    ):
        return Customer(name, surname, address, phone, id)

    def __str__(self) -> str:
        return str(self.__dict__)


class BookOrder:
    id: int | None
    customer_id: int
    datetime: str
    cost: float
    number_of_turns: int
    size: str
    materialId: int

    def __init__(
        self,
        customer_id: int,
        cost: float,
        number_of_turns: int,
        size: str,
        materialId: int,
        datetime: str | None = None,
        id: int | None = None,
    ) -> None:
        self.id = id
        self.customer_id = customer_id
        self.cost = cost
        self.number_of_turns = number_of_turns
        self.size = size
        self.materialId = materialId
        if datetime:
            self.datetime = datetime
        else:
            self.datetime = str(dt.datetime.now())

    def __str__(self) -> str:
        return str(self.__dict__)

    @staticmethod
    def new_frob_db(
        id: int,
        customer_id: int,
        cost: float,
        number_of_turns: int,
        size: str,
        materialId: int,
        datetime: str,
    ):
        return BookOrder(
            customer_id, cost, number_of_turns, size, materialId, datetime, id
        )


class PaintingOrder:
    id: int | None
    customer_id: int
    cost: float
    width: int
    height: int
    datetime: str

    def __init__(
        self,
        customer_id: int,
        cost: float,
        width: int,
        height: int,
        datetime: str | None = None,
        id: int | None = None,
    ) -> None:
        self.id = id
        self.customer_id = customer_id
        self.cost = cost
        self.width = width
        self.height = height
        if datetime:
            self.datetime = datetime
        else:
            self.datetime = str(dt.datetime.now())

    def __str__(self) -> str:
        return str(self.__dict__)


class Material:
    id: int | None
    name: str
    description: str
    price: float
    stock: float

    def __init__(
        self,
        name: str,
        description: str,
        price: float,
        stock: float,
        id: int | None = None,
    ) -> None:
        self.id = id
        self.name = name
        self.description = description
        self.price = price
        self.stock = stock

    @staticmethod
    def new_from_db(
        id: int,
        name: str,
        description: str,
        price: float,
        stock: float,
    ):
        return Material(name, description, price, stock, id)

    def __str__(self) -> str:
        return str(self.__dict__)
