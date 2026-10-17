ФЕДЕРАЛЬНОЕ АГЕНСТВО ЖЕЛЕЗНОДОРОЖНОГО ТРАНСПОРТА

Федеральное государственное бюджетное образовательное учреждение высшего
образования

«ПЕТЕРБУРГСКИЙ ГОСУДАРСТВЕННЫЙ УНИВЕРСИТЕТ ПУТЕЙ СООБЩЕНИЯ Императора
Александра I»

Кафедра «Информационные и вычислительные системы»

Дисциплина «Операционные системы»

#strong[ОТЧЁТ]

#strong[ПО ЛАБОРАТОРНОЙ РАБОТЕ №6]

#strong[«Исследование асинхронных операций с файлами»]

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

Оценочный лист результатов ЛР №6

Ф.И.О. студента: #emph[Шефнер А.]

Группа \_\_\_\_\_\_\_\_\_\_\_\_\_#emph[ИВБ-211]\_\_\_\_\_\_\_\_\_\_\_\_

Старший преподаватель кафедры

«Информационные и вычислительные

системы»#strong[ «\_\_» \_\_\_\_\_\_\_\_\_\_2025 г. Молодкин И.А.]

#strong[Цель]

#strong[ ]Изучить средства асинхронной работы с файловой системой с
помощью Windows API

#strong[Задание]

Разработать приложение, которое выполняет следующие действия:

- Создает на сменном магнитном диске некоторый текстовый файл;
- Заполняет его некоторыми (случайными) символами (не менее 1000 Кб) в
  обычном \(синхронном) режиме;
- После закрытия файла запускает какую -- либо вычислительную процедуру
  (например, из лабораторной работы №1) с большим количеством циклов и
  отображением хода ее выполнения;
- После его завершения выводит на терминал время, потребовавшееся для
  выполнения вышеперечисленных действий;
- Уничтожает ранее созданный файл;
- Вновь создает его, но для заполнения в асинхронном режиме;
- Заполняет его некоторыми (случайными) символами (не менее 1000 Кб) в
  асинхронном режиме;
- Не дожидаясь завершения обмена, запускает вышеуказанную вычислительную
  процедуру;
- После окончания операции обмена выводит на терминал соответствующее
  сообщение и время, затраченное на эту операцию;
- После окончания вычислительной процедуры выводит на терминал
  соответствующее сообщение и время, затраченное на ее выполнения;
- После завершения всех действий выводит на терминал время, затраченное
  на их выполнение.

#strong[Введение]

Для выполнения данной лабораторной работы был выбран системный язык
программирования Rust. Windows предоставляет для этого языка официальные
привязки к Windows API в лице крейта windows-sys.

#strong[Ход Работы]

В приведённом далее листинге представлено использование как синхроных,
так и асинхронных функций работы с файлами.

#strong[#strong[src/main].#strong[rs]]

use std::{

io, mem,

ops::{Deref, DerefMut},

ptr,

};

use windows\_sys::{

s, Win32::{

Foundation::{self, FALSE, TRUE},

Storage::FileSystem,

System::{Threading, IO},

}

};

\/\/ Массив, содержащий в себе 4196 символов \'a\'

