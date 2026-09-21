# Cleaning up pandoc's Typst output

What `pandoc -t typst` produces from a ПГУПС Word report, and what each artefact has to become.
Ordered roughly by how much damage leaving it in would do.

## Boilerplate that must be deleted outright

`lab-report` from `@local/pgups` regenerates all of this. Anything below that survives in
`report.typ` means the PDF has two title pages.

| pandoc output | action |
| --- | --- |
| `ФЕДЕРАЛЬНОЕ АГЕНСТВО ЖЕЛЕЗНОДОРОЖНОГО ТРАНСПОРТА` … `«ПГУПС»` | delete |
| `Кафедра «…»`, `Дисциплина «…»` | delete — move the values into `common.typ` |
| `#strong[ОТЧЁТ]`, `#strong[ПО ЛАБОРАТОРНОЙ РАБОТЕ № 1]`, `ВАРИАНТ 19` | delete — `number`, `title`, `variant` |
| the Выполнил студент / Проверил `#table(...)` | delete — `config-student`, `config-teacher` |
| `#strong[Санкт-Петербург]`, `#strong[2023]` | delete — `year` in `config-course` |
| `Оценочный лист результатов ЛР № N` + its huge `#table` | delete |
| `Ф.И.О. студента \_\_\_…`, `Группа \_\_\_…` | delete |
| `Доцент кафедры … «\_\_» \_\_\_\_\_\_2023 г.` | delete |
| a `#outline()`-like manual contents table | delete — the template emits one |

Read the student/teacher/discipline/year/variant values off this block **before** deleting it;
they are what `common.typ` needs.

## Fake headings

Word reports mark sections with bold body text. pandoc renders that literally:

```typ
#strong[Цели работы:]
#strong[Задание]
#strong[Ход работы]
```

Rewrite as real headings, nesting to the report's actual structure:

```typ
= Цель работы
= Задание
= Ход работы
== Постановка задачи
=== Входные параметры
```

Term-1 reports set `headings-numbering: none` in `config-style` and use plain headings; match
that unless the department template for the course clearly numbers its sections.

Also watch for `#underline[...]` and `#strong[#underline[ \ ]]` used as spacing — delete.

## Listings

pandoc dumps program text as paragraphs or a `#block` of verbatim lines, often with mangled
indentation and smart quotes. Replace the whole thing with a read from `src/`:

```typ
== Исходный текст программы

#code-file(read("./src/main.c"), name: "main.c")
```

`code-file` infers the language from the file extension in `name`. For several files, call it
once per file. For a long listing that belongs at the end, wrap the section in `appendixes`.

Terminal transcripts ("Отладка приложения") stay inline as a raw block inside a figure:

```typ
#figure(
  kind: image,
  caption: "Отладка приложения",
  ```
  ❯ ./build/lab-1/lab-1
  V = 3566.875582
  ```,
)
```

## Math

pandoc escapes aggressively and emits OMML as `$...$` with stray backslashes and `med`
spacing:

```typ
$
  f\(x\)= {y\(- 10\)\,med med med med x < - 10\
```

Retype it as idiomatic Typst math. Backslash-escaped `\(`, `\)`, `\,`, `\+` are always wrong
in math mode. Prefer `cases` over a hand-built brace, `frac(a, b)` over `a/b` for display
formulas, and factor a formula used twice into `#let formula = $...$`.

Formulas that came through as `#box(image("media/image1.wmf"))` are Word equation objects —
retype them from the task statement rather than converting the raster.

## Images

```bash
git mv lab-1/assets/media/* lab-1/assets/ && rmdir lab-1/assets/media
soffice --headless --convert-to png --outdir lab-1/assets lab-1/assets/image1.wmf
rm lab-1/assets/*.wmf lab-1/assets/*.emf
```

Then rename `image3.png` → something meaningful (`flowchart-1.png`, `mathcad-2.png`), fix the
paths, and wrap every image in a captioned figure — pandoc emits bare `#image(...)` with the
caption as a separate paragraph:

```typ
#figure(
  caption: "Блок-схема алгоритма",
  image("./assets/flowchart.png", height: 30%),
)
```

Use `height: 30%` or `width: 80%` for oversized flowcharts. `.png`/`.jpg` are LFS-tracked
automatically; `.svg` is not and is preferable for flowcharts you redraw.

## Tables

pandoc's tables are usually structurally right but verbose: explicit `columns: (50.01%,
49.99%)`, `align: (auto, auto)`, `kind: table` on a bare `#figure`. Simplify to `columns: 2`
or fractional widths, drop redundant `align`, and give the figure a real caption. Keep
`table.header(...)` — it is what makes the header repeat across pages.

Empty `table.cell(rowspan: N)[]` placeholders that came from merged Word cells often collapse
to nothing useful; check the rendered PDF against the original.

## Lists

`#block[#set enum(numbering: "1.", start: 2) + ]` — an artefact of Word restarting numbering.
Rewrite as one continuous `+` list. Sub-items typed as literal text (`2.1. ввод x`) should
become nested list items.

The template already sets `list-marker: [--]`; do not re-set it per report.

## Typography

- `«…»` from Word is correct Russian typography — keep it.
- `\_\_\_\_` fill-in blanks — delete with their surrounding line.
- Non-breaking spaces survive as invisible U+00A0; harmless, but strip them inside math.
- Run `typstyle --inplace --line-width 100 --wrap-text` last; it reflows everything to the
  repo's width and normalizes `align:` tuples.
