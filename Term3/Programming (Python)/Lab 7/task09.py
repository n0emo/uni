# 9. Напишите программу, которая реализует следующую логику. Имеется общий
# счетчик для двух потоков (процессов), максимальное значение которого равно 50.
# Каждый из потоков (процессов) ожидает, пока другой увеличит значение счетчика
# на 5, после чего тот поток переходит в режим ожидания, а текущий начинает
# увеличивать значение счетчика.

from multiprocessing import Value, Process, RLock
from time import sleep
from ctypes import c_int32


def inc_five(lock, counter, process):
    while counter.value < 50:
        with lock:
            for _ in range(5):
                counter.value += 1
                print(f"[Process {process}: {counter.value=}]")
        sleep(1)


if __name__ == "__main__":
    counter = Value(c_int32, 0)
    lock = RLock()

    processes = [
        Process(target=inc_five, args=(lock, counter, i))
        for i in range(2)
    ]

    for process in processes:
        process.start()

    for process in processes:
        process.join()
