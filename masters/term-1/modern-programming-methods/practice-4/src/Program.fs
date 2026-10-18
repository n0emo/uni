open System.Numerics
open Raylib_cs

open Model

/// Side of a cell in pixels.
let cellSize = 4

/// Speeds in generations per second that + and - step through.
let speeds = [| 1; 2; 5; 10; 20; 30; 60; 120 |]

/// Share of live cells in a random first row.
let density = 0.5

let random = System.Random()

/// Rules on F1–F4: chaos (30), the Sierpinski triangle (90), the Turing-complete rule 110 and
/// traffic flow (184).
let presets = [ 30uy; 90uy; 110uy; 184uy ]

/// Clicking this many top rows of the diagram edits the top row, so there is no need to aim
/// at a single row of cells.
let editRows = 8

let margin = 12
let panelWidth = 260
let padding = 16
let gap = 8

let background = Color(24, 24, 28, 255)
let panelColor = Color(36, 36, 42, 255)
let buttonColor = Color(52, 52, 60, 255)
let hoverColor = Color(72, 72, 82, 255)
let accent = Color.Gold

type Box =
    { X: int
      Y: int
      Width: int
      Height: int }

    member box.Contains(point: Vector2) =
        let x, y = int (floor point.X), int (floor point.Y)
        x >= box.X && x < box.X + box.Width && y >= box.Y && y < box.Y + box.Height

/// The diagram takes the window except for the panel on the right.
let viewport () =
    { X = margin
      Y = margin
      Width = max cellSize (Raylib.GetScreenWidth() - panelWidth - 3 * margin)
      Height = max cellSize (Raylib.GetScreenHeight() - 2 * margin) }

let panel () =
    { X = Raylib.GetScreenWidth() - panelWidth - margin
      Y = margin
      Width = panelWidth
      Height = Raylib.GetScreenHeight() - 2 * margin }

/// The viewport width gives the row length, and its height gives how many generations are kept.
let columns () = (viewport ()).Width / cellSize
let rows () = (viewport ()).Height / cellSize

/// First rows the user can start from.
type Pattern =
    | Single
    | Random
    | Empty

let makeRow pattern width =
    match pattern with
    | Single -> Row.single width
    | Random -> Row.random random density width
    | Empty -> Row.empty width

type State =
    { Automaton: Automaton
      /// The first row, which every restart begins from.
      Seed: Row
      Paused: bool
      /// Index into `speeds`.
      Speed: int
      /// Time not yet spent on generations, in seconds.
      Elapsed: float32
      /// Digits of a rule number being typed, empty when nothing is typed.
      Input: string
      Quit: bool }

/// Everything the user can do, with the keyboard or with the panel buttons.
type Command =
    | SetRule of Rule
    | SetBoundary of Boundary
    | NewRow of Pattern
    /// Flips the cell of the top row in this column.
    | Toggle of int
    | TogglePause
    /// Computes one generation and pauses.
    | Step
    | Faster
    | Slower
    | TypeDigit of char
    | Erase
    | Apply
    /// Cancels typing a rule number, or quits when nothing is typed.
    | Escape

/// Every change of the rule, the boundary or the first row starts the evolution over.
let restart rule boundary seed state =
    { state with
        Automaton = Automaton.create (rows ()) rule boundary seed
        Seed = seed
        Elapsed = 0.0f }

let rec apply state command =
    let automaton = state.Automaton

    match command with
    | SetRule rule -> restart rule automaton.Boundary state.Seed { state with Input = "" }
    | SetBoundary boundary -> restart automaton.Rule boundary state.Seed state
    | NewRow pattern -> restart automaton.Rule automaton.Boundary (makeRow pattern (columns ())) state
    // The top row is the oldest generation on screen; the edited row becomes generation 0.
    | Toggle x -> restart automaton.Rule automaton.Boundary (Row.toggle x automaton.History[0]) state
    | TogglePause -> { state with Paused = not state.Paused }
    | Step ->
        Automaton.step automaton
        { state with Paused = true }
    | Faster -> { state with Speed = min (speeds.Length - 1) (state.Speed + 1) }
    | Slower -> { state with Speed = max 0 (state.Speed - 1) }
    // Digits that would make the number larger than 255 are ignored.
    | TypeDigit digit ->
        let typed = state.Input + string digit

        if typed.Length <= 3 && (Rule.tryParse typed).IsSome then
            { state with Input = typed }
        else
            state
    | Erase -> { state with Input = state.Input[.. state.Input.Length - 2] }
    | Apply ->
        match Rule.tryParse state.Input with
        | Some rule -> apply state (SetRule rule)
        | None -> state
    | Escape when state.Input <> "" -> { state with Input = "" }
    | Escape -> { state with Quit = true }

