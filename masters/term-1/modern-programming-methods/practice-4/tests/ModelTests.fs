module ModelTests

open Expecto
open FsCheck

open Model

/// Runs the automaton for the given number of steps and returns every generation, the first row
/// included. The history is large enough to keep them all.
let evolve rule steps row =
    let automaton = Automaton.create (steps + 1) rule Ring row

    for _ in 1 .. steps do
        Automaton.step automaton

    [ for i in 0 .. automaton.History.Count - 1 -> automaton.History[i] ]

let cells (Row cells) = cells
let alive row = cells row |> Array.filter id |> Array.length

/// Moves every cell `shift` positions to the right, wrapping around.
let rotate shift (Row cells) =
    let n = cells.Length
    Row(Array.init n (fun i -> cells[((i - shift) % n + n) % n]))

let rules =
    testList
        "applyRule"
        [
            test "follows the binary representation of every rule number" {
                for rule in 0 .. 255 do
                    for index in 0 .. 7 do
                        let left, middle, right = index &&& 4 <> 0, index &&& 2 <> 0, index &&& 1 <> 0
                        let expected = (rule >>> index) &&& 1 = 1

                        Expect.equal
                            (applyRule (Rule(byte rule)) left middle right)
                            expected
                            $"rule {rule}, neighbourhood {index}"
            }

            test "rule 30 gives the table from the README" {
                let table =
                    [ for index in 7 .. -1 .. 0 -> applyRule (Rule 30uy) (index &&& 4 <> 0) (index &&& 2 <> 0) (index &&& 1 <> 0) ]

                Expect.equal table [ false; false; false; true; true; true; true; false ] "111 … 000 → 00011110"
            }

            test "next and previous wrap around between 255 and 0" {
                Expect.equal (Rule.next (Rule 255uy)) (Rule 0uy) "after 255"
                Expect.equal (Rule.previous (Rule 0uy)) (Rule 255uy) "before 0"
            }

            testProperty "previous undoes next" (fun (rule: byte) ->
                Rule.previous (Rule.next (Rule rule)) = Rule rule)

            test "tryParse reads every rule number" {
                for number in 0 .. 255 do
                    Expect.equal (Rule.tryParse (string number)) (Some(Rule(byte number))) $"{number}"
            }

            testProperty "tryParse rejects numbers above 255" (fun (PositiveInt above) ->
                Rule.tryParse (string (255 + above)) = None)

            test "tryParse rejects anything but digits" {
                for text in [ ""; "-1"; "+3"; " 30"; "30 "; "3a"; "1.5" ] do
                    Expect.isNone (Rule.tryParse text) $"\"{text}\""
            }

            test "table lists the neighbourhoods from 111 to 000" {
                let table = Rule.table (Rule 30uy)
                Expect.equal (List.map fst table) [ 7 .. -1 .. 0 ] "neighbourhood order"
                Expect.equal (List.map snd table) [ false; false; false; true; true; true; true; false ] "rule 30"
                Expect.equal (Rule.neighbourhood 6) (true, true, false) "110"
            }

            testProperty "the table spells the rule number in binary" (fun (rule: byte) ->
                let bits = Rule.table (Rule rule) |> List.fold (fun n (_, alive) -> 2 * n + (if alive then 1 else 0)) 0
                bits = int rule)

            testProperty "flip changes the new state of exactly one neighbourhood" (fun (rule: byte) (index: byte) ->
                let index = int index % 8
                let flipped = Rule.flip index (Rule rule)

                List.forall2
                    (fun (i, before) (_, after) -> (before <> after) = (i = index))
                    (Rule.table (Rule rule))
                    (Rule.table flipped)
                && Rule.flip index flipped = Rule rule)
        ]

let rows =
    testList
        "Row"
        [
            test "single has one live cell in the middle" {
                Expect.equal (cells (Row.single 5)) [| false; false; true; false; false |] "odd width"
                let even = cells (Row.single 200)
                Expect.equal (Array.filter id even).Length 1 "one live cell"
                Expect.isTrue even[100] "the middle of an even width"
            }

            testProperty "alive counts the live cells and share divides them by the length" (fun (NonEmptyArray row) ->
                Row.alive (Row row) = alive (Row row)
                && Row.share (Row row) = float (alive (Row row)) / float row.Length)

            test "empty has no live cells" {
                Expect.equal (Row.length (Row.empty 7)) 7 "width"
                Expect.equal (alive (Row.empty 7)) 0 "no live cells"
            }

            testProperty "random with density 0 is empty and with density 1 is full" (fun (seed: int) (PositiveInt width) ->
                let rng = System.Random seed
                alive (Row.random rng 0.0 width) = 0 && alive (Row.random rng 1.0 width) = width)

            test "random keeps the requested density" {
                let rng = System.Random 2026
                let width = 10000

                for density in [ 0.1; 0.5; 0.9 ] do
                    let share = float (alive (Row.random rng density width)) / float width
                    Expect.floatClose { absolute = 0.03; relative = 0.0 } share density $"density {density}"
            }

            testProperty "toggle flips exactly the given cell" (fun (NonEmptyArray row) (NonNegativeInt index) ->
                let index = index % row.Length
                let toggled = cells (Row.toggle index (Row row))

                Array.forall2 (fun i (a, b) -> (a <> b) = (i = index)) [| 0 .. row.Length - 1 |] (Array.zip row toggled)
                && Row.toggle index (Row toggled) = Row row)

            test "the first and the last cells are neighbours" {
                // Rule 90 sets a cell to left xor right, so a live last cell revives the first one.
                let next = Row.next Ring (Rule 90uy) (Row [| false; false; false; false; true |])
                Expect.equal (cells next) [| true; false; false; true; false |] "wraps around both edges"
            }

            test "toggling the boundary switches between ring and zero edges" {
                Expect.equal (Boundary.toggle Ring) Zero "ring"
                Expect.equal (Boundary.toggle Zero) Ring "zero"
            }

            test "with zero edges, nothing lies beyond the edges" {
                let next = Row.next Zero (Rule 90uy) (Row [| false; false; false; false; true |])
                Expect.equal (cells next) [| false; false; false; true; false |] "the first cell stays dead"
            }

            testProperty "zero edges are a ring with a dead cell added at each end" (fun (rule: byte) (NonEmptyArray row) ->
                let padded = Row(Array.concat [ [| false |]; row; [| false |] ])
                let ring = cells (Row.next Ring (Rule rule) padded)
                cells (Row.next Zero (Rule rule) (Row row)) = ring[1 .. row.Length])

            testProperty "next keeps the row length" (fun (boundary: Boundary) (rule: byte) (NonEmptyArray row) ->
                Row.length (Row.next boundary (Rule rule) (Row row)) = row.Length)

            testProperty "on a ring, rotating and stepping commute" (fun (rule: byte) (NonEmptyArray row) (shift: int) ->
                let rule = Rule rule
                Row.next Ring rule (rotate shift (Row row)) = rotate shift (Row.next Ring rule (Row row)))
        ]

