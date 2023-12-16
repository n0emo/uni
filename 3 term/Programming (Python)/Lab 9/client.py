import os
from PySide6.QtWidgets import QApplication
from app.clientwindow import ClientWindow


if __name__ == "__main__":
    app = QApplication()
    window = ClientWindow()
    window.show()
    os._exit(app.exec())

