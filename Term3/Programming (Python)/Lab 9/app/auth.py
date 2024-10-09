from PySide6.QtCore import Qt
from PySide6.QtGui import QFont
from PySide6.QtWidgets import (QHBoxLayout, QLabel, QLineEdit, QPushButton,
                               QVBoxLayout, QWidget)

FONT_FAMILY = "Noto Sans"

class AuthWidget(QWidget):
    def __init__(self) -> None:
        super().__init__()

        primary_font = QFont(FONT_FAMILY, 32, QFont.Bold) # type: ignore
        secondary_font = QFont(FONT_FAMILY, 20)

        self.auth_label = QLabel("Авторизация")
        self.auth_label.setFont(primary_font)

        self.login_label = QLabel("Логин:")
        self.login_label.setFont(secondary_font)
        self.login_edit = QLineEdit()

        self.pass_label = QLabel("Пароль:")
        self.pass_label.setFont(secondary_font)
        self.pass_edit = QLineEdit()

        self.enter_button = QPushButton("Войти")
        self.enter_button.setFont(secondary_font)

        self.reg_button = QPushButton("Зарегистрироваться")
        self.reg_button.setFont(secondary_font)

        buttons_layout = QHBoxLayout()
        buttons_layout.addWidget(self.enter_button)
        buttons_layout.addWidget(self.reg_button)

        vbox = QVBoxLayout()
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
        vbox.setAlignment(Qt.AlignJustify) # type: ignore

        hbox = QHBoxLayout()
        hbox.addSpacing(30)
        hbox.addLayout(vbox)
        hbox.addSpacing(30)
        self.setLayout(hbox)
        

class RegWidget(QWidget):
    def __init__(self) -> None:
        super().__init__()

        primary_font = QFont(FONT_FAMILY, 32, QFont.Bold) # type: ignore
        secondary_font = QFont(FONT_FAMILY, 20)

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

        top_hbox = QHBoxLayout()
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
        vbox.setAlignment(Qt.AlignJustify) # type: ignore

        hbox = QHBoxLayout()
        hbox.addSpacing(30)
        hbox.addLayout(vbox)
        hbox.addSpacing(30)
        self.setLayout(hbox)
        
