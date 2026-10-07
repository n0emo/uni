#import "@local/pgups:0.1.0": *
#import "@preview/callisto:0.3.0"
#import "@preview/merman:0.3.0": mermaid

#let report(
  title: placeholder("title"),
  number: placeholder("number"),
  variant: none,
  content,
) = generic-lab(
  course: config-course(
    faculty: "Автоматизация и интеллектуальные технологии",
    department: "Информационные и вычислительные системы",
    discipline: "Системы искусственного интеллекта",
    year: 2025,
  ),
  student: config-student(
    name: "А. Шефнер",
    group: "ИВБ-211",
  ),
  teacher: config-teacher(
    name: [С.В. Пугачев],
    post: [доц. "ИВС"],
  ),
  lab: config-lab(
    number: number,
    title: title,
    variant: variant,
  ),
  work-title: num => [
    ОТЧЁТ \
    По практическому заданию № #num
  ],
  style: config-style(
    headings-numbering: none,
  ),
  content,
)

// Cells take Quarto-style options from a header of `#| key: value` lines, with
// YAML values: `include: false` drops the cell, `echo: false` its code and
// `output: false` its output. `fig-cap` captions the cell's image outputs and
// `tbl-cap` its tables, either one caption or a list like `["A", "B"]` with one
// per output, in order. A %%mermaidjs cell must start with the magic, and
// Mermaid wants its front matter first, so there the options are `%%| key:
// value` comment lines after the front matter.
#let mermaid-cell-magic = "%%mermaidjs"
#let mermaid-option-regex = regex("^%%\|\s*(.*?):\s*(.*?)\s*$")

#let is-mermaid(cell) = cell.cell_type == "code" and cell.source.starts-with(mermaid-cell-magic)

#let cell-options(cell) = {
  let options = cell.metadata.at("callisto", default: (:)).at("header", default: (:))
  if is-mermaid(cell) {
    for line in cell.source.split("\n") {
      let m = line.match(mermaid-option-regex)
      if m != none { options.insert(..m.captures) }
    }
  }
  options.pairs().map(((key, value)) => (key, yaml(bytes(value)))).to-dict()
}

// The notebook output of a %%mermaidjs cell is an SVG with HTML labels
// (foreignObject), which Typst can't render, so draw the diagram from the
// cell source instead. The front matter only sets the Jupyter theme.
#let text-html(data, ctx: none, ..args) = {
  if not is-mermaid(ctx.cell) {
    // Drop the <style> pandas puts before its tables, cmarker prints it as text
    let data = data.replace(regex("(?s)<style.*?</style>"), "")
    return callisto.default-handlers.at("text/html")(data, ctx: ctx, ..args)
  }
  let diagram = ctx.cell.source.trim(mermaid-cell-magic, at: start).trim()
  if diagram.starts-with("---") {
    diagram = diagram.split(regex("(?m)^---\s*$")).slice(2).join("---")
  }
  diagram = diagram.split("\n").filter(line => line.match(mermaid-option-regex) == none).join("\n")
  align(center, mermaid(diagram, height: 15cm))
}

// What a raw output item renders as: an image (plots, Mermaid diagrams), a
// table (pandas), a bare object repr like `<Axes: ...>` that only clutters the
// report, or none of these.
#let output-kind(item, cell) = {
  let data = item.at("data", default: (:))
  if data.keys().any(mime => mime.starts-with("image/")) { return image }
  if "text/html" in data { return if is-mermaid(cell) { image } else { table } }
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
  let kind = output-kind(outputs.at(index), ctx.cell)
  if kind == "repr" { return none }
  let body = (callisto.default-handlers.output)(data, ctx: ctx, ..args)
  if kind == none { return body }
  let captions = cell-options(ctx.cell).at(
    if kind == image { "fig-cap" } else { "tbl-cap" },
    default: (),
  )
  if type(captions) != array { captions = (captions,) }
  let n = outputs.slice(0, index).filter(item => output-kind(item, ctx.cell) == kind).len()
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