/// Generations change at a fixed rate regardless of the frame rate; after a stall (e.g. while
/// the window is dragged) at most a quarter of a second is caught up.
let advance frameTime state =
    if state.Paused then
        { state with Elapsed = 0.0f }
    else
        let interval = 1.0f / float32 speeds[state.Speed]
        let mutable elapsed = min (interval + 0.25f) (state.Elapsed + frameTime)

        while elapsed >= interval do
            Automaton.step state.Automaton
            elapsed <- elapsed - interval

        { state with Elapsed = elapsed }

/// The rows centred horizontally in the viewport, the first row at the top.
let diagram automaton =
    let view = viewport ()
    let width = Row.length automaton.History.Last * cellSize

    { X = view.X + (view.Width - width) / 2
      Y = view.Y
      Width = width
      Height = automaton.History.Count * cellSize }

/// Column of the top row cell under the mouse, if the mouse is over the editing area.
let hovered automaton =
    let area = diagram automaton
    let area = { area with Height = min (viewport ()).Height (editRows * cellSize) }
    let mouse = Raylib.GetMousePosition()

    if area.Contains mouse then
        Some((int (floor mouse.X) - area.X) / cellSize)
    else
        None

let pressed key : bool = Raylib.IsKeyPressed key
let held key = pressed key || (Raylib.IsKeyPressedRepeat key: bool)
let clicked button : bool = Raylib.IsMouseButtonPressed button
let resized () : bool = Raylib.IsWindowResized()

let rec charsPressed typed =
    match Raylib.GetCharPressed() with
    | 0 -> List.rev typed
    | codepoint -> charsPressed (char codepoint :: typed)

let keyboard state =
    let rule = state.Automaton.Rule

    [ for c in charsPressed [] do
          if c >= '0' && c <= '9' then
              TypeDigit c

      if state.Input <> "" && held KeyboardKey.Backspace then Erase
      if pressed KeyboardKey.Enter || pressed KeyboardKey.KpEnter then Apply
      if pressed KeyboardKey.Escape then Escape
      if held KeyboardKey.Left then SetRule(Rule.previous rule)
      if held KeyboardKey.Right then SetRule(Rule.next rule)

      for key, number in List.zip [ KeyboardKey.F1; KeyboardKey.F2; KeyboardKey.F3; KeyboardKey.F4 ] presets do
          if pressed key then
              SetRule(Rule number)

      if pressed KeyboardKey.Space then TogglePause
      if pressed KeyboardKey.N then Step
      // + shares a key with = on most layouts.
      if held KeyboardKey.Equal || held KeyboardKey.KpAdd then Faster
      if held KeyboardKey.Minus || held KeyboardKey.KpSubtract then Slower
      if pressed KeyboardKey.B then SetBoundary(Boundary.toggle state.Automaton.Boundary)
      if pressed KeyboardKey.S then NewRow Single
      if pressed KeyboardKey.R then NewRow Random
      if pressed KeyboardKey.C then NewRow Empty ]

