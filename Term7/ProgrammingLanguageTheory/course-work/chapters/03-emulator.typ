= 3. Проектирование и реализация эмулятора

== 3.1 Организация проекта

Существует множество способов собирать программы, написанные на C и C++, и ни
один из них не является единственным верным. В то же время, одним из наиболее
распространённых способов является CMake и поддерживается всеми популярными
интегрированными средами разработки и редакторами кода @cmake. По этой причине
CMake использован и в настоящей работе. На рисунке @img-cmake-project показана
базовая структура проекта в файле "CMakeLists.txt".

#figure(
  ```cmake
  cmake_minimum_required(VERSION 3.1...3.31)
  project(mos6502)
  add_executable(mos6502 ./src/main.c)
  target_include_directories(mos6502 PRIVATE ./src)
  target_link_libraries(mos6502 PRIVATE raylib)
  ```,
  kind: image,
  caption: [структура проекта CMake],
) <img-cmake-project>

Во-первых, можно заметить, что проект включает в себя единственную цель mos6502,
состоящую из единственного файла main.c. Хотя проект использует множество файлов
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
  caption: [подключение файлов исходного кода],
) <img-unity-build>

Для формирования окна графического интерфейса и отрисовки подключается
библиотека raylib @raylib. В файле CMake настроен поиск библиотеки в системных
директориях и её загрузка с использованием директивы FetchContent @fetch-content
в случае отсутствия библиотеки в системе (рисунок @img-cmake-raylib)

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
  caption: [поиск библиотеки "raylib"],
) <img-cmake-raylib>

== 3.2 Определение модели

Согласно архитектуре фон Неймана, компьютер -- это устройство, которое выполняет
действия:
- читает информацию из памяти;
- обрабатывает информацию;
- записывает информацию в память.
Компьютер можно условно разделить на микропроцессор и память
@von-neumann-arch. На практике такой модели достаточно для описания в том числе
современных и сложных компьютеров.

В программном эмуляторе для моделирования памяти используется массив буферов,
содержащий "устройства" памяти (рисунок @img-mem-model).

#figure(
  ```c
  typedef struct {
      uint8_t *data;
      uint16_t begin_address;
      uint16_t end_address;
      bool readonly;
  } Device;

  typedef struct {
      Device *devices;
      size_t dev_count;
      size_t dev_capacity;
  } Memory;
  ```,
  kind: image,
  caption: [определение структур памяти],
) <img-mem-model>

Больший интерес представляет модель микропроцессора. В исходном коде эмулятора
объявлена структура (рисунок @img-cpu-model), содержащая в себе поля,
соответствующие регистрам микропроцессора. Помимо этого структура включает в себя
поле с указателем на структуру памяти и счётчик тактов микропроцессора.

#figure(
  ```c
  typedef struct Cpu {
      uint16_t PC; // program counter
      uint8_t A;   // accumulator
      uint8_t X;   // X register
      uint8_t Y;   // Y register
      uint8_t SP;  // stack pointer

      bool N; // negative
      bool V; // overflow
      bool U; // unused
      bool B; // break (not a real flag)
      bool D; // decimal
      bool I; // interrupt
      bool Z; // zero
      bool C; // carry

      Memory *mem;
      uint64_t cycles;
  } Cpu;
  ```,
  kind: image,
  caption: [определение структуры микропроцессора],
) <img-cpu-model>


== 3.3 Интерпретация операционных кодов

Настроящий микропроцессор MOS6502 работает в цикле "Fetch-Decode-Execute". Каждый
такт часов микропроцессор выполняет следующие действия:
1. Получить инструкцию по адресу PC.
2. Декодировать инструкцию.
3. Выполнить инструкцию.

Реализация этого алгоритма в эмуляторе показана на рисунке @img-cpu-execute.

#figure(
  ```c
  void cpu_execute(Cpu *cpu) {
      uint8_t inst_code = mem_read(cpu->mem, cpu->PC);
      Instruction instruction = get_instruction_by_opcode(inst_code);
      Addressing addressing = get_addressing(instruction.address_mode);
      size_t inst_size = addressing.size;
      uint16_t data = mem_read16(cpu->mem, cpu->PC + 1);
      if (instruction.increment_pc) cpu->PC += inst_size;
      get_instruction_func(instruction.type)(cpu, addressing, data);
  }
  ```,
  kind: image,
  caption: [алгоритм "Fetch-Decode-Execute"],
) <img-cpu-execute>

Полная реализаций функций микропроцессора представлена в приложении @sup-cpu-c.

Для формирования набора доступных команд создан макрос-список команд, показанный
на рисунке @img-insr-list. Этот список используется для объявления перечисления
инструкций и функций обработки адресации. Аналогичным образом определяется
макрос-список режимов адресации.

#figure(
  ```c
  // Use with #define INSTRUCTION_X(uppercase, lowercase)
  #define INSTRUCTION_LIST                  \
      INSTRUCTION_X(ADC, adc)               \
      INSTRUCTION_X(ALR, alr) /* Illegal */ \
      INSTRUCTION_X(ANC, anc) /* Illegal */ \
      INSTRUCTION_X(AND, and)               \
      INSTRUCTION_X(ANE, ane)               \
  ```,
  kind: image,
  caption: [макрос-список инстркций],
) <img-insr-list>

Декодирование инструкции, в свою очередь, происходит с помощью оператора
switch-case. Для каждого возможного операционного кода (00 -- FF) функция
возвращает информацию о команде микропроцессора, режиме адресации и количестве циклов
микропроцессора, которое занимает инструкция. Отрывок функции декодирования показан
на рисунке @img-decode.

