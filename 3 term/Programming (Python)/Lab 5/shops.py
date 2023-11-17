# 10. Напишите несколько производных классов от базового класса магазинов
# (например: ларек и супермаркет).

from typing import Dict, Set, override

from interfaces import ShopBase, ShopItem


class Stall(ShopBase):
    __item_type: str
    __amount: int
    __price: int
    __margin: int

    def __init__(self, item_type: str, amount: int, price: int) -> None:
        super().__init__()

        self.__item_type = item_type
        self.__amount = amount
        self.__margin = 0
        self.__price = price

    @property
    @override
    def items(self) -> dict:
        return {
            self.__item_type: ShopItem(self.__item_type, self.__amount, self.__price)
        }

    @property
    @override
    def margin(self) -> int:
        return self.__margin

    def sell(self, amount: int) -> None:
        if amount > self.__amount:
            print("Cannot sell that much.")
            return

        self.__amount -= amount
        sold_margin = amount * self.__price
        self.__margin += sold_margin
        print(f"Successfully sold {amount} of {self.__item_type} for {sold_margin}$")

    def restock(self, amount: int) -> None:
        self.__amount += amount


class Supermarket(ShopBase):
    __items: Dict[str, ShopItem]
    __margin: int

    def __init__(self, items: Dict[str, ShopItem]) -> None:
        super().__init__()
        self.__items = items

    @property
    @override
    def items(self) -> Dict[str, ShopItem]:
        return self.__items

    @property
    @override
    def margin(self) -> int:
        return self.__margin

    def sell(self, name: str, amount: int) -> None:
        if name not in self.__items:
            raise ValueError(f"Supermarket does not contain item with name '{name}'")

        item = self.__items[name]
        if amount > item.amount:
            raise ValueError(f"Supermarket cannot sold {amount} of {name}. ({item.amount} in stock).")

        item.amount -= amount
        margin = amount * item.price
        self.__margin += margin
        print(f"Successfully sold {amount} of {name} for {margin}$.")

    def restock(self, name: str, amount: int) -> None:
        if name not in self.__items:
            raise ValueError(f"Supermarket does not contain item with name '{name}'")

        self.__items[name].amount += amount