/// Rows go from the oldest at the top to the newest at the bottom, so once the history is full,
/// each new generation shifts the diagram up by one row. Everything is clipped to the viewport.
let drawDiagram state =
    let automaton = state.Automaton
    let view = viewport ()
    let area = diagram automaton
    Raylib.DrawRectangle(view.X, view.Y, view.Width, view.Height, Color.Black)
    Raylib.BeginScissorMode(view.X, view.Y, view.Width, view.Height)

    for y in 0 .. automaton.History.Count - 1 do
        let (Row cells) = automaton.History[y]

        for x in 0 .. cells.Length - 1 do
            if cells[x] then
                Raylib.DrawRectangle(area.X + x * cellSize, area.Y + y * cellSize, cellSize, cellSize, Color.RayWhite)

    // The editing area is shaded, and the column under the mouse points at the cell to flip.
    match hovered automaton with
    | Some x ->
        let height = editRows * cellSize
        Raylib.DrawRectangle(area.X, area.Y, area.Width, height, Raylib.Fade(accent, 0.1f))
        Raylib.DrawRectangle(area.X + x * cellSize, area.Y, cellSize, height, Raylib.Fade(accent, 0.3f))
        Raylib.DrawRectangle(area.X + x * cellSize, area.Y, cellSize, cellSize, accent)
    | None -> ()

    if state.Paused then
        let width = Raylib.MeasureText("PAUSED", 20)
        let x, y = view.X + view.Width - width - 12, view.Y + view.Height - 32
        Raylib.DrawRectangle(x - 8, y - 6, width + 16, 32, Raylib.Fade(Color.Black, 0.7f))
        Raylib.DrawText("PAUSED", x, y, 20, accent)

    Raylib.EndScissorMode()

/// Immediate-mode button: draws itself and tells whether it was clicked in this frame.
let button (box: Box) (text: string) active =
    let hover = box.Contains(Raylib.GetMousePosition())
    let color = if active then accent elif hover then hoverColor else buttonColor
    Raylib.DrawRectangle(box.X, box.Y, box.Width, box.Height, color)
    let width = Raylib.MeasureText(text, 20)
    let textColor = if active then Color.Black else Color.RayWhite
    Raylib.DrawText(text, box.X + (box.Width - width) / 2, box.Y + (box.Height - 20) / 2, 20, textColor)
    hover && clicked MouseButton.Left

/// Section title on the left and its keys on the right.
let section (title: string) (keys: string) x width y =
    Raylib.DrawText(title, x, y, 20, Color.Gray)
    Raylib.DrawText(keys, x + width - Raylib.MeasureText(keys, 20), y, 20, Raylib.Fade(accent, 0.7f))

/// Side of a cell in the transition table, with a 1-pixel gap after it.
let tableCell = 8

/// A cell of the transition table: dead cells are grey.
let square x y alive color =
    Raylib.DrawRectangle(x, y, tableCell - 1, tableCell - 1, (if alive then color else hoverColor))

