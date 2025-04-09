use std::ffi::c_void;

use windows_sys::{
    Win32::{
        Foundation::FALSE,
        System::{
            LibraryLoader::{GetModuleHandleA, GetProcAddress},
            Memory::{
                MEM_COMMIT, MEM_RELEASE, MEM_RESERVE, PAGE_EXECUTE_READWRITE, PAGE_READWRITE,
                VirtualAlloc, VirtualFree, VirtualProtect,
            },
        },
    },
    s,
};

pub struct VirtualBox<T> {
    ptr: *mut T,
    size: usize,
}

impl<T> VirtualBox<T> {
    pub unsafe fn new_with_size(size: usize) -> Self {
        let ptr = unsafe {
            VirtualAlloc(
                0 as *const c_void,
                size,
                MEM_COMMIT | MEM_RESERVE,
                PAGE_READWRITE,
            )
        };

        if ptr.is_null() {
            panic!(
                "Error allocating memory: {}",
                std::io::Error::last_os_error()
            );
        }

        unsafe { Self::from_raw_parts(ptr as *mut T, size) }
    }

    pub unsafe fn from_raw_parts(ptr: *mut T, size: usize) -> Self {
        Self { ptr, size }
    }

    pub unsafe fn make_executable(&mut self) -> Result<(), std::io::Error> {
        let ret = unsafe {
            let mut old_protect: u32 = std::mem::zeroed();
            VirtualProtect(
                self.ptr as *mut c_void,
                self.size,
                PAGE_EXECUTE_READWRITE,
                &mut old_protect,
            )
        };

        if ret == FALSE {
            return Err(std::io::Error::last_os_error());
        }

        Ok(())
    }

    pub unsafe fn copy_from(&mut self, ptr: *const T) {
        unsafe {
            std::ptr::copy(ptr, self.ptr, self.size);
        }
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
