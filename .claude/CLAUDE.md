# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository purpose

This is a personal archive of university coursework (Albert Shefner), organized by degree and
then by term: `bachelors/term-1` … `bachelors/term-8`, with `masters/` alongside it for later
work. Inside a term, each course gets its own kebab-case directory (e.g.
`bachelors/term-7/os`, `bachelors/term-5/programming-java`) and each lab/practice/course
project its own subdirectory. `bachelors/thesis` and `bachelors/pre-graduation-practice` are
the bachelor's thesis and pre-graduation practice report, both written in Typst.

Because subdirectories are independent (C via CMake, Rust via Cargo workspaces, Java/Clojure,
Qt, assembly, etc.), always check for a local `mise.toml`, `CMakeLists.txt`, `Cargo.toml`,
`project.clj`, `justfile`, or `README.md` inside the specific lab directory you're working in
rather than assuming a repo-wide convention.

## Toolchain and tasks (mise)

The repo root is a mise monorepo root (`monorepo_root = true` in `mise.toml`). The root config:

- pins the shared toolchain under `[tools]` — `cmake`, `ninja`, `typst`, `typstyle`;
- lists the projects with their own config under `[monorepo].config_roots`;
- defines reusable `[task_templates]` that per-project tasks `extends`: `mkdir`,
  `cmake:configure`, `cmake:build`, `typst:compile`.

Run tasks from inside the project directory (`mise tasks` lists what is available there, `mise
run <task>` runs one). Registered config roots and their tasks:

| Project | Tasks |
| --- | --- |
| `bachelors/thesis` | `thesis`, `presentation`, `build`, `fmt` |
| `bachelors/pre-graduation-practice` | `build`, `fmt` |
| `bachelors/term-1/entrance-to-c` | `configure`, `build`, `report <num>`, `report-all` |
| `bachelors/term-8/human-machine-interaction` | `report <num>`, `report-all` |
| `bachelors/term-8/metrology-standardization-certification` | `report <num>`, `report-all` |

When adding a course, add its directory to `config_roots` in the root `mise.toml` and give it
a local `mise.toml`; prefer `extends` on a root task template over repeating a raw `typst
compile` or `cmake` invocation. Declare `sources`/`outputs` on a task so mise can skip it when
nothing changed.

Lab reports compile to a gitignored `reports/` inside their course directory.

### Thesis layout

`thesis.typ` includes `chapters/*.typ` and `appendixes.typ` (which includes `appendixes/*.typ`);
`presentation.typ` includes `presentation/*.typ` slide sections and compiles to
`presentation.pdf`; `style.typ` and `bibliography.yaml` are shared across both. Format Typst
sources with the project's `fmt` task (`typstyle --inplace --line-width 100 --wrap-text .`).

### Legacy justfiles

The root `justfile` and its generator under `scripts/recipes/` predate the mise migration and
still reference the pre-move `Term<N>/` paths, so their recipes no longer resolve — use mise
instead. A few labs (`bachelors/term-7/information-security/lab-2-*`,
`bachelors/term-7/reliability`) keep their own unrelated `justfile` for building that lab.

## Other conventions

- C/C++ code is formatted per `.clang-format` (BasedOnStyle: Microsoft) at the repo root.
- Binary/office formats (`*.pdf`, `*.docx`, `*.odt`, `*.png`, `*.jpg`) are tracked via Git LFS
  (see `.gitattributes`); `*.ipynb` is excluded from GitHub language detection.
- Course report directories often contain a `Шаблон отчёта.docx`/`.odt` — the department's
  report template — alongside the actual lab write-ups; these are reference material, not
  generated output.
