from socket import socket
from typing import List

from models.message import Message
from models.requests import (Authentication, Close, GetNewMessages,
                             MessageSend, Registration)
from models.status import StatusCode
from networking.common import recv_response, recv_text, send_request


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
