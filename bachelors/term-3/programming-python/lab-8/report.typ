ФЕДЕРАЛЬНОЕ АГЕНСТВО ЖЕЛЕЗНОДОРОЖНОГО ТРАНСПОРТА

Федеральное государственное бюджетное образовательное учреждение высшего
образования

«ПЕТЕРБУРГСКИЙ ГОСУДАРСТВЕННЫЙ УНИВЕРСИТЕТ ПУТЕЙ СООБЩЕНИЯ Императора
Александра I»

Кафедра «Информационные и вычислительные системы»

Дисциплина «Программирование на языках высокого уровня (Python)»

#strong[ОТЧЁТ]

#strong[ПО ЛАБОРАТОРНОЙ РАБОТЕ № #strong[8]]

#strong[]

#figure(
  align(center)[#table(
    columns: 2,
    align: (auto,auto,),
    [Выполнил студент

    Факультет: АИТ

    Группа: ИВБ-211

    ], [Шефнер А.],
    [Проверил: ], [Баталов Д.И. ],
  )]
  , kind: table
  )

#strong[Санкт-Петербург]

#strong[2023]

Оценочный лист результатов ЛР № 8

Ф.И.О. студента \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_#emph[Шефнер
Альберт]\_\_\_\_\_

Группа \_\_\_\_\_\_\_\_\_\_\_\_\_#emph[ИВБ-211]\_\_\_\_\_\_\_\_\_\_\_\_

#figure(
  align(center)[#table(
    columns: 6,
    align: (auto,auto,auto,auto,auto,auto,),
    [#strong[№]

    #strong[п/п]

    ], [#strong[Материалы необходимые для оценки знаний, умений ]

    #strong[и навыков]

    ], [#strong[Показатель]

    #strong[ оценивания ]

    ], [#strong[Критерии ]

    #strong[Оценивания]

    ], [#strong[Шкала оценивания]], [#strong[]

    #strong[]

    #strong[Оценка]

    ],
    table.cell(rowspan: 6)[1

    ], table.cell(rowspan: 6)[Лабораторная
    работа№], table.cell(rowspan: 2)[Соответствие методике
    выполнения], [Соответствует], [7], table.cell(rowspan: 2)[],
    [Не соответствует], [0],
    table.cell(rowspan: 2)[Срок выполнения], [Выполнена в
    срок], [2], table.cell(rowspan: 2)[],
    [Выполнена с опозданием на 2 недели], [0],
    table.cell(rowspan: 2)[оформление], [Соответствует требованиям], [1

    0

    ], table.cell(rowspan: 2)[],
    [Не соответствует], [],
    [], [#strong[ИТОГО количество баллов]], [], [], [ 10], [],
  )]
  , kind: table
  )

Доцент кафедры

«Информационные и вычислительные

системы» Баталов Д.И. «\_\_» \_\_\_\_\_\_\_\_\_\_2023 г.

#strong[\10. Напишите программу, позволяющую заходить в ее основное окно
только авторизированным пользователям, с возможностью регистрации нового
пользователя. Хеш связки «логин:пароль» пользователей хранится в
отдельном файле.]

#strong[Код]

#box(image("lab-8/assets/Pictures/1000000100000239000001EFA9E7782DBD856521.png", height: 5.1563in, width: 5.9272in))Импорты

Константа с относительным путём к файлу с паролями

#box(image("lab-8/assets/Pictures/10000001000001C100000051E1325D399D144D87.png", height: 0.8437in, width: 4.6772in))

Функции для работы с логином и паролем

#box(image("lab-8/assets/Pictures/1000000100000397000003E7A504BED0469A2099.png", height: 7.3138in, width: 6.7283in))

#box(image("lab-8/assets/Pictures/100000010000036500000061B2E9F6ABA4D312DE.png", height: 0.7508in, width: 6.7283in))Класс
виджета авторизации

#box(image("lab-8/assets/Pictures/1000000100000365000004C78AE2917081BA61E5.png", height: 9.4689in, width: 6.7283in))

Класс виджета регистрации

#box(image("lab-8/assets/Pictures/100000010000036F000003A7FFDC61B26661180D.png", height: 7.1571in, width: 6.7283in))

#box(image("lab-8/assets/Pictures/10000001000003B90000026B00966C45527D25B9.png", height: 4.3701in, width: 6.7283in))

Класс виджета Казахстан

#box(image("lab-8/assets/Pictures/10000001000004110000022F2F8959C26F569CAF.png", height: 3.6126in, width: 6.7283in))

#box(image("lab-8/assets/Pictures/1000000100000381000002E1C75327459332284A.png", height: 5.528in, width: 6.7283in))

Класс главного окна

