# 10. Напишите несколько производных классов от базового класса магазинов
# (например: ларек и супермаркет).

from typing import override

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
