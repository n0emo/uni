import db
from model import *

if __name__ == "__main__":
    db.create_tables()

    customers = [
        Customer("Виталий", "Петров", "ул. Пушкина, д. 22", "88005553535"),
        Customer("Андрей", "Штефанов", "ул. Привокзальная, д. 12", "89811213123"),
        Customer("Родион", "Базаров", "пр. Меньшевиков, д. 143", "89814744747"),
        Customer("Светлана", "Владимирова", "ул. Крутая, д. 121", "88001239098"),
        Customer("Мёске", "Кобарёв", "ул. Японская, д. 211", "88005758495"),
        Customer("Аристарх", "Попов", "пр. Энергетиков, д. 32", "88005767384"),
    ]

    materials = [
        Material("Крокодил", "Зелёная крокодилья кожа", 120, 24.6),
        Material("Кожа", "Обычная коричневая кожа", 60, 36.1),
        Material("Картон", "Печатный картон средней плотности", 23, 67),
        Material("Пластик", "Эксперементальный прочный пластик", 100, 3.4),
    ]

    book_orders = [
        BookOrder(3, 3500, 12, "Большой", 1, "2024-01-06 12:40:21"),
        BookOrder(1, 1400, 4, "Маленький", 2, "2024-01-08 16:12:55"),
        BookOrder(4, 8000, 120, "Большой", 2, "2024-01-09 13:00:43"),
        BookOrder(6, 6700, 18, "Средний", 4, "2024-01-09 13:43:26"),
    ]

    painting_orders = [
        PaintingOrder(4, 1500, 240, 127, "2024-01-09 13:00:43"),
        PaintingOrder(2, 1800, 220, 140, "2024-01-10 13:12:31"),
        PaintingOrder(5, 1000, 160, 100, "2024-01-10 14:40:61"),
    ]

    for customer in customers:
        db.add_customer(customer)

    for material in materials:
        db.add_material(material)

    for order in book_orders:
        db.add_book_order(order)

    for order in painting_orders:
        db.add_painting_order(order)
