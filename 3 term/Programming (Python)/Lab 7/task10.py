from threading import Thread, Event
from queue import Queue
from time import sleep


def read_file_proc(file, queue, start_event, end_event):
    print("Started reading file")
    start_event.set()
    for line in file.readlines():
        queue.put(line)
    print("Ended reading file")
    end_event.set()

def write_file_proc(process, file, queue, start_event, end_event):
    print(f"[Process {process}] Waiting until file reading")
    start_event.wait()
    print(f"[Process {process}] Started writing")
    while not (end_event.is_set() and queue.empty()):
        if not queue.empty():
            line = queue.get()
            print(f"[Process {process}] Writing '{line[0:-1]}'")
            file.write(line)
            sleep(0.01)
    print(f"[Process {process}] Ended writing")

with open("task10-input.txt", 'r') as inputfile, \
     open("task10-output.txt", 'w') as outputfile:
    start_event = Event()
    start_event.clear()
    end_event = Event()
    end_event.clear()

    queue = Queue()
    read_thread = Thread(
        target=read_file_proc,
        args=(inputfile, queue, start_event, end_event)
    )
    
    write_thread = [
        Thread(
            target=write_file_proc,
            args=(i, outputfile, queue, start_event, end_event)
        )
        for i in range(3)
    ]

    read_thread.start()
    for thread in write_thread:
        thread.start()

    read_thread.join()
    for thread in write_thread:
        thread.join()

