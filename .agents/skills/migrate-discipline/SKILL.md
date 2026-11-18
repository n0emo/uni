---
name: migrate-discipline
description: Migrate a whole university course to Typst reports and mise tasks. Prepare shared scaffolding, delegate each lab's report and build configuration to its own sub-agent when available, and verify the course centrally. Use for requests to migrate, modernize, or "typst-ify" an entire course.
---

# Migrating a whole discipline

A discipline is one course directory — `bachelors/term-2/programming-c`,
`bachelors/term-5/programming-java` — holding several labs. This skill migrates all of its
labs in one pass. Read [migrate-lab](../migrate-lab/SKILL.md) and its references before
starting. Give each sub-agent the relevant per-lab guidance.

## The split

The work divides into three phases, and the division is what makes parallel agents safe:

| Phase | Who | What |
| --- | --- | --- |
| 1. Scaffold | you, serially | survey, `git mv`, pandoc, `soffice`, all shared files |
| 2. Author | one sub-agent per lab when available | rewrite `report.typ`, write per-lab build config |
| 3. Verify | you, serially | build every lab, fix every error, commit |

**Sub-agents never build anything and never touch a shared file.** They are writers. Every
`mise run`, `cmake`, `typst compile`, `cargo`, `mvn` and every `git` invocation for the whole
migration happens in phase 1 or phase 3, under your control. This is deliberate: concurrent
builds race on `build/` and `target/`, concurrent `git` races on `.git/index.lock`, and
concurrent edits to `common.typ` or the course `CMakeLists.txt` silently clobber each other.

## Phase 1 — scaffold everything shared

Nothing here is delegated. It is mechanical, it is fast, and every bit of it is either shared
state or a tool that cannot be run concurrently.

### 1.1 Survey the discipline

```bash
cd bachelors/term-N/<course>
ls -R . | head -100
```

Write down, per lab: the report document, the task statements, the sources and their
language, and any legacy `justfile`/`.sln`/`Makefile`. Before converting any documents,
record which labs still need migration. Use the already-migrated labs as style references.

Decide one build tool for the whole discipline from the majority language using the
[build-tool reference](../migrate-lab/references/build-tools.md). A discipline is one language in
practice; if two labs genuinely disagree, the odd one out gets no build task and is noted.

If the toolchain is dead or Windows-only for the whole course (WinAsm, MathCAD, Delphi,
.NET Framework), the discipline is report-only: skip every build step below and tell the
sub-agents not to write build config.

### 1.2 Restructure directories

All of it, for all labs, in one go — `git mv` only:

```bash
for n in 4 5 6; do
  git mv "Lab $n" "lab-$n" 2>/dev/null
  git mv "lab-$n/c_lab_$n" "lab-$n/src"
done
```

### 1.3 Run the converters

`pandoc` is safe to loop; **`soffice` is not safe to run concurrently** — it shares one user
profile and a second instance fails or silently no-ops. Both stay here, serial:

```bash
for n in 4 5 6; do
  pandoc "lab-$n/ЛР$n.docx" -t typst --extract-media="lab-$n/assets" -o "lab-$n/report.typ"
  [ -d "lab-$n/assets/media" ] && git mv "lab-$n/assets/media/"* "lab-$n/assets/" && rmdir "lab-$n/assets/media"
done

# serially, one soffice call at a time
for f in lab-*/assets/*.wmf lab-*/assets/*.emf; do
  [ -e "$f" ] || continue
  soffice --headless --convert-to png --outdir "$(dirname "$f")" "$f"
  rm "$f"
done
```

Commit the raw pandoc output for the whole discipline as one commit before phase 2 —
`<course>: convert lab reports with pandoc`. It keeps "what pandoc did" separable from "what
the agents wrote", and gives you a clean `git diff` to review their work against.

### 1.4 Write the shared files

Create or update, yourself, before spawning anything:

- `common.typ` — read `faculty`/`department`/`discipline`/`year`/`student`/`teacher`/`variant`
  off a title page pandoc just produced, then write it once for the course;
