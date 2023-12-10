# pyright: reportGeneralTypeIssues=false
import enum
import random
import sys
from typing import List
from PySide6.QtWidgets import (
    QWidget,
    QPushButton,
    QMainWindow,
    QApplication,
)
from PySide6.QtCore import QPoint, QRect, QSize, QTimer, Qt, Slot
from PySide6.QtGui import (
    QKeyEvent,
    QPaintEvent,
    QPen,
    QPainter,
    QPixmap,
)


class Direction(enum.IntEnum):
    UP = 0,
    DOWN = 1,
    LEFT = 2,
    RIGHT = 3


class Point:
    x: int
    y: int

    def __init__(self, x: int, y: int) -> None:
        self.x = x
        self.y = y

    def __eq__(self, other: "Point") -> bool:
        return self.x == other.x and self.y == other.y

class Snake:
    segments: List[Point]
    direction: Direction

    def __init__(self, x: int, y: int, direction: Direction) -> None:
        self.direction = direction
        self.segments = [Point(x, y)]

    @property
    def head(self):
        return self.segments[0]

    def move(self):
        self.grow()
        self.segments.pop()

    def grow(self):
        new_head = Point(self.head.x, self.head.y)
        match self.direction:
            case Direction.UP:
                new_head.y -= 1
            case Direction.DOWN:
                new_head.y += 1
            case Direction.LEFT:
                new_head.x -= 1
            case Direction.RIGHT:
                new_head.x += 1
        self.segments.insert(0, new_head)


class Game:
    snake: Snake
    cells_x: int
    cells_y: int
    apple: Point
    running: bool

    def __init__(self, cells_x: int, cells_y: int) -> None:
        self.snake_direction = Direction.RIGHT

        self.snake = Snake(5, 5, self.snake_direction)
        for _ in range(3):
            self.snake.grow()

        self.cells_x = cells_x
        self.cells_y = cells_y
        self.apple = Point(-1, -1)
        self.running = True
        self.spawn_apple()

    def update(self) -> None:
        if not self.running:
            return
        self.snake.direction = self.snake_direction
        head = self.snake.head
        if head == self.apple:
            self.spawn_apple()
            self.snake.grow()
        else:
            self.snake.move()

        self.snake.head.x %= self.cells_x
        self.snake.head.y %= self.cells_y

        if self.snake.head in self.snake.segments[1:]:
            self.running = False

    def change_direction(self, direction: Direction) -> None:
        if direction == Direction.DOWN and self.snake.direction != Direction.UP:
            self.snake_direction = direction
        if direction == Direction.UP and self.snake.direction != Direction.DOWN:
            self.snake_direction = direction
        if direction == Direction.LEFT and self.snake.direction != Direction.RIGHT:
            self.snake_direction = direction
        if direction == Direction.RIGHT and self.snake.direction != Direction.LEFT:
            self.snake_direction = direction

    def spawn_apple(self):
        while True:
            self.apple = Point(
                random.randint(0, self.cells_x - 1),
                random.randint(0, self.cells_y - 1)
            )
            if self.apple not in self.snake.segments: 
                break
            

class SnakePaint(QWidget):
    def __init__(self, width: int, height: int, segment_width: int) -> None:
        super().__init__()
        self.cell_width: int = segment_width
        self.cell_size = QSize(self.cell_width, self.cell_width)
        self.setFixedSize(width, height)

        self.pixmap = QPixmap(self.size())
        self.pixmap.fill(Qt.white) 

        self.pen = QPen()
        self.pen.setWidth(16)
    
    def paintEvent(self, _: QPaintEvent) -> None:
        with QPainter(self) as painter:
            painter.drawPixmap(0, 0, self.pixmap) 

    def draw_game(self, game: Game):
        def crd(coord):
            return self.cell_width * coord

        self.pixmap.fill(Qt.white)

        with QPainter(self.pixmap) as painter:
            apple_rect = QRect(
                QPoint(crd(game.apple.x), crd(game.apple.y)),
                self.cell_size
            )
            painter.fillRect(apple_rect, Qt.red)

            for segment in game.snake.segments[1:]:
                rect = QRect(
                    QPoint(crd(segment.x), crd(segment.y)),
                    self.cell_size
                )
                painter.fillRect(rect, Qt.darkGreen)
            
            head_rect = QRect(
                QPoint(crd(game.snake.head.x), crd(game.snake.head.y)),
                self.cell_size
            )
            painter.fillRect(head_rect, Qt.black)

        self.repaint()


class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()
        self.cells_x = 25
        self.cells_y = 20
        self.cell_width = 50

        width = self.cells_x * self.cell_width
        height = self.cells_y * self.cell_width

        self.setGeometry(0, 0, width, height)
        self.setWindowTitle("Snake.py")
        
        self.button = QPushButton()
        self.button.setText("xd")

        self.snakepaint = SnakePaint(width, height, 50)
        self.setCentralWidget(self.snakepaint)

        self.timer = QTimer(self)
        self.timer.timeout.connect(self.update)

        self.game = Game(self.cells_x, self.cells_y)

    def run(self):
        self.timer.start(100)
        pass

    @Slot()
    def update(self):
        self.game.update()
        self.snakepaint.draw_game(self.game)

    def keyPressEvent(self, event: QKeyEvent) -> None:
        match event.key():
            case Qt.Key_Up:
                self.game.change_direction(Direction.UP)
            case Qt.Key_Down:
                self.game.change_direction(Direction.DOWN)
            case Qt.Key_Left:
                self.game.change_direction(Direction.LEFT)
            case Qt.Key_Right:
                self.game.change_direction(Direction.RIGHT)


if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = MainWindow()
    window.show()
    window.run()
    sys.exit(app.exec())

