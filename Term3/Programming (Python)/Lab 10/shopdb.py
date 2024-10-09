import sqlite3
from collections import namedtuple

record_name = "product"
table_name = "products"
db_file = f"{table_name}.db"
fields = ["name", "unit", "amount", "price"]
field_db_types = ["TEXT", "TEXT", "INTEGER", "INTEGER"]

human_fields = ["Название", "Единица измерения", "Количество в упаковке", "Цена"]
human_record_name = "Продукт"

Record = namedtuple(record_name, fields)

conn = sqlite3.connect(db_file)
curs = conn.cursor()


def create_table():
    sql = f"CREATE TABLE IF NOT EXISTS {table_name} (id INTEGER PRIMARY KEY AUTOINCREMENT, "
    sql += ", ".join(map(lambda t: f"{t[1]} {t[0]}", zip(field_db_types, fields)))
    sql += ")"
    curs.execute(sql)
    conn.commit()


def get_all_records():
    curs.execute(f"SELECT * FROM {table_name}")
    return curs.fetchall()


def get_records_by_field(field, value):
    curs.execute(f"SELECT * FROM {table_name} WHERE {field}=?", (value,))
    return curs.fetchall()


def insert_record(record):
    with conn:
        curs.execute(
            f"INSERT INTO {table_name} VALUES (NULL, {', '.join('?' * len(fields))})",
            record,
        )


def update_field(id, field, value):
    with conn:
        curs.execute(f"UPDATE {table_name} SET {field}=? WHERE id=?", (value, id))


def delete(id):
    with conn:
        curs.execute(f"DELETE FROM {table_name} WHERE id=?", (id,))


def delete_by_field(field, value):
    with conn:
        curs.execute(f"DELETE FROM {table_name} WHERE {field}=?", (value,))
