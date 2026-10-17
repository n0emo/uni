свФЕДЕРАЛЬНОЕ АГЕНСТВО ЖЕЛЕЗНОДОРОЖНОГО ТРАНСПОРТА

Федеральное государственное бюджетное образовательное учреждение высшего
образования

«ПЕТЕРБУРГСКИЙ ГОСУДАРСТВЕННЫЙ УНИВЕРСИТЕТ ПУТЕЙ СООБЩЕНИЯ Императора
Александра I»

Кафедра «Информационные и вычислительные системы»

Дисциплина «Операционные системы»

#strong[ОТЧЁТ]

#strong[ПО ЛАБОРАТОРНОЙ РАБОТЕ №3]

#strong[«Исследование динамической памяти»]

#figure(
  align(center)[#table(
    columns: 2,
    align: (auto,auto,),
    [Выполнил студент

    Факультет: АИТ

    Группа: ИВБ-211

    ], [Шефнер А.],
    [Проверил:

    Старший преподаватель кафедры

    «Информационные и вычислительные

    системы»

    ], [Молодкин И.А.],
  )]
  , kind: table
  )

#strong[Санкт-Петербург]

#strong[2025]

Оценочный лист результатов ЛР №3

Ф.И.О. студента: #emph[Шефнер А.]

Группа \_\_\_\_\_\_\_\_\_\_\_\_\_#emph[ИВБ-211]\_\_\_\_\_\_\_\_\_\_\_\_

Старший преподаватель кафедры

«Информационные и вычислительные

системы»#strong[ «\_\_» \_\_\_\_\_\_\_\_\_\_2025 г. Молодкин И.А.]

#strong[Цель]

#strong[ ]Изучить средства работы с динамической памятью с помощью
Windows API

#strong[Задание]

Разработать приложение, которое выполняет следующие действия:

- Получает идентификатор стандартного пула;
- Определяет максимальный размер блока памяти в стандартном пуле;
- Создает динамический пул максимально возможного размера;
- Передает данные (по заданию преподавателя) из стандартного в
  динамический пул.
- Отображает принятые и переданные данные.

#strong[Введение]

Для выполнения данной лабораторной работы был выбран системный язык
программирования Rust. Windows предоставляет для этого языка официальные
привязки к Windows API в лице крейта windows-sys.

#strong[Ход Работы]

Для организации проекта был выбран Cargo. Он позволяет автоматически
загрузить и скомпилировать необходимые зависимости вместе с программой.
Таблица зависимостей из файла Cargo.toml представлена далее:

\[dependencies\]

dialoguer = \"0.11.0\"

windows-sys = { version = \"0.59.0\", features = \[

\"Win32\_System\_Console\",

\"Win32\_System\_Memory\",

\"Win32\_System\_SystemServices\"

\] }

dialoguer позволяет создать интерактивный диалог в консоли. В свою
очередь windows-sys является официальным крейтом от Microsoft для работы
с Windows. Поскольку у данной программы нет необходимости во всём
многообразии возможных функций Windows API, с помощью Cargo features
выбраны только средства работы с консолью, памятью и системными
сервисами (последние необходимы для некоторых констант).

Следующие листинги будут частью одного файла --- main.rs, содержащего в
себе всю программу. Первыми представлены импорты программы --- то есть
определение модулей и функций, которые будут добавлены в поле видимости
файла.

use std::{ffi::c\_void, io, mem};

use windows\_sys::Win32::{

Foundation::{FALSE, GetLastError, INVALID\_HANDLE\_VALUE},

System::{

Console::{GetStdHandle, STD\_OUTPUT\_HANDLE, WriteConsoleA},

Memory::{

GetProcessHeap, HeapAlloc, HeapCreate, HeapDestroy,

HeapFree, HeapLock, HeapUnlock, HeapWalk,

PROCESS\_HEAP\_ENTRY,

},

SystemServices::{

PROCESS\_HEAP\_ENTRY\_BUSY, PROCESS\_HEAP\_ENTRY\_DDESHARE,

PROCESS\_HEAP\_ENTRY\_MOVEABLE, PROCESS\_HEAP\_REGION,

PROCESS\_HEAP\_UNCOMMITTED\_RANGE,

},

},

};

Входная точка программы выглядит следующим образом: сначала с помощью
dialoguer у пользователя спрашивается требуемое действие, а далее в
зависимости от его выбора происходит либо обход кучи, либо копирование
строки из динамической памяти по умолчанию в новый динамический пул и её
вывод в консоль.