#box(image("lab-8/assets/Pictures/10000001000003DB000001996DC9B7397D798619.png", height: 2.7874in, width: 6.7283in))

#box(image("lab-8/assets/Pictures/10000001000003F300000489B88D7FF53DEE2BC3.png", height: 7.7264in, width: 6.7283in))#box(image("lab-8/assets/Pictures/10000001000003F3000001054EB6B53BD0C50311.png", height: 1.7366in, width: 6.7283in))

#box(image("lab-8/assets/Pictures/10000001000004B5000002476EED8B42A7CAD4EB.png", height: 3.2547in, width: 6.7283in))

Точка входа программы

#box(image("lab-8/assets/Pictures/10000001000001D1000000A56EFD1FE2148E3E3D.png", height: 1.7189in, width: 4.8437in))

#strong[]

#strong[Отладка]

#box(image("lab-8/assets/Pictures/10000001000001AC000001E39F246ADAE549DCCC.png", height: 4.4492in, width: 3.9425in))#box(image("lab-8/assets/Pictures/100000010000024F000001DBA2D7F231F4B64CE5.png", height: 4.2043in, width: 5.2311in))

#box(image("lab-8/assets/Pictures/10000001000001AF000001DB827FDC3C9811090B.png", height: 4.5146in, width: 4.0965in))#box(image("lab-8/assets/Pictures/10000001000001AF000001DB4925D9BA6B715387.png", height: 4.4898in, width: 4.0736in))

#box(image("lab-8/assets/Pictures/10000001000001AF00000259962F575C1A8F2B61.png", height: 5.8091in, width: 4.1661in))#box(image("lab-8/assets/Pictures/10000001000001AF000001D5F4090791FBEDA9F7.png", height: 3.6839in, width: 3.3854in))

#box(image("lab-8/assets/Pictures/100000010000027C0000043753D71CCBD8657F6A.png", height: 9.3984in, width: 5.539in))

#strong[#box(image("lab-8/assets/Pictures/10000001000004CF0000016722403914989E46E7.png", height: 1.9618in, width: 6.7283in))]

#strong[\20. Напишите программу-игру «Змейка».]

#strong[Код]

Импорты

#box(image("lab-8/assets/Pictures/10000001000003B30000020FD2F48427D5FADA13.png", height: 3.7437in, width: 6.7283in))

Перечисление направлений змейки

#box(image("lab-8/assets/Pictures/10000001000001FB0000009B5BBF254B77E85510.png", height: 1.3437in, width: 4.3953in))

Класс точки

#box(image("lab-8/assets/Pictures/100000010000033900000133AE3E35F93F4D454B.png", height: 2.5035in, width: 6.7283in))

Класс змейки (главного героя)

#box(image("lab-8/assets/Pictures/10000001000003F9000003395657AD3B069F88DF.png", height: 5.4575in, width: 6.7283in))

Класс игры, в котором хранится текущее состояние игры и происходит
основная логика

#box(image("lab-8/assets/Pictures/100000010000037700000417C5606441EF9B628F.png", height: 7.9417in, width: 6.7283in))

#box(image("lab-8/assets/Pictures/10000001000004AB00000211BF4D762D42B8DC4A.png", height: 2.9783in, width: 6.7283in))

Класс-виджет, отвечающий за отрисовку игры

#box(image("lab-8/assets/Pictures/100000010000044D00000363C9FB93A975A7CF92.png", height: 5.298in, width: 6.7283in))

#box(image("lab-8/assets/Pictures/100000010000044D000001AB587CBBFAD533ACF7.png", height: 2.6091in, width: 6.7283in))

Класс главного окна, в котором происходит управление игрой и обработка
событий

#box(image("lab-8/assets/Pictures/10000001000003670000030B203D45B8FF6274A7.png", height: 5.6882in, width: 6.3602in))

#box(image("lab-8/assets/Pictures/1000000100000371000001B7BEC0CFAF5138B0EC.png", height: 3.3528in, width: 6.7283in))

Точка входа программы

#box(image("lab-8/assets/Pictures/1000000100000227000000CD7F1DA5491266080D.png", height: 2.1354in, width: 5.7398in))

#strong[Отладка]

#strong[#box(image("lab-8/assets/Pictures/10000001000004E8000004090A2BB49D00B17D8B.png", height: 4.6008in, width: 5.5945in))]

#strong[]

#strong[]

#strong[]

#strong[]

#strong[]

#strong[]

#strong[]

#strong[]

#strong[]

#strong[]

#strong[]

#strong[#box(image("lab-8/assets/Pictures/10000001000004E800000409C1F66F4161DE4247.png", height: 4.6043in, width: 5.5984in))]

#strong[]

#strong[]
