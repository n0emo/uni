# 8. Напишите программу, которая заполняет 20 случайными значениями Queue,
# передаваемую четырем запускаемым потокам (процесса), после чего выведите в
# консоль извлекаемые из структуры данных значения с информацией о том, в каком
# потоке (процессе) это произошло.

from threading import Thread
from queue import Queue
from time import sleep
from random import randint


def dequeue(queue: Queue, thread):
    while not queue.empty():
        print(f"[Thread {thread}]: got {queue.get()}")
        sleep(0.1)

if __name__ == "__main__":
    queue = Queue()
    for _ in range(20):
        queue.put(randint(0, 1000))

    threads = [
        Thread(target=dequeue, args=(queue, i))
        for i in range(4)
    ]

    for thread in threads:
        thread.start()

    for thread in threads:
        thread.join()

