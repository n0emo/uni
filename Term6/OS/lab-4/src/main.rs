use std::ffi::c_void;

use utils::VirtualBox;
use windows_sys::Win32::System::Memory::{
    MEM_COMMIT, MEM_RESERVE, PAGE_EXECUTE_READWRITE, VirtualAlloc,
};

mod compile;
mod parse;
mod utils;

fn main() {
    let args: Vec<String> = std::env::args().collect();
    let Some(path) = args.get(1) else {
        eprintln!(
            "Usage: {} <path>",
            args.get(0).map(String::as_str).unwrap_or_else(|| "bfjit")
        );
        std::process::exit(1);
    };

    let bf = match std::fs::read(path) {
        Ok(bf) => bf,
        Err(e) => {
            eprintln!("Error reading file: {e}");
            std::process::exit(1);
        }
    };

    let il = parse::parse_bf(&bf);

    let asm = match compile::assemble_x64(&il) {
        Ok(asm) => asm,
        Err(e) => {
            eprintln!("Error assembling file: {e}");
            std::process::exit(1);
        }
    };

    let program = unsafe {
        let size = asm.len();
        let ptr = VirtualAlloc(
            0 as *const c_void,
            size,
            MEM_COMMIT | MEM_RESERVE,
            PAGE_EXECUTE_READWRITE,
        );
        std::ptr::copy(asm.as_ptr() as *const c_void, ptr, size);

        VirtualBox::from_raw_parts(ptr, size)
    };

    unsafe {
        let program: extern "C" fn() -> i32 = std::mem::transmute(program.as_mut_ptr());
        let ret = program();
        std::process::exit(ret);
    }
}
