import db
from model import *

if __name__ == "__main__":
    db.add_painting_order(PaintingOrder(5, 2000, 160, 120))
