from collections import namedtuple
from multiprocessing import Process, Queue
from typing import Any, Callable, Iterable, Mapping

import numpy as np

Result = namedtuple("result", "thread row")


class RowProcess(Process):
    def __init__(
        self,
        queue: Queue,
        group: None = None,
        target: Callable[..., object] | None = None,
        name: str | None = None,
        args: Iterable[Any] = [],
        kwargs: Mapping[str, Any] = {},
        *,
        daemon: bool | None = None
    ) -> None:
        super().__init__(group, target, name, args, kwargs, daemon=daemon)
        self.queue = queue
