# The sub-agent prompt

A sub-agent starts cold. It does not see this conversation, the survey you just did, the
course layout, or the decisions you made in phase 1. Everything it needs is in the prompt or
in a file the prompt tells it to read. Anything you leave out, it will invent.

Fill the template below in per lab and paste it as the `prompt`. Spawn with
`subagent_type: "general-purpose"` and `model: "sonnet"`, all labs in one message.

## Template

> You are migrating **one** university lab report to Typst. Write files only — you will not
> build, compile, or run anything, and another process verifies your work afterwards.
>
> **Your lab:** `<ABS_PATH_TO_LAB>` (lab number `<N>`, course `<COURSE_DIR_NAME>`)
>
> **Read these first, in this order:**
>
> 1. `<REPO_ROOT>/.claude/skills/migrate-lab/references/pandoc-cleanup.md` — the catalogue of
>    what pandoc emits and what each artefact must become. This is the bulk of your job.
> 2. `<REPO_ROOT>/.claude/skills/migrate-lab/references/build-tools.md`, the `<LANGUAGE>`
>    section only.
> 3. `<ABS_PATH_TO_REFERENCE_LAB>/report.typ` — an already-migrated lab in this same course.
>    Match its house style: heading depth, figure captions, section names, how it calls
>    `#code-file`. When this template and that file disagree, that file wins.
> 4. `<COURSE_ROOT>/common.typ` — already written; import it, never edit it.
>
> **State of your lab right now:** the directory has been renamed to `lab-<N>`, the sources
> are in `lab-<N>/src/`, `pandoc` has already produced `report.typ` from `<ORIGINAL_DOC>`,
> and its images are already flattened into `lab-<N>/assets/` and converted to PNG. There is
> nothing left to convert — start from the `report.typ` that is there.
>
> **Deliverable 1 — rewrite `report.typ` in place.** It must end up as:
>
> ```typ
> #import "../common.typ": *
>
> #show: report.with(number: "<N>", title: "<LAB_TITLE>")
>
> = Цель работы
> ...
> ```
>
> The three things that always have to happen, in your own words if the cleanup reference is
> ambiguous:
>
> - delete every scrap of the pandoc title page and the `Оценочный лист` grading sheet —
>   `common.typ` regenerates all of it, and a survivor means the PDF gets two title pages;
> - turn `#strong[Цели работы:]`-style fake headings into real `=` / `==` / `===` headings
>   nested to the report's actual structure;
> - replace every pasted program listing with `#code-file(read("./src/<file>"), name:
>   "<file>")`. Never paste program text into the report. The source files are:
>   `<LIST_OF_SOURCE_FILES>`.
>
> Also: retype mangled math as idiomatic Typst (`\(`, `\,`, `med med` are always wrong), wrap
> every bare `#image(...)` in a captioned `#figure`, rename `image3.png` to something
> meaningful and fix its path, and simplify pandoc's over-specified tables.
>
> **Two rules that are easy to break without noticing:**
>
> - **Do not reword the report's prose.** The Russian text is the student's own writing and
>   the department's own task statement. You are changing its *markup*, not its wording.
>   Keep first person (`моя функция`), keep the formal `Вы`/`Вам`, keep the phrasing even
>   where you would have written it better. The one thing you may fix is a transcription
>   error that is plainly a typo — `зачем вызовате` → `затем вызовите`, `узлаъ` → `узлах`,
>   a doubled word. If you change any wording, list every change when you report back.
> - **Show each file exactly once.** If you add a `#code-file(read(...))` listing for a data
>   file, delete the screenshot of that same file, and vice versa — never both. A screenshot
>   of *text or code that is already listed elsewhere in the report* is the listing
>   duplicated as a raster: drop it and keep the listing, which cannot drift from `src/`.
>   Screenshots of a running program (menus, console output, plots) are not duplicates and
>   stay.
>
> **Deliverable 2 — `<BUILD_CONFIG_FILE>`.** Write exactly this shape, adjusted to the
> sources present:
>
> ```<BUILD_CONFIG_LANGUAGE>
> <BUILD_CONFIG_SKELETON>
> ```
>
> Do not touch the course-root aggregator that references it — it already lists your lab.
>
> **Hard limits. Violating any of these breaks the parallel migration:**
>
> - Do not run a build or a compile. No `mise`, `cmake`, `make`, `typst`, `typstyle`,
>   `cargo`, `mvn`, `lein`, `uv`, `javac`, `gcc`. Not even to check your work.
> - Do not run any `git` command. No `git mv`, no `git add`, no commit.
> - Do not run `pandoc` or `soffice`. Their work is already done.
> - Do not create, edit, delete or rename **any** file outside `<ABS_PATH_TO_LAB>/`. Not
>   `common.typ`, not the course `mise.toml`, not the course `CMakeLists.txt`, not the root
>   `mise.toml`, not `.gitignore`. Other agents own the rest of this course right now.
> - Do not delete `<ORIGINAL_DOC>` or any `Задание*.docx` / `Варианты*.docx` in your lab
>   directory. They are the originals and they stay.
> - Do not edit the files in `src/`. You are migrating a report, not fixing old code.
> - Do not run `typstyle`. Formatting is done centrally at the end.
>
> **Report back:** the sections you produced, any figure or formula that did not survive
> conversion, anything in the original you could not make sense of, and any place you
> guessed. Do not claim it compiles — you have not compiled it, and saying so is worse than
> saying nothing.

## Filling it in

| Placeholder | Where it comes from |
| --- | --- |
| `<ABS_PATH_TO_LAB>` | absolute, not relative — the agent's cwd is not guaranteed |
| `<LAB_TITLE>` | the title off the pandoc title page, before you delete it |
| `<ORIGINAL_DOC>` | the exact filename, `ЛР4.docx` and friends |
| `<LANGUAGE>` | the discipline's one language, decided in phase 1 |
| `<ABS_PATH_TO_REFERENCE_LAB>` | an already-migrated lab in the same course; failing that, `bachelors/term-1/entrance-to-c/lab-1` |
| `<LIST_OF_SOURCE_FILES>` | `ls lab-N/src` — spell them out, do not make the agent guess |
| `<BUILD_CONFIG_FILE>` / `<BUILD_CONFIG_SKELETON>` | from `build-tools.md`, already specialized to this course |

Drop deliverable 2 and its skeleton entirely when the discipline is report-only (dead or
Windows-only toolchain), and say so explicitly in the prompt — otherwise the agent invents a
build.

## Failure modes seen in practice

- **The agent builds anyway.** Usually because the prompt said "make sure it compiles". Never
  write that. The hard-limits block has to be present verbatim.
- **The agent edits `common.typ`** to add a field it wanted. Catch it in phase 3 with
  `git status` — anything modified outside a `lab-N/` directory is an agent overstepping.
- **Two agents rename the same shared asset.** Only possible if phase 1 was skipped.
- **The agent pastes listings inline** because the original Word report had them inline. The
  `#code-file(read(...))` rule needs to be stated as a rule, not as an example.
- **The agent invents a lab title** when the placeholder was left unfilled.
- **The agent "improves" the Russian prose** — drops `моя`/`Вам`, lowercases `Вы`, tightens a
  sentence "for flow". Seen from all three agents on one course, so assume it by default:
  the no-rewording rule must be in the prompt, and phase 3 has to diff the prose against the
  pandoc commit rather than trust the agent's own summary of what it changed.
- **The agent shows one file twice** — a `books.txt` listing *and* an editor screenshot of
  `books.txt` — because the prompt asked separately for "rename every image" and "list the
  input data", and both rules fired on the same file. Stating the show-once rule fixes it.
