= 3. Проектирование и реализация эмулятора

== 3.1 Организация проекта

Существует множество способов собирать программы, написанные на C и C++, и ни 
один из них не является единственным верным. В то же время, одним из наиболее
распространённых способов является CMake и поддерживается всеми популярными
интегрированными средами разработки и редакторами кода. По этой причине CMake
использован и в настоящей работе. На рисунке @img-cmake-project показана базовая
структура проекта в файле "CMakeLists.txt". 

#figure(
  ```cmake
  cmake_minimum_required(VERSION 3.1...3.31)
  project(mos6502)
  add_executable(mos6502 ./src/main.c)
  target_include_directories(mos6502 PRIVATE ./src)
  target_link_libraries(mos6502 PRIVATE raylib)
  ```,
  kind: image,
  caption: [Структура проекта CMake]
) <img-cmake-project>

Во-первых, можно заметить, что проект включает в себя единственную цель mos6502,
состоящая из единственного файла main.c. Хотя проект использует множество файлов
исходного кода, в описание CMake включается лишь один, поскольку сборка проекта
осуществляется по модели "единственной единицы трансляции" @unity-build-austin
@unity-build-ic. С помощью директивы препроцессора include в файле main.c
подключается исходный код остальных файлов, что показано на рисунке
@img-unity-build.

#figure(
  ```c
  #include "addressing.c"
  #include "cpu.c"
  #include "gui.c"
  #include "instructions.c"
  #include "int.c"
  #include "mem.c"
  #include "rom.c"
  ```,
  kind: image,
  caption: [Подключение файлов исходного кода]
) <img-unity-build>

Для формирования окна графического интерфейса и отрисовки подключается
библиотека "raylib". В файле CMake настроен поиск библиотеки в системных
директориях и её загрузка в случае отсутствия в системе (см. рисунок 
@img-cmake-raylib)

#figure(
  ```cmake
  include(FetchContent)

  find_package(raylib)

  if(!raylib_FOUND)
      set(RAYLIB_VERSION 5.5)
      FetchContent_Declare(
          raylib
          DOWNLOAD_EXTRACT_TIMESTAMP OFF
          URL https://github.com/raysan5/raylib/archive/refs/tags/${RAYLIB_VERSION}.tar.gz
      )
      FetchContent_MakeAvailable(raylib)
  endif()
  ```,
  kind: image,
  caption: [Поиск библиотеки "raylib"]
) <img-cmake-raylib>

== 3.2 Интерпретация операционных кодов

== 3.3 Модель памяти

== 3.4 Графический интерфейс
