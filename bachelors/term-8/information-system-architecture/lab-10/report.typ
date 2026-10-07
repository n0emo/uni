Федеральное государственное бюджетное образовательное учреждение высшего
образования

#strong[«ПЕТЕРБУРГСКИЙ ГОСУДАРСТВЕННЫЙ УНИВЕРСИТЕТ ПУТЕЙ СООБЩЕНИЯ ИМЕНИ
ИМПЕРАТОРА АЛЕКСАНДА I»]

#strong[\(ФГБОУ ВО ПГУПС)]

Кафедра «Информационные и вычислительные системы»

Дисциплина «Архитектура вычислительных систем»

Лабораторная работа №10

«Оценивание качества функционирования вычислительных систем»

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
Цель занятия -- получение практических навыков оценивания
производительности системы (ВС)

= Ход работы
<ход-работы>
== Тестирование с различным количеством потоков и битности
<тестирование-с-различным-количеством-потоков-и-битности>
Таблицы 1 и 2 с результатами тестирования производительности
вычислительной системы программным комплексом LinX 0.6.4 при различном
количестве входных потоков данных (тестирующих потоков Linpack) для
режимов «32-бит» и «64-бит» представлены далее.

Таблица 1. Результаты тестирования

#figure(
  align(center)[#table(
    columns: (49.84%, 50.16%),
    align: (center,auto,),
    table.header(table.cell(align: center)[32-бит

      ], table.cell(align: center)[64-бит

      ],),
    table.hline(),
    table.cell(align: center, colspan: 2)[1 потока Linpack

    ],
    table.cell(align: center)[#box(image("lab-10/assets/media/image1.png", height: 1.96337in, width: 3.10417in))

    #box(image("lab-10/assets/media/image2.png", height: 1.11742in, width: 3.07292in))

    #box(image("lab-10/assets/media/image3.png", height: 2.00307in, width: 2.98958in))

    ], [#box(image("lab-10/assets/media/image4.png", height: 1.96319in, width: 3.10389in))

    #box(image("lab-10/assets/media/image5.png", height: 1.10985in, width: 3.05208in))

    #box(image("lab-10/assets/media/image6.png", height: 2.01319in, width: 3.0047in))

    ],
    table.cell(align: center, colspan: 2)[2 потока Linpack

    ],
    table.cell(align: center)[#box(image("lab-10/assets/media/image7.png", height: 1.94361in, width: 3.07292in))

    #box(image("lab-10/assets/media/image8.png", height: 1.11742in, width: 3.07292in))

    #box(image("lab-10/assets/media/image9.png", height: 2.03125in, width: 3.03164in))

    ], table.cell(align: center)[#box(image("lab-10/assets/media/image10.png", height: 1.92384in, width: 3.04167in))

    #box(image("lab-10/assets/media/image11.png", height: 1.10581in, width: 3.04097in))

    #box(image("lab-10/assets/media/image12.png", height: 2.0375in, width: 3.04097in))

    ],
    table.cell(align: center, colspan: 2)[3 потока Linpack

    ],
    table.cell(align: center)[#box(image("lab-10/assets/media/image13.png", height: 1.91725in, width: 3.03125in))

    #box(image("lab-10/assets/media/image14.png", height: 1.10227in, width: 3.03125in))

    #box(image("lab-10/assets/media/image15.png", height: 2.07286in, width: 3.09375in))

    ], [#box(image("lab-10/assets/media/image16.png", height: 1.91725in, width: 3.03125in))#box(image("lab-10/assets/media/image17.png", height: 1.10227in, width: 3.03125in))

    #box(image("lab-10/assets/media/image18.png", height: 2.08449in, width: 3.11111in))

    ],
    table.cell(align: center, colspan: 2)[4 потока Linpack

    ],
    table.cell(align: center)[#box(image("lab-10/assets/media/image19.png", height: 1.97655in, width: 3.125in))

    #box(image("lab-10/assets/media/image20.png", height: 1.125in, width: 3.09375in))

    #box(image("lab-10/assets/media/image21.png", height: 2.00307in, width: 2.98958in))

    ], [#box(image("lab-10/assets/media/image22.png", height: 1.97655in, width: 3.125in))

    #box(image("lab-10/assets/media/image23.png", height: 1.13258in, width: 3.11458in))

    #box(image("lab-10/assets/media/image24.png", height: 2.06356in, width: 3.07986in))

    ],
    table.cell(align: center, colspan: 2)[8 потоков Linpack

    ],
    table.cell(align: center)[#box(image("lab-10/assets/media/image25.png", height: 1.95678in, width: 3.09375in))

    #box(image("lab-10/assets/media/image26.png", height: 1.11364in, width: 3.0625in))

    #box(image("lab-10/assets/media/image27.png", height: 1.98911in, width: 2.96875in))

    ], table.cell(align: center)[#box(image("lab-10/assets/media/image28.png", height: 1.97655in, width: 3.125in))

    #box(image("lab-10/assets/media/image29.png", height: 1.14394in, width: 3.14583in))

    #box(image("lab-10/assets/media/image30.png", height: 2.00074in, width: 2.98611in))

    ],
    table.cell(align: center, colspan: 2)[16 потоков Linpack

    ],
    table.cell(align: center)[#box(image("lab-10/assets/media/image31.png", height: 1.91725in, width: 3.03125in))

    #box(image("lab-10/assets/media/image32.png", height: 1.07955in, width: 2.96875in))

    #box(image("lab-10/assets/media/image33.png", height: 2.0589in, width: 3.07292in))

    ], table.cell(align: center)[#box(image("lab-10/assets/media/image34.png", height: 1.90407in, width: 3.01042in))#box(image("lab-10/assets/media/image35.png", height: 1.0947in, width: 3.01042in))#box(image("lab-10/assets/media/image36.png", height: 2.01703in, width: 3.01042in))

    ],
  )]
  , kind: table
  )

