module Model

/// Wolfram code: bit 4·l + 2·c + r is the new state of a cell with neighbourhood (l, c, r).
type Rule = Rule of byte

let applyRule (Rule r) left middle right =
    let bit b = if b then 1 else 0
    let index = (bit left <<< 2) ||| (bit middle <<< 1) ||| bit right
    (r >>> index) &&& 1uy = 1uy

module Rule =
    let number (Rule r) = r

    /// Neighbouring rules; 255 and 0 are neighbours.
    let next (Rule r) = Rule(r + 1uy)
    let previous (Rule r) = Rule(r - 1uy)

    /// Reads a rule number typed as decimal digits, from 0 to 255.
    let tryParse (text: string) =
        match System.Byte.TryParse(text, System.Globalization.NumberStyles.None, System.Globalization.CultureInfo.InvariantCulture) with
        | true, r -> Some(Rule r)
        | _ -> None

    /// Neighbourhood `index` (4·l + 2·c + r) as (left, middle, right).
    let neighbourhood index =
        index &&& 4 <> 0, index &&& 2 <> 0, index &&& 1 <> 0

    /// Every neighbourhood index with its new state, from 111 down to 000 as in Wolfram's pictures.
    let table rule =
        [ for index in 7 .. -1 .. 0 ->
              let left, middle, right = neighbourhood index
              index, applyRule rule left middle right ]

    /// The same rule with the new state of neighbourhood `index` flipped.
    let flip index (Rule r) = Rule(r ^^^ (1uy <<< index))

/// What the end cells of a row see beyond the edge.
type Boundary =
    /// The first and the last cells are neighbours.
    | Ring
    /// Cells beyond the edges are always dead.
    | Zero

module Boundary =
    let toggle =
        function
        | Ring -> Zero
        | Zero -> Ring

/// One generation: a line of cells, true is alive.
type Row = Row of bool[]

module Row =
    let length (Row cells) = cells.Length

    /// Number of live cells.
    let alive (Row cells) =
        Array.sumBy (fun alive -> if alive then 1 else 0) cells

    /// Share of live cells, from 0 to 1.
    let share row =
        float (alive row) / float (length row)

    /// A row of the given width with a single live cell in the middle.
    let single width =
        Row(Array.init width (fun i -> i = width / 2))

    /// A row of the given width with no live cells.
    let empty width = Row(Array.zeroCreate width)

    /// A row of the given width where each cell is alive with the probability `density`.
    let random (rng: System.Random) density width =
        Row(Array.init width (fun _ -> rng.NextDouble() < density))

    /// The same row with the cell at the index flipped.
    let toggle index (Row cells) =
        Row(Array.mapi (fun i alive -> if i = index then not alive else alive) cells)

    /// The cell at the index, which may lie beyond the edges.
    let cell boundary (Row cells) index =
        let n = cells.Length

        match boundary with
        | Ring -> cells[(index % n + n) % n]
        | Zero -> index >= 0 && index < n && cells[index]

    let next boundary rule (Row cells as row) =
        let get = cell boundary row
        Row(Array.init cells.Length (fun i -> applyRule rule (get (i - 1)) (get i) (get (i + 1))))

/// Ring buffer with the last generations, as many as fit in the window:
/// when it is full, a new row overwrites the oldest one.
type History(capacity: int) =
    let rows: Row[] = Array.zeroCreate capacity
    let mutable start = 0
    let mutable count = 0
    let mutable total = 0

    member _.Capacity = capacity

    /// Number of rows kept, at most the capacity.
    member _.Count = count

    /// Number of rows added since the start, including the overwritten ones.
    member _.Total = total

    /// Row i, from 0 (the oldest kept) to Count - 1 (the newest).
    member _.Item
        with get i =
            if i < 0 || i >= count then
                raise (System.ArgumentOutOfRangeException(nameof i))

            rows[(start + i) % capacity]

    member this.Last = this[count - 1]

    member _.Add row =
        if count < capacity then
            rows[(start + count) % capacity] <- row
            count <- count + 1
        else
            rows[start] <- row
            start <- (start + 1) % capacity

        total <- total + 1

type Automaton =
    { Rule: Rule
      Boundary: Boundary
      History: History }

module Automaton =
    /// Starts the evolution from the row, keeping at most `capacity` generations.
    let create capacity rule boundary row =
        let history = History capacity
        history.Add row

        { Rule = rule
          Boundary = boundary
          History = history }

    /// Number of the newest generation, the first row is generation 0.
    let generation automaton = automaton.History.Total - 1

    /// Computes the next generation and adds it to the history.
    let step automaton =
        automaton.History.Add(Row.next automaton.Boundary automaton.Rule automaton.History.Last)
