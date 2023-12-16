from threading import Lock, Thread
from PySide6.QtWidgets import (
    QHBoxLayout,
    QLineEdit,
    QPushButton,
    QVBoxLayout,
    QWidget,
    QTextEdit
)
from PySide6.QtCore import QTimer, Qt, Slot

from app.messagebox import warning, info

from models.message import Message
from models.status import StatusCode

from networking.common import recv_response
from networking.clientside import get_new_messages, send_message


class MessageEnterWidget(QWidget):
    def __init__(self):
        super().__init__()
        layout = QHBoxLayout()
        
        self.line_edit = QLineEdit()
        self.send_button = QPushButton()

        self.send_button.setText("Отправить")

        layout.addWidget(self.line_edit)
        layout.addWidget(self.send_button)

        self.setLayout(layout)

    @property
    def text(self):
        return self.line_edit.text()

    def clear(self):
        self.line_edit.clear()

    @property
    def send_pressed(self):
        return self.send_button.clicked


class ChatWidget(QWidget):
    def __init__(self, sock):
        super().__init__()

        self.sock = sock

        self.area_lock = Lock()

        layout = QVBoxLayout()

        self.messages_area = QTextEdit("<html></html>")
        self.messages_area.setAlignment(Qt.AlignBottom) # type: ignore
        self.messages_area.setReadOnly(True)
        self.messages_area.ensureCursorVisible()
        self.message_enter_field = MessageEnterWidget()
        self.message_enter_field.send_pressed.connect(self.send_message)

        layout.addWidget(self.messages_area)
        layout.addWidget(self.message_enter_field)

        self.setLayout(layout)
        
        self.lock = Lock()

        self.timer = QTimer(self)
        self.timer.timeout.connect(self.update_messages)
        self.timer.start(300)

    @Slot()
    def update_messages(self):
        with self.lock:
            messages = get_new_messages(self.sock)
            if messages is None:
                warning(self, "Ошибка при получении сообщений")
                return

            for message in messages:
                self.append_message(message)


    def append_message(self, message: Message):
        r = format(message.color.r, '02x')
        g = format(message.color.g, '02x')
        b = format(message.color.b, '02x')
        msg_html = f'[{message.time.hour}:{message.time.minute}] ' + \
            f'<span style="color:#{r}{g}{b};">{message.user}:</span> ' +\
            message.text
        self.messages_area.append(msg_html)

    def send_message(self):
        message = self.message_enter_field.text.strip()
        self.message_enter_field.clear()

        if len(message) == 0:
            return
        
        with self.lock:
            response = send_message(self.sock, message)
            if response is not StatusCode.OK:
                self.timer.stop()
                warning(self, "Ошибка при отправке сообщения")

