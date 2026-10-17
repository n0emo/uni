ФЕДЕРАЛЬНОЕ АГЕНСТВО ЖЕЛЕЗНОДОРОЖНОГО ТРАНСПОРТА

Федеральное государственное бюджетное образовательное учреждение высшего
образования

«ПЕТЕРБУРГСКИЙ ГОСУДАРСТВЕННЫЙ УНИВЕРСИТЕТ ПУТЕЙ СООБЩЕНИЯ Императора
Александра I»

Кафедра «Информационные и вычислительные системы»

Дисциплина «Операционные системы»

#strong[ОТЧЁТ]

#strong[ПО ЛАБОРАТОРНОЙ РАБОТЕ №1]

#strong[«Изучение многозадачности в рамках операционной системы
Windows»]

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

Оценочный лист результатов ЛР №1

Ф.И.О. студента: #emph[Шефнер А.]

Группа \_\_\_\_\_\_\_\_\_\_\_\_\_#emph[ИВБ-211]\_\_\_\_\_\_\_\_\_\_\_\_

Старший преподаватель кафедры

«Информационные и вычислительные

системы»#strong[ «\_\_» \_\_\_\_\_\_\_\_\_\_2025 г. Молодкин И.А.]

#strong[Цель]

Изучить методы создания и запуска процессов и потоков в рамках
операционной системы Windows.

#strong[Задание]

Разработать и запустить приложение, реализующее некоторый алгоритм в
соответствии с заданием преподавателя. Затем осуществить запуск
разработанного приложения из другого приложения в виде отдельного
процесса. Запускающее приложение должно отображать сообщения о начале и
конце работы порожденного процесса, например, с помощью вывода сообщений
на экран. Исследовать возможность предотвращения повторного запуска
одного и того же дочернего процесса.

#strong[Введение]

В данной лабораторной работе будет представлен очень простой пример
использования NBS -- новой системы сборки для C/C++, рецепты сборки для
которой пишутся на C++. В приведённом примере будет выполнена компиляция
простой C программы из нескольких файлов с помощью вызова процесса
компилятора.

#strong[Ход Работы]

Первым делом необходимо составить тестовую программу, компиляция которой
будет выполняться. Пусть у проекта будет следующая структура:

#quote(block: true)[
app

│ \ ├───include \ │ greet.h \ │ \ └───src \ greet.c \ main.c
]

#strong[include/greet.h]

void greet(const char \*name);

#strong[src/greet.c]

\#include \<stdio.h\>

