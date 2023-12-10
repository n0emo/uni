# pyright: reportGeneralTypeIssues=false

import sys
import json
import os
import hashlib
from PySide6.QtCore import Qt, Slot
from PySide6.QtGui import QFont
from PySide6.QtWidgets import QHBoxLayout, QMessageBox, QPushButton, QVBoxLayout, QLabel, QLineEdit, QMainWindow, QWidget, QApplication

PASS_FILE = "passwords.json"


def pass_hash(login: str, pass_: str) -> str:
    return hashlib.sha256((pass_ + login).encode()).hexdigest()


def create_pass_file_if_dont_exists():
    if os.path.exists(PASS_FILE):
        return
    
    with open(PASS_FILE, 'w') as file:
        file.write("{}")


def add_pass(login: str, pass_: str) -> None:
    create_pass_file_if_dont_exists()

    with open(PASS_FILE, 'r') as file:
        passwords = json.load(file)

    passwords[login] = pass_hash(login, pass_)

    with open(PASS_FILE, 'w') as file:
        json.dump(passwords, file)

def check_pass(login: str, pass_: str) -> bool:
    hash_ = pass_hash(login, pass_)

    with open(PASS_FILE, 'r') as file:
        passwords = json.load(file)
    
    return login in passwords and passwords[login] == hash_


def check_login(login: str):
    with open(PASS_FILE, 'r') as file:
        passwords = json.load(file)

    return login in passwords


class AuthWidget(QWidget):
    def __init__(self) -> None:
        super().__init__()

        vbox = QVBoxLayout()

        primary_font = QFont("Times", 32, QFont.Bold) 
        self.auth_label = QLabel("Авторизация")
        self.auth_label.setFont(primary_font)

        secondary_font = QFont("Times", 20)
        self.login_label = QLabel("Логин:")
        self.login_label.setFont(secondary_font)
        self.login_edit = QLineEdit()

        self.pass_label = QLabel("Пароль:")
        self.pass_label.setFont(secondary_font)
        self.pass_edit = QLineEdit()

        buttons_layout = QHBoxLayout()
        self.enter_button = QPushButton("Войти")
        self.enter_button.setFont(secondary_font)

        self.reg_button = QPushButton("Зарегистрироваться")
        self.reg_button.setFont(secondary_font)

        buttons_layout.addWidget(self.enter_button)
        buttons_layout.addWidget(self.reg_button)

        vbox.addWidget(self.auth_label)
        vbox.addStretch(1)

        vbox.addWidget(self.login_label)
        vbox.addWidget(self.login_edit)
        vbox.addStretch(1)

        vbox.addWidget(self.pass_label)
        vbox.addWidget(self.pass_edit)
        vbox.addStretch(1)

        vbox.addLayout(buttons_layout)

        vbox.addSpacing(30)

        vbox.setAlignment(Qt.AlignJustify) 

        hbox = QHBoxLayout()

        hbox.addSpacing(30)
        hbox.addLayout(vbox)
        hbox.addSpacing(30)
        self.setLayout(hbox)
        

class RegWidget(QWidget):
    def __init__(self) -> None:
        super().__init__()

        primary_font = QFont("Times", 32, QFont.Bold)
        secondary_font = QFont("Times", 20)

        
        top_hbox = QHBoxLayout()

        self.reg_label = QLabel("Регистрация")
        self.reg_label.setFont(primary_font)

        self.back_button = QPushButton("Назад")
        self.back_button.setFont(secondary_font)

        self.login_label = QLabel("Логин:")
        self.login_label.setFont(secondary_font)
        self.login_edit = QLineEdit()

        self.pass_label = QLabel("Пароль:")
        self.pass_label.setFont(secondary_font)
        self.pass_edit = QLineEdit()

        self.confirm_label = QLabel("Подтвердите пароль:")
        self.confirm_label.setFont(secondary_font)
        self.confirm_edit = QLineEdit()


        self.reg_button = QPushButton("Зарегистрироваться")
        self.reg_button.setFont(secondary_font)

        top_hbox.addWidget(self.back_button)
        top_hbox.addWidget(self.reg_label)

        vbox = QVBoxLayout()

        vbox.addLayout(top_hbox)
        vbox.addStretch(1)

        vbox.addWidget(self.login_label)
        vbox.addWidget(self.login_edit)
        vbox.addStretch(1)

        vbox.addWidget(self.pass_label)
        vbox.addWidget(self.pass_edit)
        vbox.addStretch(1)

        vbox.addWidget(self.confirm_label)
        vbox.addWidget(self.confirm_edit)
        vbox.addStretch(1)

        vbox.addWidget(self.reg_button)

        vbox.addSpacing(30)

        vbox.setAlignment(Qt.AlignJustify)

        hbox = QHBoxLayout()

        hbox.addSpacing(30)
        hbox.addLayout(vbox)
        hbox.addSpacing(30)
        self.setLayout(hbox)
        

