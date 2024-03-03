import sqlite3

from model import *


def get_connection() -> sqlite3.Connection:
    return sqlite3.connect("fbook.db")


def create_tables() -> None:
    with get_connection() as conn:
        cur = conn.cursor()

        sql = """
            CREATE TABLE IF NOT EXISTS Customers (
                id INTEGER NOT NULL PRIMARY KEY,
                name TEXT NOT NULL,
                surname TEXT NOT NULL,
                address TEXT NOT NULL,
                phone TEXT NOT NULL
            );

            CREATE TABLE IF NOT EXISTS BookOrders (
                id INTEGER NOT NULL PRIMARY KEY,
                customerId INTEGER NOT NULL,
                datetime TEXT NOT NULL,
                cost REAL NOT NULL,
                numberOfTurns INTEGER NOT NULL,
                size TEXT NOT NULL,
                materialId INTEGER NOT NULL,
                FOREIGN KEY(customerId) REFERENCES Customers(id),
                FOREIGN KEY(materialId) REFERENCES Materials(id)
            );

            CREATE TABLE IF NOT EXISTS PaintingOrders (
                id INTEGER NOT NULL PRIMARY KEY,
                customerId INTEGER NOT NULL,
                datetime TEXT NOT NULL,
                cost REAL NOT NULL,
                width INTEGER NOT NULL,
                height INTEGET NOT NULL,
                FOREIGN KEY(customerId) REFERENCES Customers(id)
            );

            CREATE TABLE IF NOT EXISTS Materials (
                id INTEGER NOT NULL PRIMARY KEY,
                name TEXT NOT NULL,
                description TEXT NOT NULL,
                price REAL NOT NULL,
                stock REAL NOT NULL
            );
        """

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
            (customerId, datetime, cost, numberOfTurns, size, materialId)
            VALUES (?, ?, ?, ?, ?, ?)
        """
        cur.execute(
            sql,
            [
                order.customer_id,
                order.datetime,
                order.cost,
                order.number_of_turns,
                order.size,
                order.materialId,
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
