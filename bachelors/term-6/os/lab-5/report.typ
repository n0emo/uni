свФЕДЕРАЛЬНОЕ АГЕНСТВО ЖЕЛЕЗНОДОРОЖНОГО ТРАНСПОРТА

Федеральное государственное бюджетное образовательное учреждение высшего
образования

«ПЕТЕРБУРГСКИЙ ГОСУДАРСТВЕННЫЙ УНИВЕРСИТЕТ ПУТЕЙ СООБЩЕНИЯ Императора
Александра I»

Кафедра «Информационные и вычислительные системы»

Дисциплина «Операционные системы»

#strong[ОТЧЁТ]

#strong[ПО ЛАБОРАТОРНОЙ РАБОТЕ №5]

#strong[«Изучение файловой системы»]

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

Оценочный лист результатов ЛР №5

Ф.И.О. студента: #emph[Шефнер А.]

Группа \_\_\_\_\_\_\_\_\_\_\_\_\_#emph[ИВБ-211]\_\_\_\_\_\_\_\_\_\_\_\_

Старший преподаватель кафедры

«Информационные и вычислительные

системы»#strong[ «\_\_» \_\_\_\_\_\_\_\_\_\_2025 г. Молодкин И.А.]

#strong[Цель]

#strong[ ]Изучить средства работы с файловой системой с помощью Windows
API

#strong[Задание]

Разработать приложение, которое выполняет следующие действия:

- Получает полную информацию о выбранном файле. Файл выбирается из
  каталога с помощью стандартных диалоговых панелей;
- Изменяет атрибуты выбранного файла;

#strong[Введение]

В данной работе будут продемонстрированы инструменты работы с файловой
системой в NBS.

#strong[Ход Работы]

Для демонстрации работы потребуется код, который необходимо собрать с
помощью NBS. Для этого создана простейшая программа из 5 файлов. Далее
они все будут перечислены

#strong[main.cpp]

\#include \"a.hpp\"

\#include \"b.hpp\"

int main() {

make\_a();

make\_b();

return 0;

}

#strong[a.hpp]

\#ifndef SRC\_A\_H\_

\#define SRC\_A\_H\_

void make\_a();

\#endif /\/ SRC\_A\_H\_

#strong[a.cpp]

\#include \"a.hpp\"

\#include \<cstdio\>

