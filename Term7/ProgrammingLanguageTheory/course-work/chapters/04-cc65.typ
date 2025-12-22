= 4. Тестирование и демонстрация работы эмулятора

== 4.1 Интеграция набора инструментов CC65

СС65 -- это набор инструментов, предназначенный для разработки приложений под
микропроцессоры архитектуры 65xx и включающий в себя компилятор C, ассемблер,
дизассемблер, компоновщик и другие инструменты @cc65. CC65 доступен на операционных
системах MacOS, Windows и семейства Linux.

В настоящей работе будут использованы инструменты ca65 (ассемблер) и ld65
(компоновщик) через иинтерфейс командной строки. На рисунке @img-build-sample
показан сценарий Justfile [TODO], выполняющий сборку и компоновку программы.

#figure(
  ```make
  build-sample name:
      ca65 \
          --listing {{ samples / name + ".lst" }} \
          -o {{ samples / name + ".o" }} \
          {{ samples / name + ".s" }}
      ld65 \
          --config memory.cfg \
          -o {{ samples / name + ".rom" }} \
          {{ samples / name + ".o" }}
  ```,
  kind: image,
  caption: [Сценарий сборки приложения на языке ассемблера]
) <img-build-sample>

== 4.2 Описание модели памяти компоновщика

В разделе 3.2 было показано определение модели памяти программного эмулятора.
Для того, чтобы программа на языке ассемблера имела возможность выполнения при
такой модели памяти, необходимо создать файл конфигурации компоновщика.
Содержание файла memory.cfg показано на рисунке @img-memory-cfg. Для выполнения
программы релевантна лишь часть виртуальных устройств памяти, в частности
сегменты кода и векторов инициализации.

#figure(
  ```
  MEMORY {
    ROM: start = $8000, size = $8000, file = %O, fill = yes;
  }
  SEGMENTS {
    code:         load = ROM, TYPE = ro;
    vectors:      load = ROM, type = ro, start = $fffa;
  }
  ```,
  kind: image,
  caption: [Конфигурация модели памяти]
) <img-memory-cfg>

== 4.3 Адаптация исходного кода "Змейки" из руководства "Easy 6502"

=== Определение констант

В оригинальном руководстве используется синтаксис с использованием директивы
define для определения констант (рисунок @img-consts-define), однако ассемблер
CC65 не поддерживает его.

#figure(
  ```yasm
  ; System variables
  define sysRandom  $fe
  define sysLastKey $ff
  ```,
  kind: image,
  caption: [Определение констант с помощью синтаксиса CC65],
) <img-consts-define>

В ассемблере CC65 используется синтаксис со знаком "=", версия с изменённым
синтаксисом показана на рисунке @img-consts-eq.

#figure(
  ```yasm
  ; System variables
  sysRandom  = $fe
  sysLastKey = $ff
  ```,
  kind: image,
  caption: [Определение констант с помощью синтаксиса CC65],
) <img-consts-eq>

Остаётся лишь определить местонахождение сегментов кода. Для этого необходимо
использовать директиву segment. На рисунке @img-code-segments показано
определение сегментов "Code" и "Vectors" из конфигурации модели памяти.

#figure(
  ```yasm
  .segment "code"
  start:
    jsr init
    jsr loop

  ; Snake code

  .segment "vectors"
      .word 0
      .word start
      .word 0
  ```,
  kind: image,
  caption: [Определение сегментов кода],
) <img-code-segments>

Для запуска тестового приложения на языке ассемблера можно воспользоваться
сценарием run-sample. Этот сценарий сначала соберёт приложение на языке
ассемблера с помощью рецепта build-sample (рисунок @img-build-sample), затем
выполнит сборку программного эмулятора, и в конце запустит эмулятор, используя
собранный ROM. На рисунке @img-run-sample показан вывод вывод командной строки 
сценария run-sample.

#figure(
  ```
  $ just run-sample snake
  ca65 --listing samples/snake.lst -o samples/snake.o samples/snake.s
  ld65 --config memory.cfg -o samples/snake.rom samples/snake.o
  cmake --build build
  ninja: no work to do.
  ./build/mos6502 run samples/snake.rom
  PC resetted to 0x8000
  INFO: Initializing raylib 5.5
  INFO: Platform backend: DESKTOP (GLFW)
  ```,
  kind: image,
  caption: [Логи сценария run-sample]
) <img-run-sample>

На рисунке @img-snake показан результат запуска игры "Змейки" на программном
эмуляторе.

#figure(
  image("/assets/snake.png", width: 80%),
  caption: [Игра "Змейка" на программном эмуляторе]
) <img-snake>
