use std::ffi::c_void;

use windows_sys::{
    Win32::System::{
        LibraryLoader::{GetModuleHandleA, GetProcAddress},
        Memory::{MEM_RELEASE, VirtualFree},
    },
    s,
};

pub struct VirtualBox<T> {
    ptr: *mut T,
    size: usize,
}

impl<T> VirtualBox<T> {
    pub fn from_raw_parts(ptr: *mut T, size: usize) -> Self {
        Self { ptr, size }
    }

    pub fn as_mut_ptr(self) -> *mut T {
        self.ptr
    }
}

impl<T> Drop for VirtualBox<T> {
    fn drop(&mut self) {
        unsafe {
            VirtualFree(self.ptr as *mut c_void, self.size, MEM_RELEASE);
        }
    }
}

pub unsafe fn get_windows_fn(name: *const u8) -> *const c_void {
    unsafe {
        std::mem::transmute(
            GetProcAddress(GetModuleHandleA(s!("kernel32.dll")), name)
                .expect("Could not get Windows function"),
        )
    }
}