Таблица 2. Результаты тестирования

#figure(
  align(center)[#table(
    columns: (20%, 19.99%, 20.06%, 19.98%, 19.97%),
    align: (auto,auto,auto,auto,auto,),
    table.header([Количество потоков

      ], [Разрядность бит

      ], [Длительность теста

      \(сек.)

      ], [Макс. производ. (GFLOPS)

      ], [Макс.

      Темп. ЦП

      \(C)

      ],),
    table.hline(),
    table.cell(rowspan: 2)[1

    ], [32

    ], [9

    ], [19

    ], [17

    ],
    [64

    ], [7

    ], [27.6

    ], [15

    ],
    table.cell(rowspan: 2)[2

    ], [32

    ], [6

    ], [48.9

    ], [29

    ],
    [64

    ], [5

    ], [50

    ], [29

    ],
    table.cell(rowspan: 2)[3

    ], [32

    ], [5

    ], [66

    ], [22

    ],
    [64

    ], [5

    ], [70.5

    ], [23

    ],
    table.cell(rowspan: 2)[4

    ], [32

    ], [6

    ], [80.9

    ], [28

    ],
    [64

    ], [4

    ], [86.5

    ], [23

    ],
    table.cell(rowspan: 2)[8

    ], [32

    ], [5

    ], [84.2

    ], [28

    ],
    [64

    ], [5

    ], [87.3

    ], [30

    ],
    table.cell(align: left, rowspan: 2)[16

    ], [32

    ], [6

    ], [77

    ], [32

    ],
    [64

    ], [6

    ], [76.1

    ], [31

    ],
  )]
  , kind: table
  )

На рисунке 1 представлены графики по значениям таблицы 2.

#box(image("lab-10/assets/media/image37.png", height: 4.81258in, width: 6.11458in))

Рисунок 1. Графики температуры ЦП, длительности теста и
производительности при разном количестве потоков.

== Тестирование с различным размером задач
<тестирование-с-различным-размером-задач>
Таблицы 3 и 4 с результатами тестирования производительности
вычислительной системы программным комплексом LinX 0.6.4 при различном
размере задач (тестирующих потоков Linpack)» представлены далее.

