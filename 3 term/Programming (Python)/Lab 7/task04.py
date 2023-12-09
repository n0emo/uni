from collections import namedtuple
from multiprocessing import Process, Queue

import array
from typing import List
Result = namedtuple("Result", "thread row")


def mul_row(
        queue: Queue,
        arr_a: List[array.array],
        arr_b: List[array.array],
        row: int
    ) -> None:
    result = array.array("d")
    for col in range(len(arr_a)):
        s = 0
        for i in range(len(arr_b)):
            s += arr_a[row][i] * arr_b[i][col]
        result.append(s)

    queue.put(Result(row, result))

def mat_mul(a, b):
    queue = Queue()
    processes = []

    for i in range(len(a)):
        process = Process(target=mul_row, args=(queue, a, b, i))
        processes.append(process)
        process.start()

    for process in processes:
        process.join()

    results = []
    while not queue.empty():
        results.append(queue.get())

    results.sort(key=lambda r : r.row)
    return list(map(lambda r: r.row, results))

mat_a = [
    array.array("d", [1, 2]),
    array.array("d", [3, 4]),
    array.array("d", [5, 6]),
]

mat_b = [
    array.array("d", [7, 8, 9]),
    array.array("d", [10, 11, 12]),
]

print(mat_mul(mat_a, mat_b))
