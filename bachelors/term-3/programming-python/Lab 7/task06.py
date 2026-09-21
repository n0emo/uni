# 6. Напишите программу, реализующую задачу про обедающих философов на основе
# процессов.

from threading import Lock, Thread, Semaphore
import time


class Philosopher(Thread):
    def __init__(self, semaphore, index, left_fork, right_fork):
        Thread.__init__(self)
        self.semaphore = semaphore
        self.index = index
        self.left_fork = left_fork
        self.right_fork = right_fork

    def run(self):
        for _ in range(10000):
            with self.semaphore:
                self.eat()
            self.think()

    def eat(self):
        self.left_fork.acquire()
        self.right_fork.acquire()
        print(f"Philosopher {self.index} is eating")
        time.sleep(0.0001)
        self.left_fork.release()
        self.right_fork.release()
        print(f"Philosopher {self.index} is done eating")

    def think(self):
        print(f"Philosopher {self.index} is thinking")
        time.sleep(0.0001)

    

forks = [Lock() for _ in range(5)]
semaphore = Semaphore(2)

philosophers = [
    Philosopher(semaphore, i,  forks[i], forks[(i + 1) % 5]) 
    for i in range(5)
]

for philosopher in philosophers:
    philosopher.start()

for philosopher in philosophers:
    philosopher.join()
