# 1. Напишите программу, которая осуществляет чтение данных из файла посредством
# одного потока и запись этих данных в другом потоке в файл. Названия файлов
# должны отличаться.

from multiprocessing import Event, Process, Queue


class InputProcess(Process):
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


class OutputProcess(Process):
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


input_path = "task02-input.txt"
output_path = "task02-output.txt"

event = Event()
event.clear()
queue = Queue()

input_process = InputProcess(input_path, event, queue)
output_process = OutputProcess(output_path, event, queue)

input_process.start()
output_process.start()
