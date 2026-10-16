import datetime
import json


class Color:
    def __init__(self, r: int, g: int, b: int):
        if not (0 <= r <= 255) or \
           not (0 <= g <= 255) or \
           not (0 <= b <= 255):
            raise ValueError("Color components must be in range [0, 255]")

        self.r = r
        self.g = g
        self.b = b


class Message(dict):
    TIME_FORMAT = "%Y-%m-%d %H:%M"

    @property
    def time(self):
        return datetime.datetime.strptime(self["time"], self.TIME_FORMAT)

    @property
    def user(self):
        return self["user"]

    @property
    def text(self):
        return self["text"]

    @property
    def color(self):
        hashed_user = self.user_hash() % 2**24
        r = (hashed_user & 0xFF0000) >> 16
        g = (hashed_user & 0x00FF00) >> 8
        b = hashed_user & 0x0000FF
        return Color(r, g, b)

    def __init__(self, user: str, text: str, time: str):
        super().__init__(user=user, text=text, time=time)

    @staticmethod
    def new(user: str, text: str) -> "Message":
        time = datetime.datetime.now().strftime(Message.TIME_FORMAT)
        return Message(user, text, time)

    @staticmethod
    def from_json(json_: str):
        return Message.from_dict(json.loads(json_))

    @staticmethod
    def from_dict(dct: dict):
        return Message(dct["user"], dct["text"], dct["time"])


    @staticmethod
    def list_from_json(json_: str):
        messages = json.loads(json_)
        return list(map(
            lambda m: Message.from_dict(m),
            messages
        ))

    def __str__(self):
        return f"[{self.time.hour}:{self.time.minute}] {self.user}: {self.text}"


    def user_hash(self):
        h = 0
        for c in self["user"]:
            h = ((h * 7919) ^ (ord(c) * 7907)) * 7901
        return h % 2**32
