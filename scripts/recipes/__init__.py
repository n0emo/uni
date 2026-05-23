import os
from typing import List

from .data import DISCIPLINES
from .entry import Entry
from .gen import GenBuilder


def main() -> None:
    prepare_output_folder()

    with open(os.path.join("reports", "recipes.just"), "w") as f:
        f.write(generate_compile_all(DISCIPLINES))
        for discipline in DISCIPLINES:
            f.write(discipline.recipes)


def generate_compile_all(disciplines: List[Entry]) -> str:
    g = GenBuilder()

    dependencies = [f"({d.main_recipe})" for d in disciplines]
    dependencies = f"    {" \\\n    ".join(dependencies)}"
    g.gen("[parallel]")
    g.write("report-all: \\\n")
    g.gen(dependencies)
    g.line()

    return str(g)


def prepare_output_folder():
    os.makedirs("reports", exist_ok=True)
    with open(os.path.join("reports", ".gitignore"), "w") as f:
        f.write("*\n")
