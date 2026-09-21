use iced_x86::code_asm;
use windows_sys::s;

use crate::{parse::IntermediateInstruction, utils::get_windows_fn};

pub fn assemble_x64(program: &[IntermediateInstruction]) -> Result<Vec<u8>, code_asm::IcedError> {
    use iced_x86::code_asm::*;

    const STDIN_QUERY: i32 = -10;
    const STDOUT_QUERY: i32 = -11;

    let get_std_handle = unsafe { get_windows_fn(s!("GetStdHandle")) };
    let write_file = unsafe { get_windows_fn(s!("WriteFile")) };
    let read_file = unsafe { get_windows_fn(s!("ReadFile")) };

    let mut a = CodeAssembler::new(64)?;
    let mut data = a.create_label();
    let mut hout = a.create_label();
    let mut hin = a.create_label();

    let mut loop_stack = Vec::new();

    let shadow = 64;
    a.sub(rsp, shadow)?;

    a.mov(ecx, STDIN_QUERY)?;
    a.call(get_std_handle as u64)?;
    a.mov(ptr(hin), rax)?;

    a.mov(ecx, STDOUT_QUERY)?;
    a.call(get_std_handle as u64)?;
    a.mov(ptr(hout), rax)?;

    a.lea(rsi, ptr(data))?;
    for instr in program {
        match instr {
            IntermediateInstruction::IncrementPointer => a.inc(rsi)?,
            IntermediateInstruction::DecrementPointer => a.dec(rsi)?,
            IntermediateInstruction::IncrementValue => a.inc(byte_ptr(rsi))?,
            IntermediateInstruction::DecrementValue => a.dec(byte_ptr(rsi))?,
            IntermediateInstruction::Output => {
                a.and(qword_ptr(rsp) + 32, 0)?;
                a.mov(rcx, ptr(hout))?;
                a.mov(rdx, rsi)?;
                a.xor(r9, r9)?;
                a.mov(r8, 1u64)?;
                a.call(write_file as u64)?;
            }
            IntermediateInstruction::Accept => {
                a.and(qword_ptr(rsp) + 32, 0)?;
                a.mov(rcx, ptr(hin))?;
                a.mov(rdx, rsi)?;
                a.xor(r9, r9)?;
                a.mov(r8, 1u64)?;
                a.call(read_file as u64)?;
            }
            IntermediateInstruction::LoopStart => {
                let mut loop_start = a.create_label();
                let loop_end = a.create_label();

                a.set_label(&mut loop_start)?;
                a.mov(al, byte_ptr(rsi))?;
                a.test(al, al)?;
                a.jz(loop_end)?;

                loop_stack.push((loop_start, loop_end));
            }
            IntermediateInstruction::LoopEnd => {
                let (loop_start, mut loop_end) = loop_stack.pop().unwrap();
                a.jmp(loop_start)?;
                a.set_label(&mut loop_end)?;
            }
        };
    }

    a.add(rsp, shadow)?;

    a.xor(rax, rax)?;
    a.ret()?;

    a.set_label(&mut data)?;
    a.db(&[0; 30000])?;

    a.set_label(&mut hin)?;
    a.db(&[0; 8])?;
    a.set_label(&mut hout)?;
    a.db(&[0; 8])?;

    a.assemble(0)
}