Таблица 3. Результаты тестирования

#figure(
  align(center)[#table(
    columns: (99.89%),
    align: (auto,),
    table.header([«Объем задачи (МиБ)»: 1000

      ],),
    table.hline(),
    table.cell(align: center)[#box(image("lab-10/assets/media/image38.png", height: 3.40673in, width: 5.38617in))

    #box(image("lab-10/assets/media/image39.png", height: 1.95861in, width: 5.38617in))

    #box(image("lab-10/assets/media/image40.png", height: 3.88749in, width: 5.80208in))

    ],
    [«Объем задачи (МиБ)»: 2000

    ],
    table.cell(align: center)[#box(image("lab-10/assets/media/image41.png", height: 3.40673in, width: 5.38617in))

    #box(image("lab-10/assets/media/image42.png", height: 1.95861in, width: 5.38617in))

    #box(image("lab-10/assets/media/image43.png", height: 3.56644in, width: 5.32292in))

    ],
    [«Объем задачи (МиБ)»: 3000

    ],
    table.cell(align: center)[#box(image("lab-10/assets/media/image44.png", height: 3.40673in, width: 5.38617in))

    #box(image("lab-10/assets/media/image45.png", height: 1.95861in, width: 5.38617in))

    #box(image("lab-10/assets/media/image46.png", height: 3.47571in, width: 5.1875in))

    ],
    [«Объем задачи (МиБ)»: 4000

    ],
    table.cell(align: center)[#box(image("lab-10/assets/media/image47.png", height: 3.40673in, width: 5.38617in))

    #box(image("lab-10/assets/media/image48.png", height: 1.95861in, width: 5.38617in))

    #box(image("lab-10/assets/media/image49.png", height: 3.52456in, width: 5.26042in))

    ],
    [«Объем задачи (МиБ)»: 5000

    ],
    table.cell(align: center)[#box(image("lab-10/assets/media/image50.png", height: 3.40673in, width: 5.38617in))

    #box(image("lab-10/assets/media/image51.png", height: 1.95861in, width: 5.38617in))

    #box(image("lab-10/assets/media/image52.png", height: 3.55946in, width: 5.3125in))

    ],
    [«Объем задачи (МиБ)»: 6000

    ],
    table.cell(align: center)[#box(image("lab-10/assets/media/image53.png", height: 3.40673in, width: 5.38617in))

    #box(image("lab-10/assets/media/image54.png", height: 1.95861in, width: 5.38617in))

    #box(image("lab-10/assets/media/image55.png", height: 3.57342in, width: 5.33333in))

    ],
    [«Объем задачи (МиБ)»: 7000

    ],
    table.cell(align: center)[#box(image("lab-10/assets/media/image56.png", height: 3.40673in, width: 5.38617in))

    #box(image("lab-10/assets/media/image57.png", height: 1.95861in, width: 5.38617in))

    #box(image("lab-10/assets/media/image58.png", height: 3.52456in, width: 5.26042in))

    ],
    [«Объем задачи (МиБ)»: 8000

    ],
    table.cell(align: center)[#box(image("lab-10/assets/media/image59.png", height: 3.40673in, width: 5.38617in))

    #box(image("lab-10/assets/media/image60.png", height: 1.95861in, width: 5.38617in))

    #box(image("lab-10/assets/media/image61.png", height: 3.55248in, width: 5.30208in))

    ],
    [«Объем задачи (МиБ)»: 9000

    ],
    table.cell(align: center)[#box(image("lab-10/assets/media/image62.png", height: 3.40673in, width: 5.38617in))

    #box(image("lab-10/assets/media/image63.png", height: 1.95861in, width: 5.38617in))

    #box(image("lab-10/assets/media/image64.png", height: 3.53154in, width: 5.27083in))

    ],
    [«Объем задачи (МиБ)»: 10000

    ],
    table.cell(align: center)[#box(image("lab-10/assets/media/image65.png", height: 3.40673in, width: 5.38617in))

    #box(image("lab-10/assets/media/image66.png", height: 1.95861in, width: 5.38617in))

    #box(image("lab-10/assets/media/image67.png", height: 3.62227in, width: 5.40625in))

    ],
  )]
  , kind: table
  )

