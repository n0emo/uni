# pylint: skip-file

from collections import namedtuple
from functools import reduce

import numpy as np

from utils import *

MeasureResult = namedtuple("MeasureResult", "measured result")


class Qubit:
    _vector: np.matrix

    def __init__(self, vector: list | np.matrix) -> None:
        if not isinstance(vector, np.matrix):
            vector = np.matrix(vector)

        if not Qubit.validate_vector(vector):
            raise ValueError("Vector must be Nx1 matrix, where N is power of two")

        self._vector = vector

    # TODO: measure is not finished!!!
    def measure(self) -> MeasureResult:
        if self._vector.shape[1] != 2:
            raise NotImplemented()

        measured = self  # TODO : modify qubit
        result = int(np.random.ranf() > (self._vector.item(0) ** 2).real)
        return MeasureResult(measured, result)

    @staticmethod
    def ket(value: str) -> "Qubit":
        def ket_single(char):
            if char == "0":
                return Qubit([1, 0])
            elif char == "1":
                return Qubit([0, 1])
            else:
                raise ValueError("Value must be binary string")

        qubits = map(ket_single, value)
        return reduce(lambda a, b: a * b, qubits)

    @staticmethod
    def validate_vector(vector: np.matrix) -> bool:
        return is_power_of_two(vector.shape[1]) and vector.shape[0] == 1

    def get_vector(self) -> np.matrix:
        return self._vector

    def __str__(self) -> str:
        return str(self._vector)

    def __mul__(self, other) -> "Qubit":
        return Qubit(np.kron(self._vector, other._vector))

    def __add__(self, other) -> "Qubit":
        return Qubit(self._vector + other._vector)

    def __sub__(self, other) -> "Qubit":
        return Qubit(self._vector - other._vector)

    def mul_by(self, number: float) -> "Qubit":
        return Qubit(self._vector * number)
