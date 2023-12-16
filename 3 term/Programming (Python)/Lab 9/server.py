import socket
from networking.serverside import ClientSocketThread
from networking.common import ADDRESS


MESSAGES_FILE = "messages.pkl"
if __name__ == "__main__":
    clients = {}
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.bind(ADDRESS)
    sock.listen(5)

    while True:
        client_sock, address = sock.accept();
        ClientSocketThread(client_sock, address, clients).start()