Таблица 4. Результаты тестирования

#figure(
  align(center)[#table(
    columns: (25%, 25%, 25%, 25.01%),
    align: (center,auto,auto,auto,),
    table.header(table.cell(align: center)[Объем задачи
      (МиБ)], table.cell(align: center)[Длительность
      теста], table.cell(align: center)[Максимальная
      производит.], table.cell(align: center)[Максимальная температура
      ЦП],),
    table.hline(),
    table.cell(align: center)[1000], table.cell(align: center)[1], table.cell(align: center)[110.2], table.cell(align: center)[24],
    table.cell(align: center)[2000], table.cell(align: center)[5], table.cell(align: center)[77.1], table.cell(align: center)[28],
    table.cell(align: center)[3000], table.cell(align: center)[13], table.cell(align: center)[90.6], table.cell(align: center)[33],
    table.cell(align: center)[4000], table.cell(align: center)[24], table.cell(align: center)[98.7], table.cell(align: center)[34],
    table.cell(align: center)[5000], table.cell(align: center)[40], table.cell(align: center)[103.2], table.cell(align: center)[37],
    table.cell(align: center)[6000], table.cell(align: center)[61], table.cell(align: center)[105.9], table.cell(align: center)[44],
    table.cell(align: center)[7000], table.cell(align: center)[89], table.cell(align: center)[108], table.cell(align: center)[47],
    table.cell(align: center)[8000], table.cell(align: center)[131], table.cell(align: center)[97.7], table.cell(align: center)[51],
    table.cell(align: center)[9000], table.cell(align: center)[179], table.cell(align: center)[95.2], table.cell(align: center)[50],
    table.cell(align: center)[10000], table.cell(align: center)[293], table.cell(align: center)[69.8], table.cell(align: center)[52],
  )]
  , kind: table
  )

На рисунке 2 представлены графики по значениям таблицы 4.

#box(image("lab-10/assets/media/image68.png", height: 5.55707in, width: 5.54167in))

Рисунок 2. Графики температуры ЦП, длительности теста и
производительности при разном размере задач.

== Контрольные вопросы.
<контрольные-вопросы.>
\1. #strong[Дайте определение эффективности ВС.] это мера соответствия
ВС своему предназначению. Количественно эффективность оценивается
показателями эффективности. Любая ВС обладает совокупностью свойств,
определяющих ее качество.

пригодности для использования по назначению.

\2. #strong[В чем разница между свойством и качеством ВС?] Переменная,
количественно описывающая некоторое свойство ВС, называется показателем
свойства ВС. Совокупность показателей свойств ВС называется ее
показателем качества. Одним из наиболее важных показателей качества ВС,
как правило, является ее производительность

\3. #strong[Дайте определение показателя качества ВС.] Совокупность
показателей свойств ВС называется показателем качества.

\4. #strong[Что такое производительность ВС и от чего она зависит?] Под
производительностью понимают количество вычислительной работы,
выполняемой ВС в единицу времени. На практике производительность ВС
оценивается показателями производительности и быстродействия.

\5. #strong[Какие существуют методы оценивания производительности ВС?]
Для получения оценок производительности используют два основных метода:

#quote(block: true)[
− метод PDR (processing data rate -- скорость обработки данных);

− метод смесей команд.
]

\6. #strong[Что показывает единица измерения производительности MIPS?]
MIPS -- миллион команд в секунду.

\7. #strong[Что показывает единица измерения производительности MFLOPS?]
MFLOPS -- миллион чисел-результатов вычислений с плавающей запятой в
секунду.

\8. #strong[Основное содержание и назначение теста LINPACK.] Для
проведения контрольных испытаний в целях измерения производительности
ВС.

= Выводы
<выводы>
В ходе работы были получены практические навыки оценивания
производительности ВС.
