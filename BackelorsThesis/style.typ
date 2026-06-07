#let custom-style(content) = {
  show table.header: set text(weight: "bold")

  show raw.where(lang: "wit"): it => {
    let color-keywords = rgb("#DD3050")
    let color-types = rgb("#3040B0")
    let color-packages = rgb("#109010")
    let color-param-types = rgb("#AA6050")
    let color-comments = rgb("#AA00AA")

    show regex("\b(package|world|interface|use|include|import|export)\b"): set text(
      fill: color-keywords,
      weight: "bold",
    )
    show regex("\b(record|variant|enum|flags|type|resource|func|static|constructor)\b"): set text(
      fill: color-keywords,
      weight: "bold",
    )
    show regex("\b(bool|char|f32|f64|s8|s16|s32|s64|u8|u16|u32|u64)\b"): set text(
      fill: color-types,
    )
    show regex("\b(option|result|list|tuple|borrow|own)\b"): set text(
      fill: color-param-types,
      style: "italic",
    )
    show regex("[a-z][a-z0-9-]*:[a-z][a-z0-9/_.@-]*"): set text(fill: color-packages)
    show regex("//[^\n]*"): set text(fill: color-comments, style: "italic")
    show regex("\"[^\"]*\""): set text(fill: color-comments)

    it
  }

  content
}
