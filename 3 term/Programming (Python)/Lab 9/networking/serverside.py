import json
from threading import Lock, RLock, Thread
from socket import socket
from time import sleep
from typing import Dict, Tuple, List
from queue import Queue

from models.requests import Request, RequestType
from models.message import Message
from models.status import StatusCode

from networking.common import (
    recv_request,
    respond,
    send_text,
)
from networking.password import check_pass, login_exists, add_pass


class ClientSocketThread(Thread):
    def __init__(self, 
                 sock: socket, 
                 address: Tuple[str, int], 
                 client_message_queues: Dict[socket, Queue]):

        super().__init__()

        self.sock = sock
        self.address = address
        self.client_message_queues = client_message_queues
        self.authorized = False
        self.user = None

    def run(self) -> None:
        print(f"Connected to {self.address}")
        self.client_message_queues[self.sock] = Queue()

        while True:
            try:
                request = recv_request(self.sock)
                if request is None:
                    break
                
                req_type_str = request["type"].replace('_', ' ').capitalize()
                print(f"{req_type_str} request from {self.address}")

                self.handle_request(request)

            except Exception:
                print("Internal error while handling request")
                respond(self.sock, StatusCode.INTERNAL_ERROR)

        self.close()

    def handle_request(self, request: Request):
        if request["type"] == RequestType.GET_NEW_MESSAGES:
            messages = []
            message_queue = self.client_message_queues[self.sock]
            while not message_queue.empty():
                messages.append(message_queue.get())
            messages_json = json.dumps(messages)
            send_text(self.sock, messages_json)

        elif request["type"] == RequestType.MESSAGE_SEND:
            if not self.authorized:
                respond(self.sock, StatusCode.FORBIDDEN)
                return

            assert self.user is not None
            
            message = Message.new(self.user, request["text"])
            for client in self.client_message_queues.values():
                client.put(message)

            respond(self.sock, StatusCode.OK)
            return
          
        elif request["type"] == RequestType.AUTHENTICATION:
            if check_pass(request["login"], request["password"]):
                self.authorized = True
                self.user = request["login"]
                respond(self.sock, StatusCode.OK)
            else:
                respond(self.sock, StatusCode.UNAUTHORIZED)
            return

        elif request["type"] == RequestType.REGISTRATION:
            if login_exists(request["login"]):
                respond(self.sock, StatusCode.CONFLICT)
                return

            add_pass(request["login"], request["password"])
            respond(self.sock, StatusCode.CREATED)
            return

        if request["type"] == RequestType.CLOSE:
            return
        

    def close(self) -> None:
        self.client_message_queues.pop(self.sock)
        self.sock.close()
        print(f"Disconnected from {self.address}")

