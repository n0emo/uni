#import "../common.typ": *

#show: report.with(number: "5", title: "Изучение файловой системы")

== Цель работы

Изучить средства работы с файловой системой с помощью Windows API.

== Задание

Разработать приложение, которое выполняет следующие действия:

- Получает полную информацию о выбранном файле. Файл выбирается из каталога с помощью стандартных
  диалоговых панелей;
- Изменяет атрибуты выбранного файла.

== Введение

В данной работе будут продемонстрированы инструменты работы с файловой системой в NBS.

== Ход работы

Для демонстрации работы потребуется код, который необходимо собрать с помощью NBS. Для этого создана
простейшая программа из 5 файлов. Далее они все будут перечислены.

#code-file(read("./src/main.cpp"), name: "main.cpp")

#code-file(read("./src/a.hpp"), name: "a.hpp")

#code-file(read("./src/a.cpp"), name: "a.cpp")

#code-file(read("./src/b.hpp"), name: "b.hpp")

#code-file(read("./src/b.cpp"), name: "b.cpp")

Сборка будет осуществляться инкрементально, то есть каждый файл будет пересобираться, только если
это необходимо. Для этого в NBS есть система таргетов, которая определяет необходимость сборки файла
по его атрибутам (или отсутствию).

В следующем листинге представлен скрипт сборки.

#code-file(read("./nbs.cpp"), name: "nbs.cpp")

Для работы этого скрипта в nbs.hpp реализованы следующие функции работы с файловой системой:

```cpp
NBSAPI long compare_last_mod_time(const path &path1, const path &path2)
{
    long time1 = os::last_write_time(path1);
    long time2 = os::last_write_time(path2);
    return time1 - time2;
}

NBSAPI bool make_directory_if_not_exists(const path &path)
{
    CreateDirectory(path.buf.c_str(), NULL);
    return true;
}

NBSAPI bool exists(const path &path)
{
    return GetFileAttributesA(path.buf.c_str()) != INVALID_FILE_ATTRIBUTES;
}

NBSAPI void rename(const os::path &from, const path &to) {
    MoveFileEx(from.buf.c_str(), to.buf.c_str(), MOVEFILE_REPLACE_EXISTING);
}

NBSAPI long last_write_time(const os::path &path) {
    const int64_t WINDOWS_TICK = 10000000;
    const int64_t SEC_TO_UNIX_EPOCH = 11644473600LL;
    HANDLE hfile = CreateFile(
        path.buf.c_str(),
        GENERIC_READ,
        FILE_SHARE_READ|FILE_SHARE_WRITE,
        NULL,
        OPEN_EXISTING,
        FILE_ATTRIBUTE_NORMAL,
        NULL
    );
    FILETIME last_write;
    // TODO: Error handling
    GetFileTime(hfile, NULL, NULL, &last_write);
    int64_t val = *(int64_t *) &last_write;
    val = val / WINDOWS_TICK - SEC_TO_UNIX_EPOCH;
    CloseHandle(hfile);
    return val;
}
```

=== Демонстрация работы приложения

Первым делом будет сформирован исполняемый файл nbs.exe. Это нужно выполнить лишь один раз, далее
файл будет пересобирать сам себя самостоятельно. На приведённом рисунке~@fig-first-run за начальную
сборку nbs.exe отвечает первая команда (вызов cl). Далее только что скомпилированный скрипт
вызывается и собирает сам проект. Последняя команда демонстрирует его работоспособность.

#figure(
  image("./assets/build-first-run.png", width: 100%),
  caption: [Первая сборка проекта и запуск приложения],
) <fig-first-run>

На рисунке~@fig-touch-nbs будет изменено время последней модификации файла nbs.cpp и снова вызван
исполняемый файл nbs.exe. Видно, что файл nbs.exe действительно пересобирается. При этом сам проект
собираться не будет, поскольку у его исполняемого файла и так самая новая версия.

#figure(
  image("./assets/touch-nbs-cpp.png", width: 100%),
  caption: [Пересборка nbs.exe после изменения времени модификации nbs.cpp],
) <fig-touch-nbs>

Если же попробовать изменить время модификации b.hpp, будут пересобраны те файлы, которые от него
зависели, и сам исполняемый файл (см. рисунок~@fig-touch-b).

#figure(
  image("./assets/touch-b-hpp.png", width: 100%),
  caption: [Пересборка проекта после изменения времени модификации b.hpp],
) <fig-touch-b>

== Выводы

В ходе работы были изучены средства управления файловой системой в Windows API.
