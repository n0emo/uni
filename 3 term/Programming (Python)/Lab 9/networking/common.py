import json
import pickle
import socket
from models.requests import Request
from models.status import StatusCode


HEADER_SIZE = 10
ADDRESS = (socket.gethostname(), 5059)


def send_obj(sock, msg):
    data = pickle.dumps(msg)
    header = bytes(f"{len(data):<{HEADER_SIZE}}", "utf-8")
    sock.send(header + data)

def send_text(sock, msg):
    data = bytes(msg, "utf-8")
    data += b' ' * (8 - len(data) % 8)
    header = bytes(f"{len(data):<{HEADER_SIZE}}", "utf-8")
    sock.send(header + data)

def send_json_obj(sock, obj):
    json_ = json.dumps(obj)
    send_text(sock, json_)

def send_request(sock, request: Request):
    send_json_obj(sock, request)

def respond(sock, code: StatusCode):
    send_text(sock, str(code))

def recv_obj(sock):
    msg_len = sock.recv(HEADER_SIZE)
    if len(msg_len) == 0:
        return None

    msg_len = int(msg_len.decode("utf-8").strip())
    data = b''
    while len(data) < msg_len:
        data += sock.recv(8)

    return pickle.loads(data)

def recv_text(sock):
    msg_len = sock.recv(HEADER_SIZE)
    if len(msg_len) == 0 or msg_len == b'':
        return None

    msg_len = int(msg_len.decode("utf-8").strip())
    data = b''
    while len(data) < msg_len:
        data += sock.recv(8)
    
    return data.decode("utf-8").strip()

def recv_json(sock):
    json_ = recv_text(sock)
    return json.loads(json_) if json_ is not None else None

def recv_request(sock):
    return recv_json(sock)

def recv_response(sock) -> StatusCode | None:
    code = recv_text(sock)
    return StatusCode(int(code)) if code is not None else None


