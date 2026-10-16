# 1. Напишите программу, которая осуществляет чтение данных из файла посредством
# одного потока и запись этих данных в другом потоке в файл. Названия файлов
# должны отличаться.

from queue import Queue
from threading import Event, Thread


class InputThread(Thread):
    __event: Event
    __path: str
    __queue: Queue

    def __init__(self, path: str, event: Event, queue: Queue) -> None:
        super().__init__()

        self.__event = event
        self.__path = path
        self.__queue = queue

    def run(self) -> None:
        print("Started reading")
        self.__event.set()
        with open(self.__path, "r") as file:
            for line in file.readlines():
                self.__queue.put(line)
        self.__event.clear()
        print("Done reading")


class OutputThread(Thread):
    __event: Event
    __path: str
    __queue: Queue

    def __init__(self, path: str, event: Event, queue: Queue) -> None:
        super().__init__()

        self.__event = event
        self.__path = path
        self.__queue = queue

    def run(self) -> None:
        self.__event.wait()
        print("Started writing")
        with open(self.__path, "w") as file:
            while self.__event.is_set() or not self.__queue.empty():
                while not self.__queue.empty():
                    file.write(self.__queue.get())
        print("Done writing")


if __name__ == "__main__":
    input_path = "task01-input.txt"
    output_path = "task01-output.txt"

    event = Event()
    event.clear()
    queue = Queue()

    input_thread = InputThread(input_path, event, queue)
    output_thread = OutputThread(output_path, event, queue)

    input_thread.start()
    output_thread.start()