/// Draws the panel and returns the commands of the buttons clicked in this frame.
let drawPanel state =
    let panel = panel ()
    Raylib.DrawRectangle(panel.X, panel.Y, panel.Width, panel.Height, panelColor)

    let automaton = state.Automaton
    let x = panel.X + padding
    let width = panel.Width - 2 * padding
    let top = panel.Y + padding
    let commands = ResizeArray()

    /// Box i of n boxes sharing a row at height y.
    let cell n i y =
        let w = (width - (n - 1) * gap) / n

        { X = x + i * (w + gap)
          Y = y
          Width = w
          Height = 32 }

    let buttons y (items: (string * bool * Command) list) =
        for i, (text, active, command) in List.indexed items do
            if button (cell items.Length i y) text active then
                commands.Add command

    // While a rule number is being typed, it is shown instead of the current one.
    section "RULE" "0-9 <- ->" x width top

    if state.Input = "" then
        Raylib.DrawText(string (Rule.number automaton.Rule), x, top + 26, 40, Color.RayWhite)
    else
        Raylib.DrawText(state.Input + "_", x, top + 26, 40, accent)

    let arrow i =
        { X = x + width - 88 + i * 48
          Y = top + 26
          Width = 40
          Height = 40 }

    if button (arrow 0) "<" false then
        commands.Add(SetRule(Rule.previous automaton.Rule))

    if button (arrow 1) ">" false then
        commands.Add(SetRule(Rule.next automaton.Rule))

    // Transition table: each neighbourhood above its new state. Clicking a column flips the state.
    let pitch = width / 8

    for i, (index, result) in List.indexed (Rule.table automaton.Rule) do
        let column =
            { X = x + (width - 8 * pitch) / 2 + i * pitch
              Y = top + 70
              Width = pitch
              Height = 26 }

        let hover = column.Contains(Raylib.GetMousePosition())

        if hover then
            Raylib.DrawRectangle(column.X, column.Y, column.Width, column.Height, buttonColor)

        let left = column.X + (pitch - 3 * tableCell) / 2
        let l, c, r = Rule.neighbourhood index

        for j, alive in List.indexed [ l; c; r ] do
            square (left + j * tableCell) (top + 74) alive Color.RayWhite

        square (left + tableCell) (top + 85) result accent

        if hover && clicked MouseButton.Left then
            commands.Add(SetRule(Rule.flip index automaton.Rule))

    section "PRESETS" "F1-F4" x width (top + 108)
    buttons (top + 134) [ for n in presets -> string n, automaton.Rule = Rule n, SetRule(Rule n) ]

    section "PLAYBACK" "Space N" x width (top + 184)
    buttons (top + 210) [ (if state.Paused then "Play" else "Pause"), false, TogglePause; "Step", false, Step ]

    section "SPEED" "- +" x width (top + 260)

    if button { cell 1 0 (top + 286) with Width = 40 } "-" false then
        commands.Add Slower

    if button { cell 1 0 (top + 286) with X = x + width - 40; Width = 40 } "+" false then
        commands.Add Faster

    let speed = $"{speeds[state.Speed]} gen/s"
    Raylib.DrawText(speed, x + (width - Raylib.MeasureText(speed, 20)) / 2, top + 292, 20, Color.RayWhite)

    section "EDGES" "B" x width (top + 336)

    buttons
        (top + 362)
        [ "Ring", automaton.Boundary = Ring, SetBoundary Ring
          "Zero", automaton.Boundary = Zero, SetBoundary Zero ]

    section "START ROW" "S R C" x width (top + 412)
    buttons (top + 438) [ "Single", false, NewRow Single; "Random", false, NewRow Random; "Clear", false, NewRow Empty ]

    // In a short window the hint gives way to the stats.
    let roomy = panel.Height >= 638

    if roomy then
        Raylib.DrawText("Click near the top", x, top + 478, 20, Color.Gray)
        Raylib.DrawText("to toggle cells", x, top + 500, 20, Color.Gray)

    // The share of live cells is counted in the newest generation, the bottom row of the diagram.
    let stat (label: string) (value: string) y =
        Raylib.DrawText(label, x, y, 20, Color.Gray)
        Raylib.DrawText(value, x + width - Raylib.MeasureText(value, 20), y, 20, Color.RayWhite)

    let newest = automaton.History.Last
    let y = if roomy then top + 536 else top + 484
    section "STATS" "" x width y
    stat "Generation" (string (Automaton.generation automaton)) (y + 26)
    stat "Alive" (sprintf "%d (%.1f%%)" (Row.alive newest) (100.0 * Row.share newest)) (y + 50)

    List.ofSeq commands

[<EntryPoint>]
let main argv =
    Raylib.SetConfigFlags ConfigFlags.ResizableWindow

    try
        // A diagram of 200 × 160 cells next to the panel. The minimum height still fits the panel
        // without the hint.
        Raylib.InitWindow(200 * cellSize + panelWidth + 3 * margin, 160 * cellSize + 2 * margin, "Cellular Automaton")
        Raylib.SetWindowMinSize(560, 612)
        Raylib.SetTargetFPS 60
        // Esc cancels typing a rule number before it closes the window.
        Raylib.SetExitKey KeyboardKey.Null

        let seed = Row.single (columns ())

        let mutable state =
            { Automaton = Automaton.create (rows ()) (Rule 30uy) Ring seed
              Seed = seed
              Paused = false
              Speed = Array.findIndex ((=) 20) speeds
              Elapsed = 0.0f
              Input = ""
              Quit = false }

        while not state.Quit && not (Raylib.WindowShouldClose()) do
            let hover = hovered state.Automaton

            let commands =
                [ // The row length depends on the viewport width, so the evolution starts over.
                  if resized () then NewRow Single
                  yield! keyboard state

                  match hover with
                  | Some x when clicked MouseButton.Left -> Toggle x
                  | _ -> () ]

            Raylib.SetMouseCursor(if hover.IsSome then MouseCursor.PointingHand else MouseCursor.Default)
            state <- List.fold apply state commands |> advance (Raylib.GetFrameTime())

            Raylib.BeginDrawing()
            Raylib.ClearBackground background
            drawDiagram state
            let clicks = drawPanel state
            Raylib.EndDrawing()

            state <- List.fold apply state clicks

    finally
        Raylib.CloseWindow()

    0
