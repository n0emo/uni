import json
from queue import Queue
from socket import socket
from threading import Thread
from typing import Dict, Tuple

from models.message import Message
from models.requests import Request, RequestType
from models.status import StatusCode
from networking.common import recv_request, respond, send_text
from networking.password import add_pass, check_pass, login_exists


class ClientSocketThread(Thread):
    class CloseConnection(Exception):
        def __init__(self, *args: object) -> None:
            super().__init__(*args)


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
            
            except self.CloseConnection:
                break
            except Exception:
                print("Internal error while handling request")
                respond(self.sock, StatusCode.INTERNAL_ERROR)

        self.close()

    def handle_request(self, request: Request):
        if request["type"] == RequestType.GET_NEW_MESSAGES:
            self.handle_get_new_messages()
        elif request["type"] == RequestType.MESSAGE_SEND:
            self.handle_message_send(request)
        elif request["type"] == RequestType.AUTHENTICATION:
            self.handle_authentication(request)
        elif request["type"] == RequestType.REGISTRATION:
            self.handle_registration(request)
        if request["type"] == RequestType.CLOSE:
            raise self.CloseConnection()
    
    def handle_get_new_messages(self):
        messages = []
        message_queue = self.client_message_queues[self.sock]

        while not message_queue.empty():
            messages.append(message_queue.get())

        messages_json = json.dumps(messages)

        send_text(self.sock, messages_json)

    def handle_message_send(self, request):
        if not self.authorized:
            respond(self.sock, StatusCode.FORBIDDEN)
            return

        assert self.user is not None
        
        message = Message.new(self.user, request["text"])
        for client in self.client_message_queues.values():
            client.put(message)

        respond(self.sock, StatusCode.OK)

    def handle_authentication(self, request):
        if check_pass(request["login"], request["password"]):
            self.authorized = True
            self.user = request["login"]
            respond(self.sock, StatusCode.OK)
        else:
            respond(self.sock, StatusCode.UNAUTHORIZED)

    def handle_registration(self, request):
        if login_exists(request["login"]):
            respond(self.sock, StatusCode.CONFLICT)
            return

        add_pass(request["login"], request["password"])
        respond(self.sock, StatusCode.CREATED)
        return


    def close(self) -> None:
        self.client_message_queues.pop(self.sock)
        self.sock.close()
        print(f"Disconnected from {self.address}")
