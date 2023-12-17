import os

from app.clientwindow import ClientWindow
from PySide6.QtWidgets import QApplication

if __name__ == "__main__":
    app = QApplication()
    window = ClientWindow()
    window.show()

    os._exit(app.exec())
