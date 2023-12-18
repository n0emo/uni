from PySide6.QtWidgets import QMessageBox


def warning(self, text: str) -> None:
    QMessageBox().warning(
        self, "",
        text,
        QMessageBox.Ok, # type: ignore
        QMessageBox.Ok  # type: ignore
    )

def info(parent, text: str) -> None:
    QMessageBox().information(
        parent, "",
        text,
        QMessageBox.Ok, # type: ignore
        QMessageBox.Ok  # type: ignore
    )
    