- the course `mise.toml` — build tasks plus the `report`/`report-all` pair, with **every** lab
  number already listed in `report-all`;
- the course-root aggregator — `CMakeLists.txt` with an `add_subdirectory(lab-N)` per lab,
  or the `Cargo.toml` workspace `members`, or the parent `pom.xml` `<modules>`;
- `.gitignore`;
- the root `mise.toml` `config_roots` entry, if the course is not registered yet.

These files are the reason the sub-agents can run in parallel: once they exist, each agent's
writes are confined to its own `lab-N/` directory and cannot collide.

Delete the legacy `justfile` here too.

## Phase 2 — author each lab

Delegate one lab per sub-agent and run independent labs in parallel within the available
concurrency limit. Use the migration list from phase 1. If delegation is unavailable,
author each lab in sequence and verify them together in phase 3.

When model selection is available, use the standard coding model for routine lab conversions.
Choose a more capable model for a lab that needs substantial judgment, such as reconstructing
complex equations or recovering the report structure from poor converter output.

Fill in the [sub-agent prompt template](references/agent-prompt.md) for each lab. Include
its scope and deliverables so the sub-agent can work from its prompt and the linked files.

Fill in per agent, at minimum: the absolute lab path, the lab number and title, the language
and the exact build-config file it must write, the list of source files, and the path of one
already-migrated lab to copy the house style from.

While they run, do not start phase 3 and do not edit anything inside a `lab-N/` directory an
agent owns. Read-only inspection is fine.

## Phase 3 — verify and fix, yourself

Build and review each draft centrally. Fix routine errors during verification.

```bash
cd bachelors/term-N/<course>
mise run build        # once, for every lab at the same time
mise run report-all   # every report, in one shot
```

Then, per lab, in the order the errors come out. The catalogue of what typically breaks and
how to fix it is in `references/verification.md`. In short:

- compile errors in `report.typ` — bad `read()` paths, `#code-file` on a file that moved,
  unbalanced math, a figure pointing at a `.wmf` that is now a `.png`;
- build errors — a source file missing from `add_subdirectory`/`members`/`<modules>`, a
  missing `target_link_libraries(lab-N m)`, a lab whose sources do not actually compile;
- leftovers no compiler catches — a surviving title page, `#strong[...]` still standing in for
  a heading, a listing pasted inline instead of `read()` from `src/`;
- agent overreach the build is blind to — prose quietly reworded, or one file shown twice as
  both a listing and a screenshot. Both turned up in every lab of the first course this was
  run on, so check for them by default rather than on suspicion.

The last group needs eyes, not a build. Diff each `report.typ` against the pandoc commit and
open at least a couple of the PDFs against their original `.docx`.

Finish with `typstyle --inplace --line-width 100 --wrap-text .` across the course — the
sub-agents were told to skip it, so it has not been run.

## Commits

One commit per lab, same subject convention as `migrate-lab`, after everything verifies:

```
programming-c: migrate lab 4 to Typst and CMake
```

Plus the phase-1 pandoc commit before them, and a scaffolding commit if `common.typ` /
`mise.toml` / `CMakeLists.txt` changed enough to be worth isolating. Never let a sub-agent
commit.

## Report back

Say per lab whether it built, whether its report compiled, and what was dropped in
conversion. Name any lab left report-only because its toolchain is dead. If you fixed a
sub-agent's work substantially, say so — it is the signal that the prompt template needs
tightening.

## Checklist

- [ ] Every shared file written in phase 1, before any agent was spawned
- [ ] `soffice` run serially by you; no agent ran it
- [ ] Raw pandoc output committed before phase 2
- [ ] Each lab in the phase 1 migration list was authored, with one sub-agent per lab if delegated
- [ ] No agent ran a build, a `git` command, or touched a file outside its `lab-N/`
- [ ] `mise run build` and `mise run report-all` both green *after* phase 3 fixes
- [ ] Reports checked by eye against the originals, not just by exit code
- [ ] `typstyle` run across the course at the end
- [ ] One commit per lab; the originals `.docx`/`.odt` all still present
