# Phase 3 — verifying a fanned-out migration

Everything the sub-agents wrote is unbuilt draft text. Nothing in the course has been
compiled since phase 1. Work through this in order; the cheap checks catch the embarrassing
failures before the slow ones run.

## 0. Did anyone overstep?

Before compiling anything:

```bash
cd bachelors/term-N/<course>
git status --short .
```

Every modified or new path must be inside a `lab-N/` directory, or be one of the shared files
*you* wrote in phase 1. A modified `common.typ`, course `mise.toml`, `CMakeLists.txt` or root
`mise.toml` means an agent edited shared state — `git diff` it, and revert it unless the
change is genuinely right:

```bash
git checkout -- common.typ
```

Also confirm nothing was deleted that should not have been:

```bash
git status --short . | grep '^ D'
ls lab-*/ЛР*.docx lab-*/ЛР*.odt 2>/dev/null
```

The originals are the source of truth. If one is gone, restore it.

## 1. Reports, all at once

```bash
mise run report-all
```

`report-all` stops at the first failure, so expect to run it several times. Typical errors and
their fixes:

| Error | Cause | Fix |
| --- | --- | --- |
| `file not found (searched at lab-N/src/...)` | `#code-file(read(...))` path wrong, or the file is named differently | `ls lab-N/src` and correct the path and `name:` |
| `file not found ... assets/imageN.wmf` | agent kept pandoc's path after you converted to PNG | point at the `.png` |
| `unknown variable: report` | missing or wrong `#import "../common.typ": *` | add it |
| `unexpected end of block` in math | retyped math left unbalanced | rewrite the formula |
| `expected content, found ...` around a table | agent half-simplified a pandoc table | rebuild that `#table` |
| a second title page in the PDF | pandoc front matter survived | delete it from `report.typ` |

Fix these yourself. Do not re-spawn an agent for a one-line path fix.

## 2. Code, all at once

```bash
mise run build
```

| Error | Fix |
| --- | --- |
| `add_subdirectory given source "lab-N" which is not an existing directory` | phase 1 missed a rename |
| `Cannot find source file: src/main.c` | lab `CMakeLists.txt` names a file that is not there |
| `undefined reference to sqrt` / `pow` | add `target_link_libraries(lab-N m)` |
| a lab whose C sources genuinely do not compile | it is old coursework — fix it minimally, or drop it from the aggregator and say so |
| Cargo `failed to load manifest for workspace member` | lab `Cargo.toml` missing or misnamed package |
| Maven `Could not find artifact ... :lab-N` | lab not listed in the parent `<modules>` |

A lab that cannot be made to build is a legitimate outcome for archived coursework. Remove it
from the aggregator, leave its sources and report in place, and name it in the final report.

## 3. What no compiler catches

Per lab, and this is the part that actually needs reading:

```bash
git diff <pandoc-commit> -- lab-N/report.typ
```

Look for:

- **a surviving grading sheet** — grep the course for it:
  ```bash
  grep -rln 'Оценочный лист\|ФЕДЕРАЛЬНОЕ АГЕНСТВО\|Санкт-Петербург' lab-*/report.typ
  ```
  Any hit is boilerplate that must be deleted.
- **fake headings left as bold text**:
  ```bash
  grep -rn '#strong\[' lab-*/report.typ
  ```
  A `#strong[...]` alone on a line is a heading the agent missed. Inline emphasis inside a
  sentence is fine.
- **pasted listings** — a `report.typ` much longer than its neighbours, or a `#block` full of
  program text. Every lab with sources should have at least one `#code-file(read(...))`:
  ```bash
  for d in lab-*/; do printf '%s ' "$d"; grep -c 'code-file' "$d/report.typ"; done
  ```
- **leftover pandoc escaping** — `\(`, `\,`, `\_`, `med med` inside `$...$`.
- **reworded prose** — agents "improve" the Russian text unprompted. Do not trust an agent's
  own account of what it changed; read the prose diff:
  ```bash
  git diff <pandoc-commit> -- lab-N/report.typ | grep '^[-+]' | grep -v 'code-file\|image(\|figure\|^[-+][-+]'
  ```
  Restore the author's wording — first person (`моя функция`), the formal `Вы`/`Вам`, the
  original phrasing — and keep only fixes to plain transcription typos.
- **one file shown twice** — a `#code-file` listing of a data file *and* a screenshot of the
  same file. Keep the listing, drop the screenshot, and remember to delete the now-unused
  PNG (and `rmdir assets/` if it empties):
  ```bash
  for d in lab-*/; do
    for f in $(grep -oE 'read\("\./src/[^"]+\.txt"' "$d/report.typ" 2>/dev/null \
               | grep -oE '[^/"]+\.txt'); do
      grep -oE 'image\("[^"]+"' "$d/report.typ" | grep -q "${f%.txt}" \
        && echo "DUPLICATE: $d shows $f as both a listing and a screenshot"
    done
  done
  ```

  Note the inner `grep -oE '[^/"]+\.txt'` has no `$` anchor: the outer match ends in a quote,
  so anchoring silently matches nothing and the whole check passes vacuously. Before trusting
  a silent result from this or any other check here, confirm it still fires on a file you
  know is bad.
  Screenshots of a *running program* are not duplicates — only screenshots of text or code
  that the report already lists.
- **figures with no caption** — bare `#image(` not wrapped in `#figure`:
  ```bash
  grep -rn '^#image(' lab-*/report.typ
  ```
- **inconsistency across labs** — the whole point of doing a discipline at once is that its
  reports end up looking like one series. Open two PDFs side by side. If lab 4 says
  `= Цель работы` and lab 5 says `= Цели работы`, unify them.

Finally, open a couple of PDFs against their original `.docx` and check the figures and
formulas actually survived.

## 4. Format and commit

```bash
typstyle --inplace --line-width 100 --wrap-text .
mise run report-all   # once more; typstyle has been known to expose a bad edit
```

Then one commit per lab.

## What to escalate rather than fix

Re-spawning an agent is almost never worth it, but hand the lab back to a fresh Sonnet agent
if its `report.typ` is structurally wrong throughout — no headings at all, the whole original
document still present, or the body clearly invented rather than converted. Give it the same
prompt plus what went wrong. For anything smaller, fix it in place; it is faster and the
result is more consistent with the rest of the course.