void greet(const char \*name) {

printf(\"Hello, %s!\\n\", name);

}

#strong[src/main.c]

\#include \"greet.h\"

int main() {

greet(\"World\");

return 0;

}

Теперь необходимо написать скрипт сборки, который преобразует файлы
исходного кода на языке C в исполняемый файл. Хотя у NBS реализует
механизмы инкрементальной сборки, в данной работе скрипт ограничен
простым последовательным вызовом команд компиляции. Итоговый результат
приведён в следующем листинге:

#strong[#strong[nbs.cpp]]

\#define NBS\_IMPLEMENTATION

\#include \"nbs.hpp\"

\#ifdef \_MSC\_VER

\#define OBJECT \"obj\"

\#else

\#define OBJECT \"o\"

\#endif

int main(int argc, char \*\*argv) {

nbs::self\_update(argc, argv, \_\_FILE\_\_);

nbs::os::make\_directory\_if\_not\_exists(\"build\");

nbs::c::CompileOptions options;

options.include\_paths = {nbs::os::path(\"include\")};

\#ifdef \_MSC\_VER

options.flags = {\"-nologo\", \"-W4\"};

options.compiler = nbs::c::MSVC;

\#else

options.flags = {\"-Wall\", \"-Wextra\", \"-pedantic\", \"-g\"};

options.compiler = nbs::c::CLANG;

\#endif

options.obj\_cmd(\"build/main.\" OBJECT, \"src/main.c\").run();

options.obj\_cmd(\"build/greet.\" OBJECT, \"src/greet.c\").run();

options.exe\_cmd(\"build/app\", {\"build/main.\" OBJECT,
\"build/greet.\" OBJECT}).run();

}

Теперь можно скомпилировать рецепт сборки и вызвать его, тем самым
скомпилировав саму программу. Эти манипуляции продемонстрированы на
следующем рисунке.

#box(image("./assets/10000001000003C4000001A0A66BD355.png", height: 2.8571in, width: 6.6209in))

Для дальнейшего использования рецепта сборки нет необходимости его
перекомпилировать. В случае изменения рецепта NBS обновит бинарный файл
сборщика перед его исполнением, как продемонстрировано на рисунке далее.

#box(image("./assets/10000001000003CE000001815D15B16E.png", height: 2.6165in, width: 6.6209in))

Как видно на рисунке, перед сборкой проекта по рецепту сборщик выполнил
две дополнительные команды --- компиляцию новой версии рецепта и его
запуск. (Примечание: во время выполнения всего рецепта сборки
одновременно будут выполняться процессы старой и новой версии nbs.exe --
старая версия запустит новую и будет ждать её завершения).

Показывать в отчёте все 1000 строк реализации NBS будет излишне
подробно, поэтому будут показаны реализации лишь двух функций из
nbs.hpp: Cmd::run\_async и Process::await.

Process Cmd::run\_async() const

{

if (items.empty()) throw PROCESS\_EMPTY\_CMD\_ERROR;

std::string args\_str = to\_string();

log::info(\"CMD: \" + args\_str);

\#ifdef \_WIN32

char \*args = (char \*)args\_str.c\_str(); /\/ TODO: Proper
Cmd.to\_string

STARTUPINFO startupinfo;

ZeroMemory(&startupinfo, sizeof(startupinfo));

startupinfo.cb = sizeof(startupinfo);

startupinfo.hStdInput = GetStdHandle(STD\_INPUT\_HANDLE);

if (startupinfo.hStdInput == INVALID\_HANDLE\_VALUE) throw
PROCESS\_GET\_HANDLE\_ERROR;

startupinfo.hStdOutput = GetStdHandle(STD\_OUTPUT\_HANDLE);

if (startupinfo.hStdOutput == INVALID\_HANDLE\_VALUE) throw
PROCESS\_GET\_HANDLE\_ERROR;

startupinfo.hStdError = GetStdHandle(STD\_ERROR\_HANDLE);

if (startupinfo.hStdError == INVALID\_HANDLE\_VALUE) throw
PROCESS\_GET\_HANDLE\_ERROR;

startupinfo.dwFlags |= STARTF\_USESTDHANDLES;

PROCESS\_INFORMATION process\_info;

ZeroMemory(&process\_info, sizeof(process\_info));

BOOL success = CreateProcessA(NULL, args, NULL, NULL, TRUE, 0, NULL,
NULL, &startupinfo, &process\_info);

if (!success) throw PROCESS\_CREATE\_ERROR;

CloseHandle(process\_info.hThread);

return process\_info.hProcess;

\#else

int p = fork();

if (p \< 0) throw PROCESS\_CREATE\_ERROR;

else if (p == 0)

{

auto args = to\_c\_argv();

execvp(args\[0\], args.get());

throw PROCESS\_EXEC\_ERROR;

}

\#endif

}

void Process::await() const

{

\#ifdef \_WIN32

DWORD result = WaitForSingleObject(handle, INFINITE);

if (result == WAIT\_FAILED)

{

log::error(os::windows\_last\_error\_str());

throw PROCESS\_WAIT\_ERROR;

}

DWORD exit\_status;

if (!GetExitCodeProcess(handle, &exit\_status)) throw
PROCESS\_GET\_EXIT\_CODE\_ERROR;

if (exit\_status != 0) throw PROCESS\_EXIT\_STATUS\_ERROR;

CloseHandle(handle);

\#else

while (true)

{

int status = 0;

if (waitpid(pid, &status, 0) \< 0)

{

\/\/ TODO: Error

throw PROCESS\_WAIT\_ERROR;

}

if (WIFEXITED(status))

{

int exit\_status = WEXITSTATUS(status);

if (exit\_status == 0) return err::Ok();

else throw PROCESS\_EXIT\_STATUS\_ERROR;

}

if (WIFSIGNALED(status)) throw PROCESS\_WAIT\_ERROR;

}

\#endif

}

Реализация данных функций демонстрирует работу с процессами не только в
Windows API, но и в POSIX.

#strong[Вывод]

NBS демонстрирует весьма новаторский способ сборки С++ проектов, не
требующий никаких сторонних инструментов помимо компилятора. Один из
важных элементов его реализации --- работа с процессами в Windows API и
POSIX.