#figure(
  ```c
  static inline Instruction get_instruction_by_opcode(uint8_t opcode) {
      switch(opcode) {
      case 0x00: return (Instruction) {IT_BRK,  AM_IMPLIED,     7, true };
      case 0x01: return (Instruction) {IT_ORA,  AM_INDIRECT_X,  6, true };
      case 0x02: return (Instruction) {IT_JAM,  AM_IMPLIED,     2, false};
      case 0x03: return (Instruction) {IT_SLO,  AM_INDIRECT_X,  8, true };
      case 0x04: return (Instruction) {IT_NOP,  AM_ZEROPAGE,    3, true };
      case 0x05: return (Instruction) {IT_ORA,  AM_ZEROPAGE,    3, true };
      case 0x06: return (Instruction) {IT_ASL,  AM_ZEROPAGE,    5, true };
      // ...
      }
  }
  ```,
  kind: image,
  caption: [реализация функции декодирования операционного кода],
) <img-decode>

Функция "get_instruction_func" возвращает указатель на функцию из таблицы
инструкций. Каждая функция из таблицы имеет параметры:
указатель на структуру микропроцессора, таблицу функций адресации и операнд. На
рисунке @img-cpu-sta показан пример функции из таблицы инструкций,
реализующей инструкцию STA. Реализация всех функций инструкций представлена в
приложении @sup-instructions-c, функций адресации -- в приложении
@sup-addressing-c.

#figure(
  ```c
  void cpu_lda(Cpu *cpu, Addressing addressing, uint16_t operand) {
      cpu->A = addressing.load(cpu, operand);
      cpu_set_zn(cpu, cpu->A);
  }
  ```,
  kind: image,
  caption: [реализация инструкции STA]
) <img-cpu-sta>

== 3.4 Адресное пространство эмулятора

Для взаимодействия с микропроцессором необходимо организовать ввод-вывод данных. В
настоящей работе выбрана модель из руководства "Easy 6502", содержащая
следующие виртуальные устройства памяти, представленные на таблице
@table-address-space.

#figure(
  table(
    columns: 4,
    [*Диапазон адресов*],
    [*Размер, байт*],
    [*Назначение*],
    [*Защищён #footnote[Запись данных по указанным адресам невозможна]*],

    [00FE], [1], [Случайная величина], [*+*],
    [00FF], [1], [Последняя нажатая клавиша], [*+*],
    [0100 -- 01FF], [256], [Стэк вызовов], [],
    [0200 -- 05FF], [1024], [Дисплей], [],
    [0600 -- 7FFF], [31232], [RAM], [],
    [8000 -- FFFD], [32766], [ROM], [*+*],
    [FFFD -- FFFF], [6], [Векторы инициализации], [*+*],
  ),
  caption: [адресное пространство эмулятора]
) <table-address-space>

Дисплей представляет собой матрицу размером 32x32 пикселя и поддерживает 16
различных цветов. Размер одного пискела составляет 1 байт, однако значения 16 и
выше берутся по модулю 16 и интерпретируются как цвета от 0 до 15.

== 3.5 Графический интерфейс

Для разработки графического интерфейса выбрана библиотека Raylib, имеющая ряд
преимуществ:
- Разработана на языке.
- Проста в изучении и использовании.
- Предоставляет кроссплатформенные возможности создания и управления окном.
- Имеет обширное и дружелюбное сообщество.

При работе с библиотекой Raylib необходимо самостоятельно организовать цикл
событий.

Определение сруктуры приложения представлено на рисунке @img-app-struct.
Структура включает в себя указатели на устройство памяти и микропроцессор, а так же
цветовую схему, шрифт и набор служебных флагов.

#figure(
  ```c
  typedef struct App {
      RenderTexture target;
      Colors colors;
      Font font;
      Cpu *cpu;
      Memory *mem;
      bool close;
      bool debug_continue;
      bool do_execute;
  } App;
  ```,
  kind: image,
  caption: [определение структуры приложения],
) <img-app-struct>

Цикл событий представлен на рисунке @img-run-gui и представляет собой
классическую организацию цикла при работе с библиотекой Raylib. При запуске
приложения происходят такие действия, как:
1. создание окна размером 920x640 пикселов;
2. установка целевой частоты кадров 60 герц;
3. создание объекта приложение;
4. организация цикла приложения;
5. закрытие окна.

#figure(
  ```c
  void run_gui(Cpu *cpu, Memory *mem) {
      srand(time(NULL));
      InitWindow(920, 640, "6502");
      SetTargetFPS(60);
      App app = app_create(cpu, mem);
      while (!app.close) app_frame(&app);
      CloseWindow();
  }
  ```,
  kind: image,
  caption: [цикл событий графического приложения],
) <img-run-gui>

На рисунке @img-app-frame представлено тело цикла. Каждую итерацию происходит
проверка собития закрытия окна, обработка пользовательского ввода, выполнение
нескольких инструкций микропроцессора и отрисовка интерфейса.

#figure(
  ```c
  static void app_frame(App *app) {
      app->close = WindowShouldClose();
      if (app->close) return;
      app_handle_input(app);
      app_execute_cpu(app);
      app_draw(app);
  }
  ```,
  kind: image,
  caption: [тело цикла событий],
) <img-app-frame>

Результат запуска приложения показан на рисунке @img-gui. Интерфейс содержит
виртуальный дисплей, а также информация о регистрах микропроцессора и о доступных
горячих клавиш.

#figure(
  image("/assets/gui.png", width: 85%),
  caption: [графический интерфейс программного эмулятора],
) <img-gui>
