import os
import sqlite3
from typing import Any

from model import BookOrder, Customer, Material, PaintingOrder, Size

_db_filename_ = "fbook.db"


def delete_db():
    os.remove(_db_filename_)


def get_connection() -> sqlite3.Connection:
    conn = sqlite3.connect(_db_filename_)
    conn.execute("Pragma foreign_keys=ON")
    return conn


def execute_sql(sql: str, params=None) -> None:
    if params is None:
        params = []
    with get_connection() as conn:
        cur = conn.cursor()
        cur.execute(sql, params)


def execute_script(script: str) -> None:
    with get_connection() as conn:
        cur = conn.cursor()
        cur.executescript(script)


def fetchone_sql(sql: str, params=None) -> Any:
    if params is None:
        params = []
    with get_connection() as conn:
        cur = conn.cursor()
        cur.execute(sql, params)
        return cur.fetchone()[0]


def fetchall_sql(sql: str, params=None) -> list:
    if params is None:
        params = []
    with get_connection() as conn:
        cur = conn.cursor()
        cur.execute(sql, params)
        return cur.fetchall()


def create_tables() -> None:
    with open("sql/create.sql") as file:
        sql = file.read()
        execute_script(sql)


def add_customer(customer: Customer) -> None:
    execute_sql(
        """
            INSERT INTO Customers 
            (name, surname, address, phone) 
            VALUES (?, ?, ?, ?)
        """,
        (customer.name, customer.surname, customer.address, customer.phone),
    )


def remove_customer_by_id(id: int) -> None:
    execute_sql("DELETE FROM Customers WHERE id = ?", (id,))


def add_material(material: Material) -> None:
    execute_sql(
        """
            INSERT INTO Materials 
            (name, description, price, stock)
            VALUES(?, ?, ?, ?)
        """,
        (material.name, material.description, material.price, material.stock),
    )


def add_size(size: Size) -> None:
    execute_sql(
        """
            INSERT INTO Sizes
            (name)
            VALUES(?)
        """,
        (size.name,),
    )


def update_material_stock(name: str, new_stock: float) -> None:
    return execute_sql(
        "UPDATE Materials SET stock = ? WHERE name = ?", (new_stock, name)
    )


def add_book_order(order: BookOrder) -> None:
    return execute_sql(
        """
            INSERT INTO BookOrders 
            (customerId, datetime, cost, numberOfTurns, sizeId, materialId)
            VALUES (?, ?, ?, ?, ?, ?)
        """,
        (
            order.customer_id,
            order.datetime,
            order.cost,
            order.number_of_turns,
            order.size_id,
            order.material_id,
        ),
    )


def add_painting_order(order: PaintingOrder) -> None:
    execute_sql(
        """
            INSERT INTO PaintingOrders
            (customerId, datetime, cost, width, height)
            VALUES (?, ?, ?, ?, ?)
        """,
        (order.customer_id, order.datetime, order.cost, order.width, order.height),
    )


def count_customers() -> int:
    return fetchone_sql("SELECT COUNT(*) FROM Customers")


def sum_painting_orders() -> int:
    return fetchone_sql("SELECT SUM(cost) FROM PaintingOrders")


def avg_book_cost() -> int:
    return fetchone_sql("SELECT AVG(cost) FROM BookOrders")


def max_painting_cost() -> int:
    return fetchone_sql("SELECT MAX(cost) FROM PaintingOrders")


def min_book_number_of_turns() -> int:
    return fetchone_sql("SELECT MIN(numberOfTurns) FROM BookOrders")


def earliest_book() -> BookOrder:
    date = fetchone_sql("SELECT MIN(datetime) FROM BookOrders")
    return BookOrder.new_from_db(
        *fetchall_sql("SELECT * FROM BookOrders WHERE datetime = ?", (date,))[0]
    )


def get_customers_with_prefix(prefix: str) -> list[Customer]:
    return [
        Customer.new_from_db(*r)
        for r in fetchall_sql(
            "SELECT * FROM Customers WHERE (name || ' ' || surname) LIKE ?",
            (f"{prefix}%",),
        )
    ]


def get_painting_dimensions(id: int) -> str:
    return fetchone_sql(
        """
            SELECT cast(width as text) || 'x' || cast(height as text)
            FROM PaintingOrders 
            WHERE id=?
        """,
        (id,),
    )


def get_books_grouped_by_material_id():
    return fetchall_sql(
        """
            SELECT materialId, SUM(cost) FROM BookOrders
            GROUP BY materialId
        """
    )


def get_books_grouped_by_size_having_overall_cost_more_than(cost: int):
    return fetchall_sql(
        """
            SELECT sizeId, sum(cost) FROM BookOrders
            GROUP BY sizeId
            HAVING sum(cost) > ?
        """,
        (cost,),
    )


def get_materials_sorted_by_stock() -> list:
    return fetchall_sql("SELECT * FROM MaterialStockView")


def cross_join_materials_sizes() -> list:
    return fetchall_sql(
        """
            SELECT Materials.name, Sizes.name
            FROM Materials
            CROSS JOIN Sizes
        """
    )


def join_on() -> list:
    return fetchall_sql(
        """
            SELECT BookOrders.id, BookOrders.cost, Materials.name, BookOrders.datetime
            FROM BookOrders
            JOIN Materials on Materials.id = BookOrders.materialId
        """
    )