void make\_a() { printf(\"This is A (AAA (AAAAAA))\\n\"); }

#strong[#strong[b].#strong[h]pp]

\#ifndef SRC\_B\_H\_

\#define SRC\_B\_H\_

void make\_b();

\#endif /\/ SRC\_B\_H\_

#strong[#strong[b].#strong[c]pp]

\#include \"b.hpp\"

\#include \<cstdio\>

void make\_b() { printf(\"B.\\n\"); }

Сборка будет осуществляться инкрементально, то есть каждый файл будет
пересобираться только если это необходимо. Для этого в NBS есть система
таргетов, которая определяет необходимость сборки файла по его атрибутам
(или отсутствию).

В следующем листинге представлен скрипт сборки

#strong[nbs.cpp]

\#define NBS\_IMPLEMENTATION

\#include \"nbs.hpp\"

\#include \<map\>

using namespace nbs;

using namespace std;

using p = os::path;

int main(int argc, char \*\*argv) {

\/\/ Пересобрать исполняемый файл nbs.exe в случае изменения nbs.cpp

self\_update(argc, argv, \_\_FILE\_\_);

log::info(\"Starting building project\");

os::make\_directory\_if\_not\_exists(\"build\");

log::info(\"Created build directory\");

\/\/ Для сборки будет использован компилятор в составе

\/\/ Visual Studio Build Tools - MSVC

c::CompileOptions options;

options.compiler = c::MSVC;

options.include\_paths = {\"src\"};

options.other\_flags = {\"-nologo\"};

\/\/ Этот словарь отражает, от каких файлов зависит каждый файл

\/\/ исходного кода.

const map\<string, vector\<p\>\> sources({

{\"src\\\\a.cpp\", {p(\"src\\\\a.hpp\")}},

{\"src\\\\b.cpp\", {p(\"src\\\\b.hpp\")}},

{\"src\\\\main.cpp\", {p(\"src\\\\a.hpp\"), p(\"src\\\\b.hpp\")}},

});

target::TargetMap project;

std::vector\<p\> objects;

\/\/ Определить цели сборки объектных файлов

for (const auto &source : sources) {

const p path(source.first);

const string file = path.file\_name();

const p obj(\"build\\\\\" + str::change\_extension(file, \"obj\"));

objects.push\_back(obj);

const os::Cmd cmd = options.obj\_cmd(obj, source.first);

project.insert(target::Target(obj, cmd, source.second));

}

\/\/ Определить цель сборки для итогового исполняемого файла

const p out = p(\"build\\\\app.exe\");

project.insert(target::Target(

out,

options.exe\_cmd(out, objects),

objects

));

\/\/ Запустить сборку

project.build\_if\_needs(out.buf);

return 0;

}

Для работы этого скрипта в nbs.hpp реализованы следующие функции работы
с файловой системой:

NBSAPI long compare\_last\_mod\_time(const path &path1, const path
&path2)

{

long time1 = os::last\_write\_time(path1);

long time2 = os::last\_write\_time(path2);

return time1 - time2;

}

NBSAPI bool make\_directory\_if\_not\_exists(const path &path)

{

CreateDirectory(path.buf.c\_str(), NULL);

return true;

}

NBSAPI bool exists(const path &path)

{

return GetFileAttributesA(path.buf.c\_str()) !=
INVALID\_FILE\_ATTRIBUTES;

}

NBSAPI void rename(const os::path &from, const path &to) {

MoveFileEx(from.buf.c\_str(), to.buf.c\_str(),
MOVEFILE\_REPLACE\_EXISTING);

}

NBSAPI long last\_write\_time(const os::path &path) {

const int64\_t WINDOWS\_TICK = 10000000;

const int64\_t SEC\_TO\_UNIX\_EPOCH = 11644473600LL;

HANDLE hfile = CreateFile(

path.buf.c\_str(),

GENERIC\_READ,

FILE\_SHARE\_READ|FILE\_SHARE\_WRITE,

NULL,

OPEN\_EXISTING,

FILE\_ATTRIBUTE\_NORMAL,

NULL

);

FILETIME last\_write;

\/\/ TODO: Error handling

GetFileTime(hfile, NULL, NULL, &last\_write);

int64\_t val = \*(int64\_t \*) &last\_write;

val = val / WINDOWS\_TICK - SEC\_TO\_UNIX\_EPOCH;

CloseHandle(hfile);

return val;

}

#strong[Демонстрация работы приложения]

Первым делом будет сформирован исполняемый файл nbs.exe. Это нужно
выполнить лишь один раз, далее файл будет пересобирать сам себя
самостоятельно. \ В приведённом рисунке за начальную сборку nbs.exe
отвечает первая команда (вызов cl). Далее только что скомпилированный
скрипт вызывается и собирает сам проект. Последняя команда демонстрирует
его работоспособность.

#box(image("./assets/1000000000000355000002348196CFB3.png", height: 4.3728in, width: 6.6146in))

В следующем листинге будет изменено время последней модификации файла
nbs.cpp и снова вызван исполняемый файл nbs.exe. Видно, что файл nbs.exe
действительно пересобирается. При этом сам проект собираться не будет,
поскольку у его исполняемого файла и так самая новая версия.

#box(image("./assets/10000000000003480000011540819403.png", height: 2.1827in, width: 6.6209in))

Если же попробовать изменить время модификации b.hpp, будут пересобраны
те файлы, которые от него зависели, и сам исполняемый файл.

#strong[#box(image("./assets/1000000000000348000001230830290B.png", height: 2.2929in, width: 6.6209in))]

#strong[Вывод]

В ходе работы были изучены средства управления файловой системой в
Windows API.
