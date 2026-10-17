#import "../common.typ": *

#show: report.with(number: "3", title: "Исследование динамической памяти")

== Цель работы

Изучить средства работы с динамической памятью с помощью Windows API.

== Задание

Разработать приложение, которое выполняет следующие действия:

- Получает идентификатор стандартного пула;
- Определяет максимальный размер блока памяти в стандартном пуле;
- Создает динамический пул максимально возможного размера;
- Передает данные (по заданию преподавателя) из стандартного в динамический пул;
- Отображает принятые и переданные данные.

== Введение

Для выполнения данной лабораторной работы был выбран системный язык программирования Rust. Windows
предоставляет для этого языка официальные привязки к Windows API в лице крейта windows-sys.

== Ход работы

Для организации проекта был выбран Cargo. Он позволяет автоматически загрузить и скомпилировать
необходимые зависимости вместе с программой. Таблица зависимостей из файла Cargo.toml представлена
далее:

```toml
[dependencies]
dialoguer = "0.11.0"
windows-sys = { version = "0.59.0", features = [
    "Win32_System_Console",
    "Win32_System_Memory",
    "Win32_System_SystemServices"
] }
```

dialoguer позволяет создать интерактивный диалог в консоли. В свою очередь windows-sys является
официальным крейтом от Microsoft для работы с Windows. Поскольку у данной программы нет
необходимости во всём многообразии возможных функций Windows API, с помощью Cargo features выбраны
только средства работы с консолью, памятью и системными сервисами (последние необходимы для
некоторых констант).

Следующие листинги будут частью одного файла -- main.rs, содержащего в себе всю программу. Первыми
представлены импорты программы -- то есть определение модулей и функций, которые будут добавлены в
область видимости файла.

```rust
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
```

Входная точка программы выглядит следующим образом: сначала с помощью dialoguer у пользователя
спрашивается требуемое действие, а далее в зависимости от его выбора происходит либо обход кучи,
либо копирование строки из динамической памяти по умолчанию в новый динамический пул и её вывод в
консоль.

```rust
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
```

Реализация функции обхода кучи выглядит следующим образом:

```rust
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
```

Эта функция помечена ключевым словом unsafe, поскольку она накладывает на вызывающего необходимость
в проверке валидности аргумента hhandle. Внутри можно заметить блокировку кучи и её обход с помощью
функции HeapWalk.

Далее последует реализация функции копирования и вывода строки:

```rust
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
```

Обратите внимание на обработку ошибок. Rust предоставляет стандартный тип Result, который может
содержать в себе либо значение при успехе, либо ошибку.

=== Демонстрация работы приложения

Программу можно запустить, введя в консоль cargo run. Диспетчер пакетов cargo проверит зависимости,
соберёт и запустит программу (см. рисунок~@fig-menu).

#figure(
  caption: "Меню выбора действия",
  image("./assets/menu.png", width: 70%),
) <fig-menu>

При выборе первого пункта выполняется обход кучи по умолчанию (см. рисунок~@fig-enumerate).

#figure(
  caption: "Результат обхода кучи",
  image("./assets/enumerate-heap.png", width: 70%),
) <fig-enumerate>

При выборе второго и третьего пунктов строка копируется в новый динамический пул и выводится в
консоль (см. рисунок~@fig-copy).

#figure(
  caption: "Копирование строк в динамический пул и их вывод",
  image("./assets/copy-string.png", width: 90%),
) <fig-copy>

== Выводы

В ходе работы были изучены средства работы с динамической памятью с помощью Windows API и
разработано приложение, выполняющее обход стандартной кучи и копирование строк в новый динамический
пул.

#appendixes[
  = Исходный текст программы

  #code-file(read("./src/main.rs"), name: "main.rs")
]
