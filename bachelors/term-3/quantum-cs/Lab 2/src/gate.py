# pylint: skip-file

from cmath import cos, exp, sin, sqrt

import numpy as np

from qubit import Qubit
from utils import *


class Gate:
    _array: np.matrix

    def __init__(self, matrix: list | np.matrix) -> None:
        if not isinstance(matrix, np.matrix):
            matrix = np.matrix(matrix)

        if not self.validate_matrix(matrix):
            raise ValueError("Array must be matrix with power of 2 dimensions")

        self._array = matrix

    def apply(self, qubit: Qubit) -> Qubit:
        return Qubit(qubit.get_vector() * self._array)

    def __str__(self) -> str:
        return str(self._array)

    def __mul__(self, other):
        new_array = np.kron(self._array, other._array)
        return Gate(new_array)

    @staticmethod
    def validate_matrix(matrix: np.matrix) -> bool:
        is_square = matrix.shape[0] == matrix.shape[1]
        return is_square and is_power_of_two(len(matrix))

    @staticmethod
    def i_gate(size: int) -> "Gate":
        if not is_power_of_two(size):
            raise ValueError("Size must be power of two")

        return Gate([[int(col == row) for col in range(size)] for row in range(size)])

    @staticmethod
    def pauli_x() -> "Gate":
        return Gate([[0, 1], [1, 0]])

    @staticmethod
    def pauli_y() -> "Gate":
        return Gate([[0, -1j], [1j, 0]])

    @staticmethod
    def pauli_z() -> "Gate":
        return Gate([[1, 0], [0, -1]])

    @staticmethod
    def hadamard_1() -> "Gate":
        inv_sqrt_2 = 1 / sqrt(2)
        return Gate([[inv_sqrt_2, inv_sqrt_2], [inv_sqrt_2, -inv_sqrt_2]])

    @staticmethod
    def hadamard(size: int) -> "Gate":
        return Gate(
            [
                [
                    2 ** (-size / 2) * (-1) ** binary_dot_product(row, col)
                    for col in range(2**size)
                ]
                for row in range(2**size)
            ]
        )

    @staticmethod
    def phase() -> "Gate":
        return Gate([[1, 0], [0, 1j]])

    @staticmethod
    def t_gate() -> "Gate":
        return Gate([[1, 0], [0, (1 + 1j) / sqrt(2)]])

    @staticmethod
    def controlled_not() -> "Gate":
        return Gate([[1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 0, 1], [0, 0, 1, 0]])

    @staticmethod
    def controlled_y() -> "Gate":
        return Gate([[1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 0, -1j], [0, 0, -1j, 0]])

    @staticmethod
    def controlled_z() -> "Gate":
        return Gate([[1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 1, 0], [0, 0, 0, -1]])

    @staticmethod
    def x_rotation(phase: float) -> "Gate":
        half_phase = phase * 0.5
        phase_sin = -1j * sin(half_phase)
        phase_cos = cos(half_phase)
        return Gate([[phase_cos, phase_sin], [phase_sin, phase_cos]])

    @staticmethod
    def y_rotation(phase: float) -> "Gate":
        half_phase = phase * 0.5
        phase_sin = sin(half_phase)
        phase_cos = cos(half_phase)
        return Gate([[phase_cos, -phase_sin], [phase_sin, phase_cos]])

    @staticmethod
    def z_rotation(phase: float) -> "Gate":
        half_phase = phase * 0.5
        return Gate([[exp(-1j * half_phase), 0], [0, exp(1j * half_phase)]])

    @staticmethod
    def phase_shift_1(phase_1: float) -> "Gate":
        return Gate([[1, 0], [0, exp(1j * phase_1)]])

    @staticmethod
    def phase_shit_2(phase_1: float, phase_2: float) -> "Gate":
        return Gate(
            [
                [1, exp(-1j * phase_2)],
                [exp(1j * phase_1), exp(1j * (phase_1 + phase_2))],
            ]
        )

    @staticmethod
    def phase_shift_3(phase_1: float, phase_2: float, phase_3: float) -> "Gate":
        half_phase_1 = phase_1 * 0.5
        return Gate(
            [
                [cos(half_phase_1), -exp(-1j * phase_3) * sin(half_phase_1)],
                [
                    exp(1j * phase_2) * sin(half_phase_1),
                    exp(1j * (phase_3 + phase_2) * cos(half_phase_1)),
                ],
            ]
        )

    @staticmethod
    def fermionic_simulation(rot_y: float, rot_z: float) -> "Gate":
        sin_y = sin(rot_y)
        cos_y = sin(rot_y)
        return Gate(
            [
                [1, 0, 0, 0],
                [0, cos_y, -1j * sin_y, 0],
                [0, -1j * sin_y, cos_y, 0],
                [0, 0, 0, exp(-1j * rot_z)],
            ]
        )
