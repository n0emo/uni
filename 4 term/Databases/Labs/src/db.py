import os
import sqlite3

from model import BookOrder, Customer, Material, PaintingOrder, Size

_db_filename_ = "fbook.db"


def delete_db():
    os.remove(_db_filename_)


def get_connection() -> sqlite3.Connection:
    conn = sqlite3.connect(_db_filename_)
    conn.execute("Pragma foreign_keys=ON")
    return conn


def create_tables() -> None:
    with get_connection() as conn:
        cur = conn.cursor()

        sql = open("sql/create.sql").read()

        cur.executescript(sql)


def add_customer(customer: Customer) -> None:
    with get_connection() as conn:
        cur = conn.cursor()
        sql = """
            INSERT INTO Customers 
            (name, surname, address, phone) 
            VALUES (?, ?, ?, ?)
        """
        cur.execute(
            sql, (customer.name, customer.surname, customer.address, customer.phone)
        )


def remove_customer_by_id(id: int) -> None:
    with get_connection() as conn:
        cur = conn.cursor()
        sql = "DELETE FROM Customers WHERE id = ?"
        cur.execute(sql, [id])


def add_material(material: Material) -> None:
    with get_connection() as conn:
        cur = conn.cursor()
        sql = """
            INSERT INTO Materials 
            (name, description, price, stock)
            VALUES(?, ?, ?, ?)
        """
        cur.execute(
            sql, (material.name, material.description, material.price, material.stock)
        )


def add_size(size: Size) -> None:
    with get_connection() as conn:
        cur = conn.cursor()
        sql = """
            INSERT INTO Sizes
            (name)
            VALUES(?)
        """
        cur.execute(sql, (size.name,))


def update_material_stock(name: str, new_stock: float) -> None:
    with get_connection() as conn:
        cur = conn.cursor()
        sql = "UPDATE Materials SET stock = ? WHERE name = ?"
        cur.execute(sql, [new_stock, name])


def add_book_order(order: BookOrder) -> None:
    with get_connection() as conn:
        cur = conn.cursor()
        sql = """
            INSERT INTO BookOrders 
            (customerId, datetime, cost, numberOfTurns, sizeId, materialId)
            VALUES (?, ?, ?, ?, ?, ?)
        """
        cur.execute(
            sql,
            [
                order.customer_id,
                order.datetime,
                order.cost,
                order.number_of_turns,
                order.size_id,
                order.material_id,
            ],
        )


def add_painting_order(order: PaintingOrder) -> None:
    with get_connection() as conn:
        cur = conn.cursor()
        sql = """
            INSERT INTO PaintingOrders
            (customerId, datetime, cost, width, height)
            VALUES (?, ?, ?, ?, ?)
        """
        cur.execute(
            sql,
            [order.customer_id, order.datetime, order.cost, order.width, order.height],
        )


def int_sql(sql: str) -> int:
    with get_connection() as conn:
        cur = conn.cursor()
        cur.execute(sql)
        return cur.fetchone()[0]


def count_customers() -> int:
    return int_sql("SELECT COUNT(*) FROM Customers")


def sum_painting_orders() -> int:
    return int_sql("SELECT SUM(cost) FROM PaintingOrders")


def avg_book_cost() -> int:
    return int_sql("SELECT AVG(cost) FROM BookOrders")


def max_painting_cost() -> int:
    return int_sql("SELECT MAX(cost) FROM PaintingOrders")


def min_book_number_of_turns() -> int:
    return int_sql("SELECT MIN(numberOfTurns) FROM BookOrders")


def earliest_book() -> BookOrder:
    with get_connection() as conn:
        cur = conn.cursor()
        cur.execute("SELECT MIN(datetime) FROM BookOrders")
        date = cur.fetchone()[0]
        sql = "SELECT * FROM BookOrders WHERE datetime = ?"
        result = cur.execute(sql, (date,)).fetchone()
        return BookOrder.new_from_db(*result)


def get_customers_with_prefix(prefix: str) -> list[Customer]:
    with get_connection() as conn:
        cur = conn.cursor()
        sql = "SELECT * FROM Customers WHERE (name || ' ' || surname) LIKE ?"
        result = cur.execute(sql, (f"{prefix}%",)).fetchall()
        return [Customer.new_from_db(*r) for r in result]


def get_painting_dimensions(id: int) -> str:
    with get_connection() as conn:
        cur = conn.cursor()
        sql = """
            SELECT cast(width as text) || 'x' || cast(height as text)
            FROM PaintingOrders 
            WHERE id=?
        """
        result = cur.execute(sql, (id,))
        return result.fetchone()[0]


def get_books_grouped_by_material_id():
    with get_connection() as conn:
        cur = conn.cursor()
        sql = """
            SELECT materialId, SUM(cost) FROM BookOrders
            GROUP BY materialId
        """
        return cur.execute(sql).fetchall()


def get_books_grouped_by_size_having_overall_cost_more_than(cost: int):
    with get_connection() as conn:
        cur = conn.cursor()
        sql = """
            SELECT sizeId, sum(cost) FROM BookOrders
            GROUP BY sizeId
            HAVING sum(cost) > ?
        """
        return cur.execute(sql, (cost,)).fetchall()


def get_materials_sorted_by_stock() -> list:
    with get_connection() as conn:
        cur = conn.cursor()
        return cur.execute("SELECT * FROM MaterialStockView").fetchall()


def cross_join_materials_sizes() -> list:
    with get_connection() as conn:
        cur = conn.cursor()
        sql = """
            SELECT Materials.name, Sizes.name
            FROM Materials
            CROSS JOIN Sizes
        """
        return cur.execute(sql).fetchall()


def natural_join() -> list:
    with get_connection() as conn:
        cur = conn.cursor()
        sql = """
            SELECT BookOrders.id, BookOrders.cost, Materials.name, BookOrders.datetime
            FROM BookOrders
            JOIN Materials on Materials.id = BookOrders.materialId
        """
        return cur.execute(sql).fetchall()