fn main() {

let action = dialoguer::Select::new()

\.with\_prompt(\"Select action\")

\.item(\"Enumerate heap\")

\.item(\"Copy s1 to dynamic heap and print\")

\.item(\"Copy s2 to dynamic heap and print\")

\.interact()

\.unwrap();

match action {

0 =\> unsafe {

let default\_heap = GetProcessHeap();

enumerate\_heap(default\_heap).unwrap();

},

1 | 2 =\> {

let s = if action == 1 {

String::from(\"Hello, this is example string!\")

} else {

String::from(\"Lorem ipsum dolor sit amet\")

};

copy\_some\_string\_around(s).unwrap();

}

\_ =\> unreachable!(),

}

}

Реализация функции обхода кучи выглядит следующим образом:

unsafe fn enumerate\_heap(hhandle: \*mut c\_void) -\> Result\<(),
io::Error\> {

println!(\"Enumerating Heap:\");

unsafe {

if HeapLock(hhandle) == FALSE {

return Err(io::Error::from\_raw\_os\_error(GetLastError() as i32));

};

let mut entry: PROCESS\_HEAP\_ENTRY = mem::zeroed();

while HeapWalk(hhandle, &mut entry) != FALSE {

let f = entry.wFlags as u32;

if f & PROCESS\_HEAP\_ENTRY\_BUSY != 0 {

println!(\" Allocated Block\");

if f & PROCESS\_HEAP\_ENTRY\_MOVEABLE != 0 {

println!(\" Movable with handle: {:p}\", entry.Anonymous.Block.hMem);

}

if f & PROCESS\_HEAP\_ENTRY\_DDESHARE != 0 {

println!(\" DDESHARE\")

}

} else if f & PROCESS\_HEAP\_REGION != 0 {

let r = entry.Anonymous.Region;

println!(\" Memory region\");

println!(\" Bytes commited: {}\", r.dwCommittedSize);

println!(\" Bytes uncommited: {}\", r.dwUnCommittedSize);

println!(\" First block address: {:p}\", r.lpFirstBlock);

println!(\" Last block address: {:p}\", r.lpLastBlock);

} else if f & PROCESS\_HEAP\_UNCOMMITTED\_RANGE != 0 {

println!(\" Uncommited range\");

} else {

println!(\" Block\");

}

println!(\" Data portion begins at: {:p}\", entry.lpData);

println!(\" Size: {}\", entry.cbData);

println!(\" Overhead: {}\", entry.cbOverhead);

println!(\" Region index: {}\", entry.iRegionIndex);

}

if HeapUnlock(hhandle) == FALSE {

return Err(io::Error::from\_raw\_os\_error(GetLastError() as i32));

};

}

Ok(())

}

Эта функция помечена ключевым словом unsafe, поскольку она накладывает
на вызывающего необходимость в проверке валидности аргумента hhandle.
Внутри можно заметить блокировку кучи и её обход с помощью функции
HeapWalk.

Далее последует реализация функции копирования и вывода строки:

fn copy\_some\_string\_around(s: String) -\> Result\<(), io::Error\> {

let size = s.len();

unsafe {

let heap = HeapCreate(0, 0, 0);

if heap.is\_null() {

return Err(io::Error::from\_raw\_os\_error(GetLastError() as i32));

}

let ptr = HeapAlloc(heap, 0, size) as \*mut u8;

if ptr.is\_null() {

return Err(io::Error::from\_raw\_os\_error(GetLastError() as i32));

}

std::ptr::copy(s.as\_ptr(), ptr, size);

let hout = GetStdHandle(STD\_OUTPUT\_HANDLE);

if hout == INVALID\_HANDLE\_VALUE {

return Err(io::Error::from\_raw\_os\_error(GetLastError() as i32));

}

let ret = WriteConsoleA(hout, ptr, size as u32, 0 as \*mut u32, 0 as
\*const c\_void);

if ret == FALSE {

return Err(io::Error::from\_raw\_os\_error(GetLastError() as i32));

}

HeapFree(heap, 0, ptr as \*const c\_void);

HeapDestroy(heap);

}

Ok(())

}

Обратите внимание на обработку ошибок. Rust предоставляет стандартный
тип Result, который может содержать в себе либо значение при успехе,
либо ошибку.

#strong[Демонстрация работы приложения]

Программу можно запустить, введя в консоль cargo run. Диспетчер пакетов
cargo проверит зависимости, соберёт и запустит программу.

#box(image("./assets/10000000000001CE00000086256A7D0A.png", height: 1.3957in, width: 4.8134in))

#box(image("./assets/100000000000020D000002C8741E42F4.png", height: 7.4173in, width: 5.4693in))

#strong[]

#strong[#box(image("./assets/10000000000002320000009C68FCC7E2.png", height: 1.6252in, width: 5.8547in))]

#strong[Вывод]

В ходе работы была изучена работа с примитивами синхронизации Windows
API и разработано приложение, использующее пул потоков.
