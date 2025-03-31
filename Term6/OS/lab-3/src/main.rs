use std::{ffi::c_void, mem};

use windows_sys::Win32::System::Console;
use windows_sys::Win32::System::SystemServices::{
    PROCESS_HEAP_ENTRY_BUSY, PROCESS_HEAP_ENTRY_DDESHARE, PROCESS_HEAP_ENTRY_MOVEABLE,
    PROCESS_HEAP_REGION, PROCESS_HEAP_UNCOMMITTED_RANGE,
};
use windows_sys::Win32::{Foundation::FALSE, System::Memory};

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
            let default_heap = Memory::GetProcessHeap();
            enumerate_heap(default_heap);
        },

        1 | 2 => {
            let s = if action == 1 {
                String::from("Hello, this is example string!")
            } else {
                String::from("Lorem ipsum dolor sit amet")
            };

            unsafe {
                copy_some_string_around(s);
            }
        }
        _ => unreachable!(),
    }
}

unsafe fn enumerate_heap(hhandle: *mut c_void) {
    println!("Enumerating Heap:");

    unsafe {
        Memory::HeapLock(hhandle);

        let mut entry: Memory::PROCESS_HEAP_ENTRY = mem::zeroed();

        while Memory::HeapWalk(hhandle, &mut entry) != FALSE {
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

        Memory::HeapUnlock(hhandle);
    }
}

unsafe fn copy_some_string_around(s: String) {
    let size = s.len();

    unsafe {
        let heap = Memory::HeapCreate(0, 0, 0);
        let ptr = Memory::HeapAlloc(heap, 0, size) as *mut u8;

        std::ptr::copy(s.as_ptr(), ptr, size);
        let hout = Console::GetStdHandle(Console::STD_OUTPUT_HANDLE);
        Console::WriteConsoleA(hout, ptr, size as u32, 0 as *mut u32, 0 as *const c_void);

        Memory::HeapFree(heap, 0, ptr as *const c_void);
        Memory::HeapDestroy(heap);
    }
}
