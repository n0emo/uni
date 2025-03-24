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

pub fn parse_bf(program: &[u8]) -> Vec<IntermediateInstruction> {
    let mut result = Vec::new();
    let mut stack = Vec::new();
    let mut i = 0;
    for c in program {
        match *c {
            b'>' => result.push(IntermediateInstruction::IncrementPointer),
            b'<' => result.push(IntermediateInstruction::DecrementPointer),
            b'+' => result.push(IntermediateInstruction::IncrementValue),
            b'-' => result.push(IntermediateInstruction::DecrementValue),
            b'.' => result.push(IntermediateInstruction::Output),
            b',' => result.push(IntermediateInstruction::Accept),
            b'[' => {
                stack.push(i);
                result.push(IntermediateInstruction::LoopStart);
            }
            b']' => {
                let _start = stack.pop().unwrap();
                result.push(IntermediateInstruction::LoopEnd);
            }
            _ => {
                i -= 1;
            }
        }

        i += 1;
    }
    result
}
