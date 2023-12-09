from threading import Thread, RLock
from time import sleep

class Counter:
    value: int

    def __init__(self) -> None:
        self.value = 0

def inc(counter, lock, amount, thread):
    for _ in range(amount):
        with lock:
            print(f"[Thread {thread}: {counter.value}")
            sleep(0.03)
            counter.value += 1

threads = []            
counter = Counter()
lock = RLock()
thread_count = 10
for i in range(thread_count):
    thread = Thread(target=inc, args=(counter, lock, 10, i))
    threads.append(thread)
    thread.start()

for thread in threads:
    thread.join()

print(counter.value)



