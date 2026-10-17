#import "../common.typ": *

#show: report.with(
  number: "1",
  title: "Изучение многозадачности в рамках операционной системы Windows",
)

== Цель работы

Изучить методы создания и запуска процессов и потоков в рамках операционной системы Windows.

== Задание

Разработать и запустить приложение, реализующее некоторый алгоритм в соответствии с заданием
преподавателя. Затем осуществить запуск разработанного приложения из другого приложения в виде
отдельного процесса. Запускающее приложение должно отображать сообщения о начале и конце работы
порожденного процесса, например, с помощью вывода сообщений на экран. Исследовать возможность
предотвращения повторного запуска одного и того же дочернего процесса.

== Введение

В данной лабораторной работе будет представлен очень простой пример использования NBS -- новой
системы сборки для C/C++, рецепты сборки для которой пишутся на C++. В приведённом примере будет
выполнена компиляция простой C программы из нескольких файлов с помощью вызова процесса компилятора.

== Ход работы

Первым делом необходимо составить тестовую программу, компиляция которой будет выполняться. Пусть у
проекта будет следующая структура:

```
app
├───include
│       greet.h
│
└───src
        greet.c
        main.c
```

#code-file(read("./include/greet.h"), name: "greet.h")

#code-file(read("./src/greet.c"), name: "greet.c")

#code-file(read("./src/main.c"), name: "main.c")

Теперь необходимо написать скрипт сборки, который преобразует файлы исходного кода на языке C в
исполняемый файл. Хотя NBS реализует механизмы инкрементальной сборки, в данной работе скрипт
ограничен простым последовательным вызовом команд компиляции. Итоговый результат приведён в
следующем листинге:

#code-file(read("./nbs.cpp"), name: "nbs.cpp")

Теперь можно скомпилировать рецепт сборки и вызвать его, тем самым скомпилировав саму программу. Эти
манипуляции продемонстрированы на рисунке~@fig-build-first-run.

#figure(
  image("./assets/build-first-run.png", width: 100%),
  caption: [Компиляция рецепта сборки и сборка программы],
) <fig-build-first-run>

Для дальнейшего использования рецепта сборки нет необходимости его перекомпилировать. В случае
изменения рецепта NBS обновит бинарный файл сборщика перед его исполнением, как продемонстрировано
на рисунке~@fig-build-self-update.

#figure(
  image("./assets/build-self-update.png", width: 100%),
  caption: [Автоматическое обновление сборщика после изменения рецепта],
) <fig-build-self-update>

Как видно на рисунке, перед сборкой проекта по рецепту сборщик выполнил две дополнительные команды
-- компиляцию новой версии рецепта и его запуск. (Примечание: во время выполнения всего рецепта
сборки одновременно будут выполняться процессы старой и новой версии nbs.exe -- старая версия
запустит новую и будет ждать её завершения).

Показывать в отчёте все 1000 строк реализации NBS будет излишне подробно, поэтому будут показаны
реализации лишь двух функций из nbs.hpp: `Cmd::run_async` и `Process::await`.

```cpp
Process Cmd::run_async() const
{
    if (items.empty()) throw PROCESS_EMPTY_CMD_ERROR;

    std::string args_str = to_string();
    log::info("CMD: " + args_str);

#ifdef _WIN32
    char *args = (char *)args_str.c_str(); // TODO: Proper Cmd.to_string

    STARTUPINFO startupinfo;
    ZeroMemory(&startupinfo, sizeof(startupinfo));
    startupinfo.cb = sizeof(startupinfo);

    startupinfo.hStdInput = GetStdHandle(STD_INPUT_HANDLE);
    if (startupinfo.hStdInput == INVALID_HANDLE_VALUE) throw PROCESS_GET_HANDLE_ERROR;

    startupinfo.hStdOutput = GetStdHandle(STD_OUTPUT_HANDLE);
    if (startupinfo.hStdOutput == INVALID_HANDLE_VALUE) throw PROCESS_GET_HANDLE_ERROR;

    startupinfo.hStdError = GetStdHandle(STD_ERROR_HANDLE);
    if (startupinfo.hStdError == INVALID_HANDLE_VALUE) throw PROCESS_GET_HANDLE_ERROR;

    startupinfo.dwFlags |= STARTF_USESTDHANDLES;

    PROCESS_INFORMATION process_info;
    ZeroMemory(&process_info, sizeof(process_info));

    BOOL success = CreateProcessA(NULL, args, NULL, NULL, TRUE, 0, NULL, NULL, &startupinfo,
                                  &process_info);
    if (!success) throw PROCESS_CREATE_ERROR;

    CloseHandle(process_info.hThread);
    return process_info.hProcess;
#else
    int p = fork();
    if (p < 0) throw PROCESS_CREATE_ERROR;
    else if (p == 0)
    {
        auto args = to_c_argv();
        execvp(args[0], args.get());
        throw PROCESS_EXEC_ERROR;
    }
#endif
}
```

```cpp
void Process::await() const
{
#ifdef _WIN32
    DWORD result = WaitForSingleObject(handle, INFINITE);
    if (result == WAIT_FAILED)
    {
        log::error(os::windows_last_error_str());
        throw PROCESS_WAIT_ERROR;
    }

    DWORD exit_status;
    if (!GetExitCodeProcess(handle, &exit_status)) throw PROCESS_GET_EXIT_CODE_ERROR;

    if (exit_status != 0) throw PROCESS_EXIT_STATUS_ERROR;

    CloseHandle(handle);
#else
    while (true)
    {
        int status = 0;
        if (waitpid(pid, &status, 0) < 0)
        {
            // TODO: Error
            throw PROCESS_WAIT_ERROR;
        }

        if (WIFEXITED(status))
        {
            int exit_status = WEXITSTATUS(status);
            if (exit_status == 0) return err::Ok();
            else throw PROCESS_EXIT_STATUS_ERROR;
        }

        if (WIFSIGNALED(status)) throw PROCESS_WAIT_ERROR;
    }
#endif
}
```

Реализация данных функций демонстрирует работу с процессами не только в Windows API, но и в POSIX.

== Выводы

NBS демонстрирует весьма новаторский способ сборки C++ проектов, не требующий никаких сторонних
инструментов помимо компилятора. Один из важных элементов его реализации -- работа с процессами в
Windows API и POSIX.
