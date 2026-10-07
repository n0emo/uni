#import "@local/pgups:0.1.0": *
#import "@preview/callisto:0.3.0"
#import "@preview/cetz:0.5.2": canvas, draw
#import "@preview/cetz-plot:0.1.4": chart, plot

// cmarker renders a Markdown ordered list as `enum(start: 1, [a], [b])`, whose
// items carry no explicit number, while the `show enum` rule in @local/pgups
// reads `it.number` unguarded and fails with "field number in item is not known
// at this point". Numbering the items up front satisfies it. The real fix is
// `it.at("number", default: auto)` in pgups; drop this once that lands.
#let number-enum-items(body) = {
  show enum: it => {
    if it.children.all(child => child.at("number", default: none) != none) { it } else {
      enum(..it.children.enumerate().map(((i, child)) => enum.item(it.start + i, child.body)))
    }
  }
  body
}

#let report(
  title: placeholder("title"),
  number: placeholder("number"),
  content,
) = lab-report(
  course: config-course(
    faculty: "Автоматизация и интеллектуальные технологии",
    department: "Информационные и вычислительные системы",
    discipline: "Архитектура вычислительных систем",
    year: 2026,
  ),
  student: config-student(
    name: "А. Шефнер",
    group: "ИВБ-211",
  ),
  teacher: config-teacher(
    name: "В.А. Гончаренко",
    post: [доц. каф. "ИВС"],
  ),
  lab: config-lab(
    number: number,
    title: title,
    variant: "13",
  ),
  style: config-style(
    headings-numbering: none,
  ),
  number-enum-items(content),
)

// Measurements live in `lab-N/data/*.csv` next to the spreadsheet they were
// read off, so a table and the plot drawn from it cannot disagree.

// A number in Russian notation, with a comma for the decimal separator. A bare
// comma inside `$...$` is punctuation, not a separator, so numbers in math have
// to go through this.
#let num(value) = str(value).replace(".", ",")

// Rows of a CSV read with `csv()`, without its header row.
#let rows(data) = data.slice(1)

// One column of such a CSV, by header name, as floats.
#let column(data, name) = {
  let i = data.at(0).position(h => h == name)
  assert(i != none, message: "no column " + name)
  rows(data).map(row => float(row.at(i)))
}

// An (x, y) series from two of its columns.
#let series(data, x, y) = column(data, x).zip(column(data, y))

// A table of the whole CSV. Its header row names the columns for `column()`, so
// pass `headers:` to label them as the report should read.
#let csv-table(
  data,
  caption: none,
  headers: auto,
  align: center,
  columns: auto,
  format: it => it,
) = figure(
  caption: caption,
  table(
    columns: if columns == auto { data.at(0).len() } else { columns },
    align: align,
    table.header(..(if headers == auto { data.at(0) } else { headers }).map(h => [*#h*])),
    ..rows(data).map(row => row.map(cell => [#format(cell)])).flatten(),
  ),
)

#let series-colors = (blue, red, green, orange)

// A line plot of one or more (x, y) series, in the shape of the spreadsheet
// charts these reports were originally drawn in.
#let line-plot(
  ..args,
  labels: (),
  x-label: none,
  y-label: none,
  size: (12, 7),
) = canvas(
  plot.plot(
    size: size,
    x-label: x-label,
    y-label: y-label,
    legend: if labels.len() > 1 { auto } else { none },
    ..args.named(),
    {
      for (i, points) in args.pos().enumerate() {
        plot.add(
          points,
          mark: "o",
          mark-size: 0.1,
          style: (
            stroke: (
              paint: series-colors.at(calc.rem(i, series-colors.len())),
              thickness: 1.5pt,
            ),
          ),
          label: labels.at(i, default: none),
        )
      }
    },
  ),
)

// Cells take Quarto-style options from a header of `#| key: value` lines, with
// YAML values: `include: false` drops the cell, `echo: false` its code and
// `output: false` its output. `fig-cap` captions the cell's image outputs and
// `tbl-cap` its tables, either one caption or a list like `["A", "B"]` with one
// per output, in order.
#let cell-options(cell) = {
  let options = cell.metadata.at("callisto", default: (:)).at("header", default: (:))
  options.pairs().map(((key, value)) => (key, yaml(bytes(value)))).to-dict()
}

// Drop the <style> block pandas puts before its tables; cmarker prints it as text.
#let text-html(data, ..args) = {
  (callisto.default-handlers.at("text/html"))(
    data.replace(regex("(?s)<style.*?</style>"), ""),
    ..args,
  )
}

// What a raw output item renders as: an image (plots), a table (HTML), a bare
// object repr like `<Axes: ...>` that only clutters the report, or none of these.
#let output-kind(item) = {
  let data = item.at("data", default: (:))
  if data.keys().any(mime => mime.starts-with("image/")) { return image }
  if "text/html" in data { return table }
  let text = data.at("text/plain", default: "")
  if type(text) == array { text = text.join() }
  if data.keys() == ("text/plain",) and text.match(regex("^<[^\n]*>$")) != none { return "repr" }
  none
}

// Wrap each image or table output into a figure, taking its caption from the
// cell options by its position among the cell's outputs of that kind.
#let output(data, ctx: none, ..args) = {
  let outputs = ctx.cell.outputs
  let index = ctx.item-desc.index
  let kind = output-kind(outputs.at(index))
  if kind == "repr" { return none }
  let body = (callisto.default-handlers.output)(data, ctx: ctx, ..args)
  if kind == none { return body }
  let captions = cell-options(ctx.cell).at(
    if kind == image { "fig-cap" } else { "tbl-cap" },
    default: (),
  )
  if type(captions) != array { captions = (captions,) }
  let n = outputs.slice(0, index).filter(item => output-kind(item) == kind).len()
  if n >= captions.len() { return body }
  figure(body, kind: kind, caption: [#captions.at(n)])
}

#let neat = callisto.themes.neat

#let cell(cell, ctx: none, ..args) = {
  if cell-options(cell).at("include", default: true) == false { return }
  (callisto.default-handlers.cell)(cell, ctx: ctx, ..args)
}

#let code-cell-input(cell, ctx: none, ..args) = {
  if cell-options(cell).at("echo", default: true) == false { return }
  (neat.code-cell-input)(cell, ctx: ctx, ..args)
}

#let code-cell-output(cell, ctx: none, ..args) = {
  if cell-options(cell).at("output", default: true) == false { return }
  (neat.code-cell-output)(cell, ctx: ctx, ..args)
}

// Callisto functions for a lab notebook, styled for the report. Pass a `path`
// handler from the lab to resolve images referenced in Markdown cells, since
// `path` resolves relative to the file that calls it.
#let notebook(nb, handlers: (:), ..args) = callisto.config(
  nb: nb,
  handlers: ("text/html": text-html, output: output) + handlers,
  theme: neat + (cell: cell, code-cell-input: code-cell-input, code-cell-output: code-cell-output),
  cmarker: (h1-level: 2),
  ..args,
)
