import socket

from app.auth import AuthWidget, RegWidget
from app.chat import ChatWidget
from app.messagebox import info, warning
from models.status import StatusCode
from networking.clientside import authorize, register
from networking.common import ADDRESS
from PySide6.QtCore import Slot
from PySide6.QtWidgets import QMainWindow


class ClientWindow(QMainWindow):
    def __init__(self) -> None:
        super().__init__()
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.connect(ADDRESS)
        
        self.sock = sock;

        self.setGeometry(0, 0, 300, 450)
        self.setWindowTitle("Chat")
        self.switch_to_auth()
    
    @Slot()
    def switch_to_auth(self):
        auth_widget = AuthWidget()
        auth_widget.reg_button.clicked.connect(self.switch_to_reg)
        auth_widget.enter_button.clicked.connect(self.auth)
        
        self.setCentralWidget(auth_widget)

    @Slot()
    def switch_to_reg(self):
        reg_widget = RegWidget()
        reg_widget.reg_button.clicked.connect(self.reg)
        reg_widget.back_button.clicked.connect(self.switch_to_auth)
        self.setCentralWidget(reg_widget)

    @Slot()
    def switch_to_chat(self):
        chat_widget = ChatWidget(self.sock)
        self.setCentralWidget(chat_widget)

    @Slot()
    def auth(self):
        auth_widget = self.centralWidget()
        assert isinstance(auth_widget, AuthWidget)

        login = auth_widget.login_edit.text() 
        password = auth_widget.pass_edit.text()

        if login == "" or password == "":
            warning(self, "Логин или пароль не должны быть пустыми.")
            return

        result = authorize(self.sock, login, password)
        if result == StatusCode.OK:
            print("Successfully logged in.")
            self.setWindowTitle("Chat - " + login)
            self.switch_to_chat()
        else:
            warning(self, "Неправильный логин или пароль! Попробуйте снова...")
    
    @Slot()
    def reg(self):
        reg_widget = self.centralWidget()
        assert isinstance(reg_widget, RegWidget)
           
        login = reg_widget.login_edit.text() 
        password = reg_widget.pass_edit.text() 
        confirm = reg_widget.confirm_edit.text() 

        if login == '':
            warning(self, "Логин не должен быть пустым.")
            return

        if password == '':
            warning(self, "Пароль не должен быть пустым")
            return

        if password != confirm:
            warning(self, "Пароли не совпадают!\nПовторите ввод.")
            return


        result = register(self.sock, login, password)
        if result == StatusCode.CONFLICT:
            warning(self, "Данный логин уже существует.\nПопробуйте другой")
            return
        
        elif result == StatusCode.CREATED:
            info(self,
                "Вы успешно зарегистрированы!\nИспользуйте ваш новый логин для входа."
            )
            self.switch_to_auth()

    
