from dataclasses import dataclass
from itertools import product
import numpy as np

@dataclass(frozen=True)
class Trapezoid:
    a: float
    b: float
    c: float
    d: float

    def __call__(self, x):
        x = np.asarray(x, dtype=float)
        left = np.ones_like(x) if self.a == self.b else (x-self.a)/(self.b-self.a)
        right = np.ones_like(x) if self.c == self.d else (self.d-x)/(self.d-self.c)
        return np.clip(np.minimum(np.minimum(left, right), 1), 0, 1)

# Shoulder functions cover the boundaries without division by zero.
membership = {
    "power": {"low": Trapezoid(0,0,600,800), "medium": Trapezoid(600,900,1400,1600),
              "high": Trapezoid(1400,1800,6000,6000)},
    "time": {"short": Trapezoid(0,0,1.5,2), "medium": Trapezoid(1.5,2,3,4),
             "long": Trapezoid(3,5,15,15)},
    "noise": {"quiet": Trapezoid(0,0,40,47), "medium": Trapezoid(40,47,50,55),
              "loud": Trapezoid(50,55,70,70)},
}
domains = {"power": (0,6000), "time": (0,15), "noise": (0,70)}
output_terms = {"low": Trapezoid(0,0,20,40), "medium": Trapezoid(20,40,60,80),
                "high": Trapezoid(60,80,100,100)}
# All 3 x 3 x 3 combinations, ordered from least to most favourable.
rules = []
for p, t, n in product(range(3), repeat=3):
    score = p + t + n
    rating = "low" if score <= 1 else "high" if score >= 4 else "medium"
    rules.append((list(membership["power"])[p], list(membership["time"])[t],
                  ["loud", "medium", "quiet"][n], rating))
