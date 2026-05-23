from abc import ABC, abstractmethod
from dataclasses import dataclass
from os.path import dirname, join
from typing import List, override

from .gen import GenBuilder


class Entry(ABC):
    @property
    @abstractmethod
    def main_recipe(self) -> str: ...

    @property
    @abstractmethod
    def recipes(self) -> str: ...


@dataclass
class LabsEntry(Entry):
    term: int
    name: str
    short_name: str
    labs: List[str]

    @property
    @override
    def main_recipe(self) -> str:
        return f"report-{self.term}-{self.short_name}-all"

    @property
    @override
    def recipes(self) -> str:
        group = f"{self.term}-{self.short_name}"

        g = GenBuilder()
        for lab in self.labs:
            generate_recipes(
                g=g,
                group=group,
                input=join(f"Term{self.term}", self.name, f"lab-{lab}", "report.typ"),
                output=join("reports", f"Term{self.term}", self.name, f"lab-{lab}.pdf"),
                suffix=f"{self.term}-{self.short_name}-{lab}",
            )

        dependencies = " ".join(
            [f"(report-{self.term}-{self.short_name}-{dep})" for dep in self.labs]
        )
        g.gen(group_attribute(group))
        g.gen("[parallel]")
        g.gen(f"{self.main_recipe}: {dependencies}")
        g.line()

        return str(g)


@dataclass
class ThesisEntry(Entry):
    path: str
    name: str

    @property
    @override
    def main_recipe(self) -> str:
        return f"report-{self.name}-thesis"

    @property
    @override
    def recipes(self) -> str:
        g = GenBuilder()
        generate_recipes(
            g=g,
            group="{self.name}-thesis",
            input=join(self.path, f"thesis.typ"),
            output=join("reports", self.path, f"thesis.pdf"),
            suffix=f"{self.name}-thesis",
        )
        return str(g)


@dataclass
class PracticeEntry(Entry):
    path: str
    name: str

    @property
    @override
    def main_recipe(self) -> str:
        return f"report-practice-{self.name}"

    @property
    @override
    def recipes(self) -> str:
        g = GenBuilder()
        generate_recipes(
            g=g,
            group=f"practice-{self.name}",
            input=join(self.path, "practice.typ"),
            output=join("reports", self.path, "practice.pdf"),
            suffix=f"practice-{self.name}",
        )
        return str(g)


def generate_recipes(
    g: GenBuilder,
    group: str,
    input: str,
    output: str,
    suffix: str,
) -> None:
    output_dir = dirname(output)
    mkdir_command = f"    @mkdir -p '{output_dir}'"
    group = group_attribute(group)

    g.gen(group)
    g.gen(f"report-{suffix}:")
    g.gen(mkdir_command)
    g.gen(
        " \\\n".join(
            [
                "    typst compile",
                "        --root .",
                f"        '{input}'",
                f"        '{output}'",
            ]
        )
    )
    g.line()

    g.gen(group)
    g.gen(f"watch-{suffix}:")
    g.gen(mkdir_command)
    g.gen(
        " \\\n".join(
            [
                "    typst watch",
                "        --root .",
                f"        '{input}'",
                f"        '{output}'",
            ]
        )
    )
    g.line()

    g.gen(group)
    g.gen(f"preview-{suffix}:")
    g.gen(mkdir_command)
    g.gen(
        " \\\n".join(
            [
                "    tinymist preview",
                "        --root .",
                "        --invert-colors=auto",
                f"        '{input}'",
            ]
        )
    )
    g.line()


def group_attribute(name: str) -> str:
    return f'[group("reports-{name}")]'
