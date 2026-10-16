from app.messagebox import warning
from models.message import Message
from models.status import StatusCode
from networking.clientside import get_new_messages, send_message
from PySide6.QtCore import Qt, QTimer, Slot
from PySide6.QtGui import QFont
from PySide6.QtWidgets import (QHBoxLayout, QLineEdit, QPushButton, QTextEdit,
                               QVBoxLayout, QWidget)

FONT_FAMILY = "Noto Sans"

class MessageEnterWidget(QWidget):
    def __init__(self, sock, timer):
        super().__init__()

        self.sock = sock
        self.timer = timer

        self.init_ui()

        self.send_button.clicked.connect(self.send_message)
        

    def init_ui(self):
        self.line_edit = QLineEdit()
        self.line_edit.setFont(QFont(FONT_FAMILY, 14))

        self.send_button = QPushButton()
        self.send_button.setFont(QFont(FONT_FAMILY, 14))

        self.send_button.setText("Отправить")
        self.send_button.setFont(QFont(FONT_FAMILY, 14))

        layout = QHBoxLayout()
        layout.addWidget(self.line_edit)
        layout.addWidget(self.send_button)
        self.setLayout(layout)


    @Slot()
    def send_message(self):
        message = self.line_edit.text().strip()
        self.line_edit.clear()

        if len(message) == 0:
            return
        
        response = send_message(self.sock, message)
        if response is not StatusCode.OK:
            self.timer.stop()
            warning(self, "Ошибка при отправке сообщения")


class ChatWidget(QWidget):
    def __init__(self, sock):
        super().__init__()

        self.sock = sock

        self.timer = QTimer(self)
        self.timer.timeout.connect(self.update_messages)
        self.timer.start(300)

        self.init_ui()


    def init_ui(self):
        layout = QVBoxLayout()

        self.messages_area = QTextEdit("<html></html>")
        self.messages_area.setAlignment(Qt.AlignBottom) # type: ignore
        self.messages_area.setReadOnly(True)
        self.messages_area.ensureCursorVisible()
        self.messages_area.setFont(QFont(FONT_FAMILY, 14))

        self.message_enter_field = MessageEnterWidget(self.sock, self.timer)
        self.message_enter_field.setFont(QFont(FONT_FAMILY, 14))

        layout.addWidget(self.messages_area)
        layout.addWidget(self.message_enter_field)

        self.setLayout(layout)


    @Slot()
    def update_messages(self):
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
