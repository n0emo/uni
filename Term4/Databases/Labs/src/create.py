import db
from model import *


def main():
    db.delete_db()
    db.create_tables()

    customers = [
        Customer("Виталий", "Петров", "ул. Пушкина, д. 22", "88005553535"),
        Customer("Андрей", "Штефанов", "ул. Привокзальная, д. 12", "89811213123"),
        Customer("Родион", "Базаров", "пр. Меньшевиков, д. 143", "89814744747"),
        Customer("Светлана", "Владимирова", "ул. Крутая, д. 121", "88001239098"),
        Customer("Мёске", "Кобарёв", "ул. Японская, д. 211", "88005758495"),
        Customer("Аристарх", "Попов", "пр. Энергетиков, д. 32", "88005767384"),
        Customer("Владимир", "Моисеенко", "ул. Горького, д. 123", "98710654321"),
        Customer("Галина", "Рыбкина", "пр. Горбачёва, д. 333", "81249876543"),
        Customer("Иван", "Курчатов", "ул. Некрасовского, д. 120", "87819200312"),
        Customer("Сергей", "Нечаев", "ул. Горького, д. 56", "98710654321"),
        Customer("Александр", "Киселёв", "пр. Горбачёва, д. 14", "81249876543"),
        Customer("Анастасия", "Грицева", "ул. Строителей, д. 234", "81249876543"),
        Customer("Владимир", "Петров", "ул. Полесская, д. 100", "98710654321"),
        Customer("Марина", "Медведева", "ул. Гоголя, д. 333", "81249876543"),
    ]

    materials = [
        Material("Крокодил", "Зелёная крокодилья кожа", 120, 24.6),
        Material("Кожа", "Обычная коричневая кожа", 60, 36.1),
        Material("Картон", "Печатный картон средней плотности", 23, 67),
        Material("Пластик", "Эксперементальный прочный пластик", 100, 3.4),
        Material("Маленькая пчела", "Полосатая золотистая кожа", 100, 35.8),
        Material("Солнечная тетрадь", "Эксперементальный прочный пластик", 67, 2.7),
        Material("Жарко", "Для пекинского огородного питания", 45, 18.2),
        Material("Рождественский дар", "Эксперементальный прочный пластик", 90, 3.6),
        Material("Тигр", "Прочнейший материал для работ на лесоповале", 25, 41.8),
    ]

    sizes = [
        Size("Маленький"),
        Size("Средний"),
        Size("Большой"),
        Size("Крупный"),
    ]

    book_orders = [
        BookOrder(3, "2024-01-06 12:40:21", 3500, 12, 3, 1),
        BookOrder(1, "2024-01-08 16:12:55", 1400, 4, 1, 2),
        BookOrder(4,  "2024-01-09 13:00:43", 8000, 120, 3, 2),
        BookOrder(6,  "2024-01-09 13:43:26", 6700, 18, 2, 4),
        BookOrder(5,  "2024-01-12 11:30:59", 5000, 10, 4, 3),
        BookOrder(7,  "2024-01-13 12:14:35", 6000, 8, 2, 4),
        BookOrder(2,  "2024-02-14 13:57:29", 1800, 6, 1, 2),
        BookOrder(8,  "2024-02-16 11:02:11", 9000, 20, 3, 9),
        BookOrder(4,  "2024-02-17 15:58:04", 7000, 30, 4, 8),
        BookOrder(1,  "2024-02-20 17:18:53", 6000, 12, 3, 5),
        BookOrder(9, "2024-03-22 11:43:05", 12000, 24, 2, 2),
        BookOrder(6, "2024-03-24 15:27:50", 9000, 28, 1, 6),
        BookOrder(10, "2024-03-27 12:39:48", 15000, 36, 4, 7),
        BookOrder(5, "2024-03-30 14:48:46", 8000, 20, 3, 7),
    ]

    painting_orders = [
        PaintingOrder(13, 1500, 240, 127, "2024-01-09 13:00:43"),
        PaintingOrder(2, 1800, 220, 140, "2024-01-10 13:12:31"),
        PaintingOrder(10, 1000, 160, 100, "2024-01-10 14:40:61"),
        PaintingOrder(9, 600, 100, 50, "2024-02-03 15:17:48"),
        PaintingOrder(11, 1200, 180, 90, "2024-02-06 15:34:52"),
        PaintingOrder(7, 1800, 240, 140, "2024-02-13 13:15:11"),
        PaintingOrder(4, 600, 80, 45, "2024-02-20 16:47:24"),
        PaintingOrder(2, 900, 100, 60, "2024-03-04 14:38:21"),
        PaintingOrder(12, 1500, 240, 165, "2024-03-10 17:09:57"),
        PaintingOrder(6, 1800, 300, 180, "2024-03-18 16:27:02"),
        PaintingOrder(9, 1200, 200, 120, "2024-03-25 12:59:05"),
    ]

    for customer in customers:
        db.add_customer(customer)

    for material in materials:
        db.add_material(material)

    for size in sizes:
        db.add_size(size)

    for order in book_orders:
        db.add_book_order(order)

    for order in painting_orders:
        db.add_painting_order(order)


if __name__ == "__main__":
    main()
