#[derive(Debug, Clone, Copy)]
pub enum IntermediateInstruction {
    IncrementPointer,
    DecrementPointer,
    IncrementValue,
    DecrementValue,
    Output,
    Accept,
    LoopStart,
    LoopEnd,
}

pub fn parse_bf(program: &[u8]) -> Result<Vec<IntermediateInstruction>, String> {
    let mut result = Vec::new();
    let mut brace_counter = 0;
    for c in program {
        match *c {
            b'>' => result.push(IntermediateInstruction::IncrementPointer),
            b'<' => result.push(IntermediateInstruction::DecrementPointer),
            b'+' => result.push(IntermediateInstruction::IncrementValue),
            b'-' => result.push(IntermediateInstruction::DecrementValue),
            b'.' => result.push(IntermediateInstruction::Output),
            b',' => result.push(IntermediateInstruction::Accept),
            b'[' => {
                result.push(IntermediateInstruction::LoopStart);
                brace_counter -= 1;
            }
            b']' => {
                result.push(IntermediateInstruction::LoopEnd);
                brace_counter += 1;
            }
            _ => { }
        }
    }

    if brace_counter != 0 {
        return Err(String::from("Syntax error: Unmatched braces"));
    }

    Ok(result)
}
