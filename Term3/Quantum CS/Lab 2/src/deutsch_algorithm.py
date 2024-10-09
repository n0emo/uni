# pylint: skip-file

from collections.abc import Callable

from gate import Gate
from qubit import Qubit
from utils import *


def deutsch_alg(f: Callable) -> int:
    return (
        Gate.hadamard_1()
        .apply(Qubit.ket("0") + Qubit.ket("1").mul_by((-1) ** xor(f(1), f(0))))
        .measure()
        .result
    )
