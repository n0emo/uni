import json
import enum


class RequestType(enum.StrEnum):
    AUTHENTICATION = "authentication"
    REGISTRATION = "registration"
    MESSAGE_SEND = "message_send"
    GET_NEW_MESSAGES = "get_new_messages"
    CLOSE = "close"


class Request(dict):
    def __init__(self, type: RequestType, **kwargs):
        super().__init__(type=type, **kwargs)


class Authentication(Request):
    def __init__(self, login: str, password: str):
        super().__init__(type=RequestType.AUTHENTICATION, login=login, password=password)


class Registration(Request):
    def __init__(self, login: str, password: str):
        super().__init__(type=RequestType.REGISTRATION, login=login, password=password)


class MessageSend(Request):
    def __init__(self, text: str):
        super().__init__(type=RequestType.MESSAGE_SEND, text=text)


class GetNewMessages(Request):
    def __init__(self):
        super().__init__(type=RequestType.GET_NEW_MESSAGES)


class Close(Request):
    def __init__(self):
        super().__init__(type=RequestType.CLOSE)