let knownRules =
    testList
        "Known rules"
        [
            test "rule 90 from one cell gives the Sierpinski triangle" {
                // Cell k of generation t (counted from the centre) is the binomial coefficient
                // C(t, (t + k) / 2) mod 2, which by Lucas' theorem is odd when j &&& t = j.
                let steps = 32
                let width = 2 * steps + 1
                let centre = width / 2

                evolve (Rule 90uy) steps (Row.single width)
                |> List.iteri (fun t row ->
                    let expected =
                        Array.init width (fun i ->
                            let k = i - centre
                            let j = (t + k) / 2
                            abs k <= t && (t + k) % 2 = 0 && j &&& t = j)

                    Expect.equal (cells row) expected $"generation {t}")
            }

            test "the centre column of rule 30 is OEIS A051023" {
                let expected =
                    [ 1; 1; 0; 1; 1; 1; 0; 0; 1; 1; 0; 0; 0; 1; 0; 1; 1; 0; 0; 1; 0; 0; 1; 1; 1 ]

                let steps = expected.Length - 1
                let width = 2 * steps + 1

                let column =
                    evolve (Rule 30uy) steps (Row.single width)
                    |> List.map (fun row -> if (cells row)[width / 2] then 1 else 0)

                Expect.equal column expected "first 25 terms"
            }

            testProperty "rule 184 on a ring keeps the number of live cells" (fun (NonEmptyArray row) ->
                evolve (Rule 184uy) 20 (Row row) |> List.forall (fun r -> alive r = alive (Row row)))

            testProperty "rule 0 kills every cell in one step" (fun (boundary: Boundary) (NonEmptyArray row) ->
                alive (Row.next boundary (Rule 0uy) (Row row)) = 0)

            testProperty "rule 255 revives every cell in one step" (fun (boundary: Boundary) (NonEmptyArray row) ->
                alive (Row.next boundary (Rule 255uy) (Row row)) = row.Length)

            test "rule 184 with zero edges lets cars leave on the right" {
                // A live cell moves right when the cell to its right is empty; at the edge it drops off.
                let rows =
                    List.scan (fun row _ -> Row.next Zero (Rule 184uy) row) (Row [| true; false; true |]) [ 1..3 ]

                Expect.equal (List.map alive rows) [ 2; 1; 1; 0 ] "live cells per generation"
            }
        ]

let history =
    testList
        "History"
        [
            testProperty "keeps the newest rows in order" (fun (PositiveInt capacity) (NonNegativeInt added) ->
                let history = History capacity
                let rows = [ for i in 0 .. added - 1 -> Row [| i % 2 = 0; i % 3 = 0 |] ]
                rows |> List.iter history.Add

                let kept = [ for i in 0 .. history.Count - 1 -> history[i] ]

                history.Count = min capacity added
                && history.Total = added
                && kept = List.skip (added - history.Count) rows)

            test "rejects indices outside the kept rows" {
                let history = History 3

                for i in 1 .. 5 do
                    history.Add(Row.single i)

                Expect.throwsT<System.ArgumentOutOfRangeException> (fun () -> history[3] |> ignore) "past the end"
                Expect.throwsT<System.ArgumentOutOfRangeException> (fun () -> history[-1] |> ignore) "negative"
            }

            test "automaton counts generations from zero" {
                let automaton = Automaton.create 3 (Rule 30uy) Ring (Row.single 9)
                Expect.equal (Automaton.generation automaton) 0 "first row"

                for _ in 1 .. 10 do
                    Automaton.step automaton

                Expect.equal (Automaton.generation automaton) 10 "after ten steps"
                Expect.equal automaton.History.Count 3 "only the capacity is kept"
            }
        ]

let tests = testList "Model" [ rules; rows; knownRules; history ]