const BUF: \[u8; 4196\] = \[b\'a\'; 4196\];

\/\/ Будет записан в файл 500000 раз

const BUF\_WRITE\_TIMES: usize = 500000;

\/\/ Вспомогательная структура, реализующая освобождение

\/\/ ресурсов Windows с помощью идиомы RAII

pub struct HandleGuard(Foundation::HANDLE);

\/\/ Для освобождения в Rust используется типаж Drop.

\/\/ В его реализации и будет вызван CloseHandle.

\/\/ Таким образом, метод CloseHandle будет вызван для всех

\/\/ переменных типа HandleGuard независимо от причины её выхода

\/\/ из области видимости

impl Drop for HandleGuard {

fn drop(&mut self) {

unsafe {

Foundation::CloseHandle(self.0);

}

}

}

impl Deref for HandleGuard {

type Target = Foundation::HANDLE;

fn deref(&self) -\> &Self::Target {

&self.0

}

}

impl DerefMut for HandleGuard {

fn deref\_mut(&mut self) -\> &mut Self::Target {

&mut self.0

}

}

\/\/ Входная точка приложения

fn main() {

\/\/ Предложение пользователю выбрать синхронную или

\/\/ асинхронную операцию с файлом.

let input = dialoguer::Select::new()

\.with\_prompt(\"Select action\")

\.item(\"Sync benchmark\")

\.item(\"Async benchmark\")

\.interact()

\.unwrap();

match input {

0 =\> bench\_sync().unwrap(),

1 =\> bench\_async().unwrap(),

\_ =\> unreachable!(),

};

}

\/\/ Синхронный режим работы

fn bench\_sync() -\> io::Result\<()\> {

println!(\"Starting writing garbage to data.txt\");

unsafe {

let file = open\_for\_writing(s!(\"data.txt\"), false)?;

for \_ in 0..BUF\_WRITE\_TIMES {

write(\*file, &BUF)?;

}

}

println!(\"Finished writing garbage to data.txt\");

Ok(())

}

\/\/ Асинхронный режим работы

\/\/

\/\/ Для выполнения операции используется очередь асинхронных операций.

\/\/ В эту очередь добавляется единственная задача, которая запишет

\/\/ буфер в файл лишь 1 раз. Идея заключается в том, что эта задача

\/\/ будет вызывать саму себя N раз.

fn bench\_async() -\> io::Result\<()\> {

unsafe {

let file = open\_for\_writing(s!(\"data.txt\"), true)?;

println!(\"Starting writing garbage to data.txt\");

let event = Threading::CreateEventA(

ptr::null(),

TRUE,

FALSE,

ptr::null(),

);

if event.is\_null() {

return Err(io::Error::last\_os\_error());

}

let mut state = AsyncWriteState {

overlapped: mem::zeroed(),

handle: \*file,

event,

count: BUF\_WRITE\_TIMES,

buf: &BUF,

};

state.overlapped.Anonymous.Anonymous.Offset = 0xFFFFFFFF;

state.overlapped.Anonymous.Anonymous.OffsetHigh = 0xFFFFFFFF;

let ptr = &mut state as \*mut AsyncWriteState as \*mut IO::OVERLAPPED;

write\_async(\*file, &BUF, ptr, Some(async\_write\_routine))?;

loop {

let ret = Threading::WaitForSingleObjectEx(event, Threading::INFINITE,
TRUE);

if ret == 0 {

break;

}

}

println!(\"Finished writing garbage to data.txt\");

}

Ok(())

}

\#\[repr(C)\]

struct AsyncWriteState\<\'a\> {

overlapped: IO::OVERLAPPED,

handle: Foundation::HANDLE,

event: Foundation::HANDLE,

count: usize,

buf: &\'a \[u8\],

}

\#\[allow(unused)\]

unsafe extern \"system\" fn async\_write\_routine(

error\_code: u32,

bytes\_transferred: u32,

overlapped: \*mut IO::OVERLAPPED,

) {

unsafe {

let state: &mut AsyncWriteState = &mut \*(overlapped as \*mut
AsyncWriteState);

if (state.count \> 0) {

state.count -= 1;

let ret = FileSystem::WriteFileEx(

state.handle,

state.buf.as\_ptr(),

state.buf.len() as u32,

overlapped,

Some(async\_write\_routine),

);

if ret == FALSE {

eprintln!(\"Error writing to file: {:?}\",
io::Error::last\_os\_error());

}

} else {

Threading::SetEvent(state.event);

}

}

}

\/\/ Вспомогательная функция для открытия файла

unsafe fn open\_for\_writing(name: \*const u8, overlapped: bool) -\>
io::Result\<HandleGuard\> {

let flags = match overlapped {

true =\> FileSystem::FILE\_FLAG\_OVERLAPPED,

false =\> 0,

};

let file = unsafe {

FileSystem::CreateFileA(

name,

Foundation::GENERIC\_WRITE,

FileSystem::FILE\_SHARE\_WRITE,

ptr::null(),

FileSystem::CREATE\_ALWAYS,

flags,

ptr::null\_mut(),

)

};

if file.is\_null() {

return Err(io::Error::last\_os\_error());

}

Ok(HandleGuard(file))

}

\/\/ Вспомогательная функция для синхронной записи в файл

unsafe fn write(file: Foundation::HANDLE, buf: &\[u8\]) -\>
io::Result\<usize\> {

unsafe {

let mut written: u32 = mem::zeroed();

let ret = FileSystem::WriteFile(

file,

buf.as\_ptr(),

buf.len() as u32,

&mut written,

ptr::null\_mut(),

);

if ret == FALSE {

return Err(io::Error::last\_os\_error());

}

Ok(written as usize)

}

}

\/\/ Вспомогательная функция для асинхронной записи в файл

unsafe fn write\_async(

file: Foundation::HANDLE,

buf: &\[u8\],

overlapped: \*mut IO::OVERLAPPED,

routine: Option\<unsafe extern \"system\" fn(u32, u32, \*mut
IO::OVERLAPPED)\>,

) -\> io::Result\<()\> {

unsafe {

let ret =

FileSystem::WriteFileEx(file, buf.as\_ptr(), buf.len() as u32,
overlapped, routine);

if ret == FALSE {

return Err(io::Error::last\_os\_error());

}

}

Ok(())

}

#strong[Демонстрация работы приложения]

В приведённом ниже рисунке продемонстрировано время работы синхронного и
асинхронного режима записи в файл

#box(image("./assets/10000000000002DA000001175DF525F6.png", height: 2.4819in, width: 6.4957in))

#strong[Вывод]

В ходе работы были изучены асинхронные средства работы с файлами в
Windows API.
