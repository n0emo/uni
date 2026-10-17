свФЕДЕРАЛЬНОЕ АГЕНСТВО ЖЕЛЕЗНОДОРОЖНОГО ТРАНСПОРТА

Федеральное государственное бюджетное образовательное учреждение высшего
образования

«ПЕТЕРБУРГСКИЙ ГОСУДАРСТВЕННЫЙ УНИВЕРСИТЕТ ПУТЕЙ СООБЩЕНИЯ Императора
Александра I»

Кафедра «Информационные и вычислительные системы»

Дисциплина «Операционные системы»

#strong[ОТЧЁТ]

#strong[ПО ЛАБОРАТОРНОЙ РАБОТЕ №4]

#strong[«Исследование управления виртуальной памятью»]

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

Оценочный лист результатов ЛР №4

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

- Выделяет и назначает область виртуальной памяти.
- Изменяет тип доступа к назначенной области.
- Осуществляет обращение к назначенной области (чтение, запись в
  назначенную область введенной с клавиатуры строки).
- В случае несоответствия типа доступа и операции обращения обрабатывает
  возникшее исключение.

#strong[Введение]

Для выполнения данной лабораторной работы был выбран системный язык
программирования Rust. Windows предоставляет для этого языка официальные
привязки к Windows API в лице крейта windows-sys.

#strong[Ход Работы]

Разработанная программа буде выполнять JIT-компиляцию кода на
эзотерическом языке программирования и её запуск из динамически
выделенной области памяти с правами на чтение, запись и выполнение.

Для организации проекта был выбран Cargo. Он позволяет автоматически
загрузить и скомпилировать необходимые зависимости вместе с программой.
Таблица зависимостей из файла Cargo.toml представлена далее:

\[dependencies\]

iced-x86 = { version = \"1.21.0\", features = \[\"code\_asm\"\] }

windows-sys = { version = \"0.59.0\", features = \[

\"Win32\_System\_LibraryLoader\",

\"Win32\_System\_Memory\"

\] }

iced-x86 позволяет ассемблировать операционные коды x86 прямо в коде. В
свою очередь windows-sys является официальным крейтом от Microsoft для
работы с Windows. Поскольку у данной программы нет необходимости во всём
многообразии возможных функций Windows API, с помощью Cargo features
выбраны только средства работы с памятью и динамическими библиотеками.

В следующих листинах представлена разработанная программа. Она:

- Читает код из файла, преобразует его в код на промежуточном языке;
- Компилирует промежуточное представление в код ассемблера архитектуры
  x86;
- Собирает код ассемблера в набор инструкций процессора;
- Выделяет область памяти с помощью VirtualAlloc и копирует туда
  полученный список инструкций;
- Добавляет права на выполнение выделенной области памяти с помощью
  VirtualProtect;
- Выполняет полученную программу;
- Освобождает область памяти с помощью VirtualFree.

#strong[src/utils.rs]

use utils::VirtualBox;

mod compile;

mod parse;

mod utils;

