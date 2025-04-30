use std::{
    io, mem,
    ops::{Deref, DerefMut},
    ptr,
};

use num::BigUint;
use windows_sys::{
    s, Win32::{
        Foundation::{self, FALSE, TRUE},
        Storage::FileSystem,
        System::{Threading, IO},
    }
};

const BUF: [u8; 4196] = [b'a'; 4196];
const BUF_WRITE_TIMES: usize = 500000;

pub struct HandleGuard(Foundation::HANDLE);

impl Drop for HandleGuard {
    fn drop(&mut self) {
        unsafe {
            Foundation::CloseHandle(self.0);
        }
    }
}

impl Deref for HandleGuard {
    type Target = Foundation::HANDLE;

    fn deref(&self) -> &Self::Target {
        &self.0
    }
}

impl DerefMut for HandleGuard {
    fn deref_mut(&mut self) -> &mut Self::Target {
        &mut self.0
    }
}

fn main() {
    let input = dialoguer::Select::new()
        .with_prompt("Select action")
        .item("Sync benchmark")
        .item("Async benchmark")
        .interact()
        .unwrap();

    match input {
        0 => bench_sync().unwrap(),
        1 => bench_async().unwrap(),
        _ => unreachable!(),
    };
}

fn bench_sync() -> io::Result<()> {
    println!("Starting writing garbage to data.txt");

    unsafe {
        let file = open_for_writing(s!("data.txt"), false)?;

        for _ in 0..BUF_WRITE_TIMES {
            write(*file, &BUF)?;
        }
    }

    println!("Finished writing garbage to data.txt");
    println!("Starting computation");
    let computation = fib(250000).to_string();
    println!("Finished computation.");

    unsafe {
        let file = open_for_writing(s!("result.txt"), false)?;
        write(*file, computation.as_bytes())?;
    }
    println!("Result has been written to result.txt");

    Ok(())
}

fn bench_async() -> io::Result<()> {
    unsafe {
        let file = open_for_writing(s!("data.txt"), true)?;
        let event = Threading::CreateEventA(
            ptr::null(),
            TRUE,
            FALSE,
            ptr::null(),
        );
        if event.is_null() {
            return Err(io::Error::last_os_error());
        }

        let mut state = AsyncWriteState {
            overlapped: mem::zeroed(),
            handle: *file,
            event,
            count: BUF_WRITE_TIMES,
            buf: &BUF,
        };
        state.overlapped.Anonymous.Anonymous.Offset = 0xFFFFFFFF;
        state.overlapped.Anonymous.Anonymous.OffsetHigh = 0xFFFFFFFF;
        let ptr = &mut state as *mut AsyncWriteState as *mut IO::OVERLAPPED;
        write_async(*file, &BUF, ptr, Some(async_write_routine))?;

        loop {
            let ret = Threading::WaitForSingleObjectEx(event, Threading::INFINITE, TRUE);
            if ret == 0 {
                break;
            }
        }

    }

    Ok(())
}

#[repr(C)]
struct AsyncWriteState<'a> {
    overlapped: IO::OVERLAPPED,
    handle: Foundation::HANDLE,
    event: Foundation::HANDLE,
    count: usize,
    buf: &'a [u8],
}

#[allow(unused)]
unsafe extern "system" fn async_write_routine(
    error_code: u32,
    bytes_transferred: u32,
    overlapped: *mut IO::OVERLAPPED,
) {
    unsafe {
        let state: &mut AsyncWriteState = &mut *(overlapped as *mut AsyncWriteState);
        if (state.count > 0) {
            state.count -= 1;
            let ret = FileSystem::WriteFileEx(
                state.handle,
                state.buf.as_ptr(),
                state.buf.len() as u32,
                overlapped,
                Some(async_write_routine),
            );
            if ret == FALSE {
                eprintln!("Error writing to file: {:?}", io::Error::last_os_error());
            }
        } else {
            Threading::SetEvent(state.event);
        }
    }
}

unsafe fn open_for_writing(name: *const u8, overlapped: bool) -> io::Result<HandleGuard> {
    let flags = match overlapped {
        true => FileSystem::FILE_FLAG_OVERLAPPED,
        false => 0,
    };

    let file = unsafe {
        FileSystem::CreateFileA(
            name,
            Foundation::GENERIC_WRITE,
            FileSystem::FILE_SHARE_WRITE,
            ptr::null(),
            FileSystem::CREATE_ALWAYS,
            flags,
            ptr::null_mut(),
        )
    };

    if file.is_null() {
        return Err(io::Error::last_os_error());
    }

    Ok(HandleGuard(file))
}

unsafe fn write(file: Foundation::HANDLE, buf: &[u8]) -> io::Result<usize> {
    unsafe {
        let mut written: u32 = mem::zeroed();
        let ret = FileSystem::WriteFile(
            file,
            buf.as_ptr(),
            buf.len() as u32,
            &mut written,
            ptr::null_mut(),
        );

        if ret == FALSE {
            return Err(io::Error::last_os_error());
        }

        Ok(written as usize)
    }
}

unsafe fn write_async(
    file: Foundation::HANDLE,
    buf: &[u8],
    overlapped: *mut IO::OVERLAPPED,
    routine: Option<unsafe extern "system" fn(u32, u32, *mut IO::OVERLAPPED)>,
) -> io::Result<()> {
    unsafe {
        let ret =
            FileSystem::WriteFileEx(file, buf.as_ptr(), buf.len() as u32, overlapped, routine);

        if ret == FALSE {
            return Err(io::Error::last_os_error());
        }
    }

    Ok(())
}

fn fib(n: usize) -> BigUint {
    let mut f0 = BigUint::ZERO;
    let mut f1 = BigUint::from(1u32);
    for _ in 0..n {
        let f2 = f0 + &f1;
        f0 = f1;
        f1 = f2;
    }
    f0
}
