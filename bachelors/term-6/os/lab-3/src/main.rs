use std::{ffi::c_void, io, mem};

use windows_sys::Win32::{
    Foundation::{FALSE, GetLastError, INVALID_HANDLE_VALUE},
    System::{
        Console::{GetStdHandle, STD_OUTPUT_HANDLE, WriteConsoleA},
        Memory::{
            GetProcessHeap, HeapAlloc, HeapCreate, HeapDestroy, HeapFree, HeapLock, HeapUnlock,
            HeapWalk, PROCESS_HEAP_ENTRY,
        },
        SystemServices::{
            PROCESS_HEAP_ENTRY_BUSY, PROCESS_HEAP_ENTRY_DDESHARE, PROCESS_HEAP_ENTRY_MOVEABLE,
            PROCESS_HEAP_REGION, PROCESS_HEAP_UNCOMMITTED_RANGE,
        },
    },
};

fn main() {
    let action = dialoguer::Select::new()
        .with_prompt("Select action")
        .item("Enumerate heap")
        .item("Copy s1 to dynamic heap and print")
        .item("Copy s2 to dynamic heap and print")
        .interact()
        .unwrap();

    match action {
        0 => unsafe {
            let default_heap = GetProcessHeap();
            enumerate_heap(default_heap).unwrap();
        },

        1 | 2 => {
            let s = if action == 1 {
                String::from("Hello, this is example string!")
            } else {
                String::from("Lorem ipsum dolor sit amet")
            };

            copy_some_string_around(s).unwrap();
        }
        _ => unreachable!(),
    }
}

unsafe fn enumerate_heap(hhandle: *mut c_void) -> Result<(), io::Error> {
    println!("Enumerating Heap:");

    unsafe {
        if HeapLock(hhandle) == FALSE {
            return Err(io::Error::from_raw_os_error(GetLastError() as i32));
        };

        let mut entry: PROCESS_HEAP_ENTRY = mem::zeroed();

        while HeapWalk(hhandle, &mut entry) != FALSE {
            let f = entry.wFlags as u32;
            if f & PROCESS_HEAP_ENTRY_BUSY != 0 {
                println!("  Allocated Block");
                if f & PROCESS_HEAP_ENTRY_MOVEABLE != 0 {
                    println!("    Movable with handle: {:p}", entry.Anonymous.Block.hMem);
                }

                if f & PROCESS_HEAP_ENTRY_DDESHARE != 0 {
                    println!("    DDESHARE")
                }
            } else if f & PROCESS_HEAP_REGION != 0 {
                let r = entry.Anonymous.Region;
                println!("  Memory region");
                println!("    Bytes commited: {}", r.dwCommittedSize);
                println!("    Bytes uncommited: {}", r.dwUnCommittedSize);
                println!("    First block address: {:p}", r.lpFirstBlock);
                println!("    Last block address: {:p}", r.lpLastBlock);
            } else if f & PROCESS_HEAP_UNCOMMITTED_RANGE != 0 {
                println!("  Uncommited range");
            } else {
                println!("  Block");
            }

            println!("    Data portion begins at: {:p}", entry.lpData);
            println!("    Size: {}", entry.cbData);
            println!("    Overhead: {}", entry.cbOverhead);
            println!("    Region index: {}", entry.iRegionIndex);
        }

        if HeapUnlock(hhandle) == FALSE {
            return Err(io::Error::from_raw_os_error(GetLastError() as i32));
        };
    }

    Ok(())
}

fn copy_some_string_around(s: String) -> Result<(), io::Error> {
    let size = s.len();

    unsafe {
        let heap = HeapCreate(0, 0, 0);
        if heap.is_null() {
            return Err(io::Error::from_raw_os_error(GetLastError() as i32));
        }

        let ptr = HeapAlloc(heap, 0, size) as *mut u8;
        if ptr.is_null() {
            return Err(io::Error::from_raw_os_error(GetLastError() as i32));
        }

        std::ptr::copy(s.as_ptr(), ptr, size);
        let hout = GetStdHandle(STD_OUTPUT_HANDLE);
        if hout == INVALID_HANDLE_VALUE {
            return Err(io::Error::from_raw_os_error(GetLastError() as i32));
        }

        let ret = WriteConsoleA(hout, ptr, size as u32, 0 as *mut u32, 0 as *const c_void);
        if ret == FALSE {
            return Err(io::Error::from_raw_os_error(GetLastError() as i32));
        }

        HeapFree(heap, 0, ptr as *const c_void);
        HeapDestroy(heap);
    }

    Ok(())
}
