import os
import platform
import sys
from collections import namedtuple

import shopdb as db
from tabulate import tabulate

Action = namedtuple("Action", ("desc", "func"))

id_fields = ["id"] + db.fields
human_id_fields = ["ID"] + db.human_fields

clear = ""
match platform.system():
    case "Linux" | "Darwin" | "Unix":
        clear = "clear"
    case "Windows":
        clear = "cls"


def get_field_from_user():
    print("Введите номер поля:")
    for number, field in enumerate(human_id_fields):
        print(f"{number} - {field}")
    field_num = int(input())
    field = id_fields[field_num]

    value = input("Введите значение поля: ")

    return field, value


def exit():
    global running
    running = False


def get_all_records():
    print(tabulate(db.get_all_records(), human_id_fields))


def get_records_by_field():
    field, value = get_field_from_user()
    print(tabulate(db.get_records_by_field(field, value), id_fields))


def insert_record():
    values = (input(f"введите '{field}': ") for field in db.human_fields)
    db.insert_record(db.Record(*values))


def update_field():
    id = input("Введите ID записи: ")
    field, value = get_field_from_user()
    db.update_field(id, field, value)


def delete():
    id = int(input("Введите ID: "))
    db.delete(id)


def delete_by_field():
    field, value = get_field_from_user()
    db.delete_by_field(field, value)


actions = [
    Action("выйти из программы", exit),
    Action("вывести все записи", get_all_records),
    Action("вывести значения по полю", get_records_by_field),
    Action("добавить новую запись", insert_record),
    Action("обновить запись по ID", update_field),
    Action("удалить запись по ID", delete),
    Action("удалить запись по полю", delete_by_field),
]


if __name__ == "__main__":
    try:
        db.create_table()

        running = True
        while running:
            os.system(clear)

            print("Введите номер желаемого действия:")
            for number, action in enumerate(actions):
                print(f"{number} - {action.desc}")

            try:
                action_number = int(input())
                actions[action_number].func()
            except IndexError:
                print("Введённый номер был вне границ массива")
            except ValueError:
                print("Ошибка входного значения")
            except KeyboardInterrupt:
                raise KeyboardInterrupt
            except Exception as e:
                print("Ошибка:", e)

            input("Нажмите ENTER для продолжения...")

    except KeyboardInterrupt:
        sys.exit(0)