fn main() {

let args: Vec\<String\> = std::env::args().collect();

let Some(path) = args.get(1) else {

eprintln!(

\"Usage: {} \<path\>\",

args.get(0).map(String::as\_str).unwrap\_or\_else(|| \"bfjit\")

);

std::process::exit(1);

};

let bf = match std::fs::read(path) {

Ok(bf) =\> bf,

Err(e) =\> {

eprintln!(\"Error reading file: {e}\");

std::process::exit(1);

}

};

let il = match parse::parse\_bf(&bf) {

Ok(il) =\> il,

Err(e) =\> {

eprintln!(\"Error parsing file: {e}\");

std::process::exit(1);

}

};

let asm = match compile::assemble\_x64(&il) {

Ok(asm) =\> asm,

Err(e) =\> {

eprintln!(\"Error assembling file: {e}\");

std::process::exit(1);

}

};

let program = unsafe {

let mut program = VirtualBox::new\_with\_size(asm.len());

program.copy\_from(asm.as\_ptr());

if let Err(e) = program.make\_executable() {

eprintln!(\"Error granting executable permissions for program: {e}\");

std::process::exit(1);

}

program

};

unsafe {

let program: extern \"C\" fn() -\> i32 =
std::mem::transmute(program.as\_mut\_ptr());

let ret = program();

std::process::exit(ret);

}

}

#strong[src/utils.rs]

use std::ffi::c\_void;

use windows\_sys::{

Win32::{

Foundation::FALSE,

System::{

LibraryLoader::{GetModuleHandleA, GetProcAddress},

Memory::{

MEM\_COMMIT, MEM\_RELEASE, MEM\_RESERVE, PAGE\_EXECUTE\_READWRITE,
PAGE\_READWRITE,

VirtualAlloc, VirtualFree, VirtualProtect,

},

},

},

s,

};

pub struct VirtualBox\<T\> {

ptr: \*mut T,

size: usize,

}

impl\<T\> VirtualBox\<T\> {

pub unsafe fn new\_with\_size(size: usize) -\> Self {

let ptr = unsafe {

VirtualAlloc(

0 as \*const c\_void,

size,

MEM\_COMMIT | MEM\_RESERVE,

PAGE\_READWRITE,

)

};

if ptr.is\_null() {

panic!(

\"Error allocating memory: {}\",

std::io::Error::last\_os\_error()

);

}

unsafe { Self::from\_raw\_parts(ptr as \*mut T, size) }

}

pub unsafe fn from\_raw\_parts(ptr: \*mut T, size: usize) -\> Self {

Self { ptr, size }

}

pub unsafe fn make\_executable(&mut self) -\> Result\<(),
std::io::Error\> {

let ret = unsafe {

let mut old\_protect: u32 = std::mem::zeroed();

VirtualProtect(

self.ptr as \*mut c\_void,

self.size,

PAGE\_EXECUTE\_READWRITE,

&mut old\_protect,

)

};

if ret == FALSE {

return Err(std::io::Error::last\_os\_error());

}

Ok(())

}

pub unsafe fn copy\_from(&mut self, ptr: \*const T) {

unsafe {

std::ptr::copy(ptr, self.ptr, self.size);

}

}

pub fn as\_mut\_ptr(self) -\> \*mut T {

self.ptr

}

}

impl\<T\> Drop for VirtualBox\<T\> {

fn drop(&mut self) {

unsafe {

VirtualFree(self.ptr as \*mut c\_void, self.size, MEM\_RELEASE);

}

}

}

pub unsafe fn get\_windows\_fn(name: \*const u8) -\> \*const c\_void {

unsafe {

std::mem::transmute(

GetProcAddress(GetModuleHandleA(s!(\"kernel32.dll\")), name)

\.expect(\"Could not get Windows function\"),

)

}

}

Файлы src/parse.rs и src/compile.rs были опущены, поскольку их
содержание никак не относится к теме лабораторной работы.

#strong[Демонстрация работы приложения]

Скомпилировать программу можно запустить, введя в консоль cargo build.
Диспетчер пакетов cargo проверит зависимости и соберёт программу. При
запуске полученного приложения в аргументах командной строки необходимо
передать путь к файлу с программой. Разработанное приложение прочитает
из него программу на эзотерическом языке, скомпилирует и запустит. В
следующих рисунках следует демонстрация работы нескольких тестовых
программ.

#strong[#box(image("./assets/10000000000002CF0000006A8053D275.png", height: 0.9756in, width: 6.6209in))]

#strong[#box(image("./assets/1000000000000355000002369EC03C25.png", height: 4.3098in, width: 6.4957in))]

#strong[Вывод]

В ходе работы были изучены средства управления виртуальной памятью в
Windows API и разработан JIT-компилятор эхотерического языка
программирования.