class KazakhstanWidget(QWidget):
    def __init__(self) -> None:
        super().__init__()

        primary_font = QFont("Times", 32, QFont.Bold)
        secondary_font = QFont("Times", 20)

        self.Kazakhstan_label = QLabel("Добро пожаловать в Казахстан!")
        self.hymn_label = QLabel("""
            Жаралған намыстан қаһарман халықпыз,
            Азаттық жолында жалындап жаныппыз.
            Тағдырдың тезінен, тозақтың өзінен
            Аман-сау қалыппыз, аман-сау қалыппыз.

            Қайырмасы:
            Еркіндік қыраны шарықта,
            Елдікке шақырып тірлікте!
            Алыптың қуаты – халықта,
            Халықтың қуаты – бірлікте!

            Ардақтап анасын, құрметтеп данасын,
            Бауырға басқанбыз баршаның баласын.
            Татулық, достықтың киелі бесігі
            Мейірбан Ұлы Отан, қазақтың даласы!

            Қайырмасы

            Талайды өткердік, өткенге салауат,
            Тәуліктік сәулетті, келешек ғаламат!
            Ар-ождан, ана тіл, өнеге-салтымыз,
            Ерлік те, елдік те ұрпаққа аманат!

            Қайырмасы[3]
        """)

        self.Kazakhstan_label.setFont(primary_font)
        self.hymn_label.setFont(secondary_font)

        self.hymn_label.setAlignment(Qt.AlignHCenter)

        vbox = QVBoxLayout()
        vbox.addWidget(self.Kazakhstan_label)
        vbox.addWidget(self.hymn_label)
        self.setLayout(vbox)

class MainWindow(QMainWindow):
    def __init__(self) -> None:
        super().__init__()

        self.setGeometry(0, 0, 300, 450)
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
    def auth(self):
        login = self.centralWidget().login_edit.text() 
        password = self.centralWidget().pass_edit.text() 
        if(check_pass(login, password)):
            self.switch_to_Kazakhstan()
        else:
            QMessageBox().warning(
                self, "",
                "Неправильный логин или пароль! Попробуйте снова...",
                QMessageBox.Ok, 
                QMessageBox.Ok 
            )
    
    @Slot()
    def reg(self):
           
        login = self.centralWidget().login_edit.text() 
        password = self.centralWidget().pass_edit.text() 
        confirm = self.centralWidget().confirm_edit.text() 

        if login == '':
            self.warning("Логин не должен быть пустым.")
            return

        if password == '':
            self.warning("Пароль не должен быть пустым")
            return


        if password != confirm:
            self.warning("Пароли не совпадают!\nПовторите ввод.")
            return

        if check_login(login):
            QMessageBox().warning(
                self, "",
                "Данный логин уже существует.\nПопробуйте другой",
                QMessageBox.Ok, 
                QMessageBox.Ok 
            )
            return

        add_pass(login, password)
        QMessageBox().information(
            self, "",
            "Вы успешно зарегистрированы!\nИспользуйте ваш новый логин для входа.",
            QMessageBox.Ok, 
            QMessageBox.Ok 
        )
        self.switch_to_auth()


    def warning(self, text: str):
        QMessageBox().warning(
            self, "",
            text,
            QMessageBox.Ok, 
            QMessageBox.Ok 
        )

    @Slot()
    def switch_to_Kazakhstan(self):
        self.setCentralWidget(KazakhstanWidget())
        

if __name__ == "__main__":
    app = QApplication()
    window = MainWindow()
    window.show()
    sys.exit(app.exec())
