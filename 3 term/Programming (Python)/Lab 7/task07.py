# 7. Напишите программу, в которой 10 списков заполняются случайными значениями,
# после чего для каждого из списка в отдельном потоке (процессе) находится
# медиана.

from collections import namedtuple
from multiprocessing import Process, Queue
from statistics import median
from random import randint

Result = namedtuple("Result", "median list")


def proc_median(queue, lst):
    result = Result(median(lst), lst)
    queue.put(result)

if __name__ == "__main__":
    lists = [
        [randint(0, 100) for _ in range(randint(5, 10))]
        for _ in range(10)
    ]

    processes = []
    queue = Queue()

    for lst in lists:
        process = Process(target=proc_median, args=(queue, lst))
        processes.append(process)
        process.start()

    for process in processes:
        process.join()

    while not queue.empty():
        print(queue.get())
