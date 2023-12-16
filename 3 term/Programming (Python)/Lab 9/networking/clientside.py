from collections.abc import Callable
import json
from threading import Lock, Thread
from time import sleep
from socket import socket
from typing import List
from networking.common import (
    recv_json,
    recv_obj,
    recv_response,
    send_request,
    send_text,
    recv_text,
)

from models.status import StatusCode
from models.requests import Close, GetNewMessages, MessageSend, Registration, Request, Authentication
from models.message import Message


def authorize(sock: socket, login: str, password: str) -> StatusCode | None:
    send_request(sock, Authentication(login, password))
    return recv_response(sock)
    

def register(sock: socket, login: str, password: str) -> StatusCode | None:
    send_request(sock, Registration(login, password))
    return recv_response(sock)
    

def send_message(sock: socket, text: str) -> StatusCode | None:
    send_request(sock, MessageSend(text))
    return recv_response(sock)
    

def get_new_messages(sock: socket) -> List[Message] | None:
    send_request(sock, GetNewMessages())
    messages_json = recv_text(sock)
    if messages_json is None:
        return None

    return Message.list_from_json(messages_json)

def close_req(sock):
    send_request(sock, Close())
