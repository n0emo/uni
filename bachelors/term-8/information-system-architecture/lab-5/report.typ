Федеральное государственное бюджетное образовательное учреждение высшего
образования

#strong[«ПЕТЕРБУРГСКИЙ ГОСУДАРСТВЕННЫЙ УНИВЕРСИТЕТ ПУТЕЙ СООБЩЕНИЯ ИМЕНИ
ИМПЕРАТОРА АЛЕКСАНДА I»]

#strong[\(ФГБОУ ВО ПГУПС)]

Кафедра «Информационные и вычислительные системы»

Дисциплина «Архитектура вычислительных систем»

Лабораторная работа №5

«Администрирование многопроцессорных вычислительных систем»

#figure(
  align(center)[#table(
    columns: (49.99%, 50.01%),
    align: (auto,auto,),
    table.header([Выполнил

      Студент группы ИВБ-211

      ], table.cell(align: right)[А. Шефнер

      ],),
    table.hline(),
    [Проверил

    Доц. каф. «ИВС»

    ], table.cell(align: right)[В.А. Гончаренко

    ],
  )]
  , kind: table
  )

= Цель занятия
<цель-занятия>
Цель занятия -- получение практических навыков анализа и управления
конфигурацией многопроцессорной вс, управления рабочей нагрузкой и
энергопотреблением ядер многоядерного процессора в операционных системах
windows 10/11.

= Ход работы
<ход-работы>
== Сведения о процессоре компьютера
<сведения-о-процессоре-компьютера>
Информация была получена из программ «Диспетчер задач» и «Диспетчер
устройств» (рисунок 1).

- Модель процессора: Intel® Core™ i5-10400 CPU \@ 2.90GHz

- Физических ядер: 6

- Логических ядер: 12

- Кэш L1: 384 КБ

- Кэш L2: 1,5 МБ

- Кэш L3: 12,9 МБ

#figure(
  align(center)[#table(
    columns: (57.85%, 42.15%),
    align: (auto,auto,),
    table.header([#box(image("lab-5/assets/media/image1.png", height: 3.13505in, width: 3.72093in))], [#box(image("lab-5/assets/media/image2.png", height: 2.80068in, width: 2.75581in))],),
    table.hline(),
    [а)], [б)],
  )]
  , kind: table
  )

#emph[Рисунок 1. Сведения о процессоре:]

#emph[a -- окно «Диспетчер задач»; б -- окно «Диспетчер устройств»]

== Оценка производительности при разном количестве ядер
<оценка-производительности-при-разном-количестве-ядер>
Для оценки производительности была использована программа «Lynx»
(рисунок 2)

#box(image("lab-5/assets/media/image3.png", height: 2.38289in, width: 3.76744in))

Рисунок 2. Окно программы «Lynx»

Результаты оценивания приведены в таблице 1.

Таблица 1. Результаты оценивания производительности.

#figure(
  align(center)[#table(
    columns: (25.74%, 54.61%),
    align: (auto,auto,),
    table.header([#strong[Количество ядер]], [#strong[Производительность
      (gflops/отн. Ед.)]],),
    table.hline(),
    table.cell(align: center)[1], table.cell(align: center)[56],
    table.cell(align: center)[2], table.cell(align: center)[99],
    table.cell(align: center)[3], table.cell(align: center)[131],
    table.cell(align: center)[4], table.cell(align: center)[156],
    table.cell(align: center)[5], table.cell(align: center)[170],
    table.cell(align: center)[6], table.cell(align: center)[177],
    table.cell(align: center)[7], table.cell(align: center)[165],
    table.cell(align: center)[8], table.cell(align: center)[164],
    table.cell(align: center)[9], table.cell(align: center)[128],
    table.cell(align: center)[10], table.cell(align: center)[136],
    table.cell(align: center)[11], table.cell(align: center)[123],
    table.cell(align: center)[12], table.cell(align: center)[135],
  )]
  , kind: table
  )

Визуализация результатов представлена на графике (рисунок 3).

Рисунок 3. График зависимости между количеством ядер и
производительностью (GFLOPS)

== Эксперименты по привязке процессов к ядрам.
<эксперименты-по-привязке-процессов-к-ядрам.>
Были проверены 3 конфигурации (таблица 2):

Таблица 2 -- различные конфигурации назначения процессов к ядрам

#figure(
  align(center)[#table(
    columns: (28.46%, 25.26%, 25.26%, 21.01%),
    align: (center,auto,auto,auto,),
    table.header(table.cell(align: center)[#strong[Конфигурация]], table.cell(align: center)[#strong[Процесс
      1]], table.cell(align: center)[#strong[Процесс
      2]], table.cell(align: center)[#strong[Загрузка ЦП]],),
    table.hline(),
    table.cell(align: center)[1], table.cell(align: center)[ЦП
    0], table.cell(align: center)[ЦП 1], table.cell(align: center)[28%],
    table.cell(align: center)[2], table.cell(align: center)[ЦП
    0], table.cell(align: center)[ЦП 0], table.cell(align: center)[15%],
    table.cell(align: center)[3], table.cell(align: center)[ЦП
    0], table.cell(align: center)[ЦП 2], table.cell(align: center)[28%],
  )]
  , kind: table
  )

Скриншоты диспетчера задач и окон «Lynx» показаны на рисунках 4-6.

#box(image("lab-5/assets/media/image4.png", height: 3.22093in, width: 6.64428in))

Рисунок 4 -- конфигурация 1

#box(image("lab-5/assets/media/image5.png", height: 3.16279in, width: 6.54455in))

Рисунок 5 -- конфигурация 2

#box(image("lab-5/assets/media/image6.png", height: 3.19767in, width: 6.61673in))

Рисунок 6 -- конфигурация 3

#strong[Вывод]: после назначение процессов на одно ядро загрузка всего
процессора упала с 28 до 15 процентов. Использование двух логических и
двух физических ядер не возымело эффекта/

== Наблюдения о производительности при разных режимах электропитания
<наблюдения-о-производительности-при-разных-режимах-электропитания>
Для тестирования была выбрана конфигурация «Максимальная
производительность». Сначала максимальная загрузка процессора была
установлено на значение 100%, затем -- на 50%. На рисунке 7 виден график
загрузки ЦП, на котором отражено падение использование ЦП после
изменения значения максимальной загрузки процессора. Производительность
так же упала в 2 раза.

#box(image("lab-5/assets/media/image7.png", height: 3.26705in, width: 4.16279in))

Рисунок 7 -- график использования ЦП

= Вывод
<вывод>
В ходе работы были изучены различные конфигурации многопроцессорной
системы и были проведены различные эксперименты по оценке
производительности в разных конфигурациях. Больше ядер не означает выше
производительность -- программное обеспечение так же должно расходовать
мощность эффективно. Программа «Lynx» оказалась неэффективной для
сравнения производительности.
