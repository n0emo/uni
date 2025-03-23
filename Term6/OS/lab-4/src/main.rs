use std::ffi::c_void;

use iced_x86::code_asm;
use windows_sys::{
    Win32::System::{
        LibraryLoader::{GetModuleHandleA, GetProcAddress},
        Memory::{
            MEM_COMMIT, MEM_RELEASE, MEM_RESERVE, PAGE_EXECUTE_READWRITE, VirtualAlloc, VirtualFree,
        },
    },
    s,
};

struct VirtualBox {
    ptr: *mut c_void,
    size: usize,
}

impl Drop for VirtualBox {
    fn drop(&mut self) {
        unsafe {
            VirtualFree(self.ptr, self.size, MEM_RELEASE);
        }
    }
}

fn main() {
    let args: Vec<String> = std::env::args().collect();
    let Some(path) = args.get(1) else {
        eprintln!(
            "Usage: {} <path>",
            args.get(0).map(String::as_str).unwrap_or_else(|| "bfjit")
        );
        std::process::exit(1);
    };

    let bf = match std::fs::read_to_string(path) {
        Ok(bf) => bf,
        Err(e) => {
            eprintln!("Error reading file: {e}");
            std::process::exit(1);
        }
    };

    let program = unsafe {
        let asm = match assemble(&bf) {
            Ok(asm) => asm,
            Err(e) => {
                eprintln!("Error assembling file: {e}");
                std::process::exit(1);
            }
        };

        let size = asm.len();
        let ptr = VirtualAlloc(
            0 as *const c_void,
            size,
            MEM_COMMIT | MEM_RESERVE,
            PAGE_EXECUTE_READWRITE,
        );
        std::ptr::copy(asm.as_ptr() as *const c_void, ptr, size);

        VirtualBox { ptr, size }
    };

    unsafe {
        let program: extern "C" fn() -> i32 = std::mem::transmute(program.ptr);
        let ret = program();
        std::process::exit(ret);
    }
}

unsafe fn get_windows_fn(name: *const u8) -> *const c_void {
    unsafe {
        std::mem::transmute(
            GetProcAddress(GetModuleHandleA(s!("kernel32.dll")), name)
                .expect("Could not get Windows function"),
        )
    }
}

fn assemble(program: &str) -> Result<Vec<u8>, code_asm::IcedError> {
    use iced_x86::code_asm::*;
    let _ = program;

    const STDOUT_QUERY: i32 = -11;

    let get_std_handle = unsafe { get_windows_fn(s!("GetStdHandle")) };
    let write_file = unsafe { get_windows_fn(s!("WriteFile")) };

    let mut a = CodeAssembler::new(64)?;
    let mut data = a.create_label();

    let shadow = 40;
    a.sub(rsp, shadow)?;

    a.mov(ecx, STDOUT_QUERY)?;
    a.call(get_std_handle as u64)?;
    a.and(qword_ptr(rsp) + 32, 0)?;

    a.mov(rcx, rax)?;
    a.lea(rdx, ptr(data))?;
    a.xor(r9, r9)?;
    a.mov(r8, 14u64)?;
    a.call(write_file as u64)?;

    a.add(rsp, shadow)?;

    a.xor(rax, rax)?;
    a.ret()?;

    a.set_label(&mut data)?;
    a.db(b"Hello, World!\n")?;

    a.assemble(0)
}
