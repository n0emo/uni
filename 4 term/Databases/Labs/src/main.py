import create
import db
from model import *
from tabulate import tabulate


def main() -> None:
    create.main()

    print(tabulate(db.natural_join()))
    return

    with db.get_connection() as conn:
        cur = conn.cursor()
        sql = """
            SELECT * FROM Materials
        """
        print("Таблица Sizes\n")
        print(
            tabulate(
                cur.execute(sql).fetchall(),
                headers=["ID", "Название", "Описание", "Цена", "Количество"],
            )
        )
    #
    #
    # print("Декартово произведение материалов и размеров:")
    # for row in db.cross_join_materials_sizes():
    #     print(row)

    return
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
        print(f"ID Размера: {book[0]}, Общая стоимость заказов: {book[1]}")
    print()

    print("Материалы, отсортированные по количеству на складе:\n")
    print("ID | Название           | Количество на складе")
    for material in db.get_materials_sorted_by_stock():
        s = f"{material[0]:2} | {material[1]:18} | {material[2]:5}"
        print("_" * 50)
        print(s)


if __name__ == "__main__":
    main()
