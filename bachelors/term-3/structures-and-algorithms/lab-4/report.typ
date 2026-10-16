ФЕДЕРАЛЬНОЕ АГЕНСТВО ЖЕЛЕЗНОДОРОЖНОГО ТРАНСПОРТА

Федеральное государственное бюджетное образовательное учреждение высшего
образования

«ПЕТЕРБУРГСКИЙ ГОСУДАРСТВЕННЫЙ УНИВЕРСИТЕТ ПУТЕЙ СООБЩЕНИЯ Императора
Александра I»

Кафедра «Информационные и вычислительные системы»

Дисциплина «Структуры и алгоритмы обработки данных»

#strong[ОТЧЁТ]

#strong[ПО ЛАБОРАТОРНОЙ РАБОТЕ № 4]

#figure(
  align(center)[#table(
    columns: (37.14%, 62.86%),
    align: (auto,auto,),
    table.header([Выполнил студент

      Факультет: АИТ

      Группа: ИВБ-211

      ], table.cell(align: right)[Шефнер А.

      ],),
    table.hline(),
    [Проверил:

    ], table.cell(align: right)[канд. ист. наук Забродин Андрей
    Владимирович

    ],
  )]
  , kind: table
  )

#strong[Санкт-Петербург]

#strong[2023]

Оценочный лист результатов ЛР № 4

Ф.И.О. студента \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_#underline[Шефнер
Альберт]\_\_\_\_\_

Группа
\_\_\_\_\_\_\_\_\_\_\_\_\_#underline[ИВБ-211]\_\_\_\_\_\_\_\_\_\_\_\_

#figure(
  align(center)[#table(
    columns: (5.85%, 22.05%, 21.5%, 21.59%, 17.06%, 11.95%),
    align: (center,auto,auto,auto,auto,auto,),
    table.header(table.cell(align: center)[#strong[№]

      #strong[п/п]

      ], table.cell(align: center)[#strong[Материалы необходимые для
      оценки знаний, умений]

      #strong[и навыков]

      ], table.cell(align: center)[#strong[Показатель]

      #strong[оценивания]

      ], table.cell(align: center)[#strong[Критерии]

      #strong[Оценивания]

      ], table.cell(align: center)[#strong[Шкала оценивания]

      ], [#strong[Оценка]

      ],),
    table.hline(),
    table.cell(align: center, rowspan: 6)[1#highlight[]

    #highlight[]

    ], table.cell(align: center, rowspan: 6)[Лабораторная работа№

    ], table.cell(align: center, rowspan: 2)[Соответствие методике
    выполнения

    ], table.cell(align: center)[Соответствует

    ], table.cell(align: center)[7

    ], table.cell(rowspan: 2)[],
    table.cell(align: center)[Не соответствует

    ], table.cell(align: center)[0

    ],
    table.cell(align: center, rowspan: 2)[Срок выполнения

    ], table.cell(align: center)[Выполнена в срок

    ], table.cell(align: center)[2

    ], table.cell(rowspan: 2)[],
    table.cell(align: center)[Выполнена с опозданием на 2 недели

    ], table.cell(align: center)[0

    ],
    table.cell(align: center, rowspan: 2)[оформление

    ], table.cell(align: center)[Соответствует требованиям

    ], table.cell(align: center)[1

    0

    ], table.cell(rowspan: 2)[],
    table.cell(align: center)[Не соответствует

    ], table.cell(align: center)[],
    table.cell(align: center)[#highlight[]

    ], table.cell(align: center)[#strong[ИТОГО количество баллов]

    ], table.cell(align: center)[], table.cell(align: center)[], [10

    ], [],
  )]
  , kind: table
  )

Заместитель заведующего кафедрой

«Информационные и вычислительные

системы» Забродин А.В. «\_\_» \_\_\_\_\_\_\_\_\_\_2023 г.

#strong[Цели работы:]

- Освоить различные алгоритмы работы со строками

#strong[Задание]

- алгоритм Рабина-Карпа

- алгоритм Кнута-Мориса-Пратта

- наибольшая общая подпоследовательность

- вычисление редакционного расстояния

#strong[Используемые средства]

В качестве редактора кода Neovim.

Для работы в консоли с потоками ввода-вывода использовалась стандартная
библиотека \<iostream\>.

Для поддержки функционального программирования использовалась библиотека
\<functional\>.

Для поддержки вывода символов кодировки Юникод использовались
\<codecvt\> и \<locale\>

#strong[Исходный код]

Исходный код программы доступен по ссылке:

#strong[https:/\/github.com/n0emo/uni/tree/main/3%20term/Structures%20and%20Algorithms/Lab%204]

#strong[Вывод]

Я изучил и реализовал алгоритм Рабина-Карпа, алгоритм
Кнута-Мориса-Пратта, алгоритм для нахождения наибольшей общей
последовательности и алгоритм вычисления редакционного расстояния.
