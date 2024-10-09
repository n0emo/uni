import socket

from networking.common import ADDRESS
from networking.serverside import ClientSocketThread

if __name__ == "__main__":
    clients = {}
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.bind(ADDRESS)
    sock.listen(5)

    while True:
        client_sock, address = sock.accept();
        ClientSocketThread(client_sock, address, clients).start()
