# pylint: skip-file

from deutsch_algorithm import deutsch_alg

if __name__ == "__main__":
    print("Задание 3: алгоритм Дойча")

    def f_const(x):
        return 1

    def f_balanced(x):
        return not x

    print(f"Константная функция f(x) = 1, результат: {deutsch_alg(f_const)}")
    print(f"Сбалансированная функция f(x) = ~x, результат: {deutsch_alg(f_balanced)}")
