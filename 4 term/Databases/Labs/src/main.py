import os

import create
import db
from model import *

if __name__ == "__main__":
    # create.main()
    print(f"Количество клиентов: {db.count_customers()}\n")
    print(f"Сумма выручки с картин: {db.sum_painting_orders()}\n")
    print(f"Средняя цена фотокниги: {db.avg_book_cost()}\n")
    print(f"Максимальная цена заказанной картины {db.max_painting_cost()}\n")
    print(f"Минимальное количество разворотов: {db.min_book_number_of_turns()}\n")
    print(f"Самая ранняя книга: {db.earliest_book()}\n")

    prefix = "Владимир М"
    print(f"Клиенты, имя которых начинается на '{prefix}':")
    for customer in db.get_customers_with_prefix(prefix):
        print(customer)
    print()

    id = 2
    print(f"Размеры картины с ID заказа = {id}: {db.get_painting_dimensions(id)}\n")

    print("Цены на заказы книг, сгруппированные по ID материала:")
    for book in db.get_books_grouped_by_material_id():
        print(f"ID Материала: {book[0]}, общая стоимость: {book[1]}")
    print()

    cost = 25000
    print(f"Группы книг по размеру, где общая стоимость заказов больше {cost}:")
    for book in db.get_books_grouped_by_size_having_overall_cost_more_than(cost):
        print(book)
    print()

    print("Материалы, отсортированные по количеству на складе:")
    for material in db.get_materials_sorted_by_stock():
        print(material)
