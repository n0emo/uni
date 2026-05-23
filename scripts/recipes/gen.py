import os
from inspect import stack


class GenBuilder:
    _str: str

    def __init__(self) -> None:
        self._str = ""

    def gen(self, line: str) -> None:
        frame = stack()[1]
        filename = os.path.basename(frame.filename)
        self._str += f"{line} # {filename}:{frame.lineno}\n"

    def write(self, text: str) -> None:
        self._str += text

    def line(self) -> None:
        self._str += "\n"

    def __str__(self) -> str:
        return self._str
