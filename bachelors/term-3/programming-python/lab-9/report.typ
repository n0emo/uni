ФЕДЕРАЛЬНОЕ АГЕНСТВО ЖЕЛЕЗНОДОРОЖНОГО ТРАНСПОРТА

Федеральное государственное бюджетное образовательное учреждение высшего
образования

«ПЕТЕРБУРГСКИЙ ГОСУДАРСТВЕННЫЙ УНИВЕРСИТЕТ ПУТЕЙ СООБЩЕНИЯ Императора
Александра I»

Кафедра «Информационные и вычислительные системы»

Дисциплина «Программирование на языках высокого уровня (Python)»

#strong[ОТЧЁТ]

#strong[ПО ЛАБОРАТОРНОЙ РАБОТЕ № #strong[9]]

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

Оценочный лист результатов ЛР № 9

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

#strong[\1. Напишите программу (клиентскую и серверную часть),
позволяющую общаться пользователям внутри локальной сети. Используйте
при этом протокол TCP.]

#strong[#strong[\8. ]Напишите клиент-серверное приложение, где на
клиентской стороне вход в основное окно приложения осуществляется только
после его авторизации на сервере, с возможностью регистрации нового
пользователя. На серверной стороне хеш связки «логин:пароль»
пользователей хранится в отдельном файле.]

#strong[]

#strong[Код]

Структура проекта

#box(image("lab-9/assets/Pictures/1000000100000202000001F92D1DF119.png", height: 5.2598in, width: 5.3535in))

#strong[#strong[Общая] часть]

#strong[networking/common.py#strong[ --- функции и константы, общие для
клиентской и серверной сетевых частей]]

#strong[#box(image("lab-9/assets/Pictures/10000001000002A8000003D6C89C71BE.png", height: 8.4409in, width: 5.8465in))#strong[]]

#strong[]

#strong[]

#strong[]

#strong[]

#strong[]

#strong[]

#strong[]

#strong[ \ ]

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

#strong[]

#strong[]

#strong[]

#box(image("lab-9/assets/Pictures/10000001000002F500000102B9789B4C.png", height: 2.2925in, width: 6.7283in))#strong[]

#strong[]

#strong[networking/password\.py --- ]функции для работы с логинами и
паролями

#box(image("lab-9/assets/Pictures/10000001000003120000012C1337B2FB.png", height: 2.5673in, width: 6.7283in))#strong[]

#box(image("lab-9/assets/Pictures/10000001000002E30000030D50B08315.png", height: 7.1102in, width: 6.7283in))#strong[]

#box(image("lab-9/assets/Pictures/10000001000003B4000000E43043820C.png", height: 1.6173in, width: 6.7283in))#strong[data/passwords.json]
--- файл, хранящий хеш-связки логин:пароль

#box(image("lab-9/assets/Pictures/100000010000036600000483A6644B5F.png", height: 8.9327in, width: 6.7283in))#strong[models/message.py
--- ]класс сообщения и нужный для него класс цвета

#strong[#box(image("lab-9/assets/Pictures/10000001000003A9000002A1856314D6.png", height: 4.8327in, width: 6.7283in))]

#strong[models/request.py --- ]классы и перечисление запросов

#strong[#box(image("lab-9/assets/Pictures/100000010000028500000164D595F662.png", height: 3.4791in, width: 6.3043in))]

#strong[]

#strong[]

#strong[]

#strong[]

#strong[]

#strong[]

#strong[]

#strong[]

#strong[]

#strong[#box(image("lab-9/assets/Pictures/10000001000004210000024A22D60A71.png", height: 3.7299in, width: 6.7283in))]

#strong[models/status.py] --- перечисление статусных кодов

#box(image("lab-9/assets/Pictures/1000000100000160000000FA3D160F5D.png", height: 2.6035in, width: 3.6661in))

#strong[]

#strong[]

#strong[]

#strong[]

#strong[]

#strong[]

#strong[]

#strong[]

#strong[Серверная часть]

#strong[server.py] --- отправная точка серверной части

#box(image("lab-9/assets/Pictures/100000010000032500000160F9984CC8.png", height: 2.7165in, width: 6.2134in))

#strong[]

#strong[]

#strong[]

#strong[]

#strong[]

#strong[]

#strong[]

#strong[networking/serverside.py] --- поток работы с клиентами

#box(image("lab-9/assets/Pictures/10000001000003230000030E0A398C9F.png", height: 5.8945in, width: 6.052in))

#strong[]

#strong[]

#strong[]

#strong[]

#strong[]

#strong[]

#strong[]

#box(image("lab-9/assets/Pictures/100000010000037F000004637A57033B.png", height: 8.4417in, width: 6.7283in))#strong[]

#strong[]

#box(image("lab-9/assets/Pictures/10000001000002E800000385CE7B8EAE.png", height: 8.148in, width: 6.7283in))#strong[]

#strong[Клиентская часть]

#strong[client.py] --- отправная точка программы клиента

#box(image("lab-9/assets/Pictures/100000010000021E00000115FBDE3816.png", height: 2.8846in, width: 5.6453in))

#strong[]

#strong[]

#strong[networking/clientside\.py] --- функции клиентской сетевой части

#box(image("lab-9/assets/Pictures/100000010000036A00000241A2F860A1.png", height: 4.4417in, width: 6.7283in))

#box(image("lab-9/assets/Pictures/10000001000002C80000011AA995ADB3.png", height: 2.6646in, width: 6.7283in))

#strong[app/clientwindow\.py] --- окно клиентского приложения

#box(image("lab-9/assets/Pictures/10000001000002EC00000246F8DA785C.png", height: 5.2346in, width: 6.7283in))

#box(image("lab-9/assets/Pictures/10000001000003A2000004B05CF414C6.png", height: 8.6819in, width: 6.7283in))

#box(image("lab-9/assets/Pictures/10000001000003EA0000025CA9B31EAF.png", height: 4.0547in, width: 6.7283in))

#strong[app/messagebox\.py] --- вспомогательные функции для вызова
маленьких окон с сообщением

#box(image("lab-9/assets/Pictures/1000000100000210000001C30D102A85.png", height: 4.1484in, width: 4.8575in))

#box(image("lab-9/assets/Pictures/100000010000037E000004A7A19329FC.png", height: 8.9634in, width: 6.7283in))#strong[app/auth\.py]
--- виджеты авторизации и регистрации

#box(image("lab-9/assets/Pictures/100000010000036D000004E2AE29E833.png", height: 9.4181in, width: 6.6075in))

#box(image("lab-9/assets/Pictures/10000001000002C8000001138B9D733F.png", height: 2.2165in, width: 5.7398in))

#strong[app/chat\.py] --- виджет чата

#box(image("lab-9/assets/Pictures/10000001000003950000039EFDDB396B.png", height: 6.5366in, width: 6.4728in))

#box(image("lab-9/assets/Pictures/10000001000003780000043D1617155C.png", height: 8.2209in, width: 6.7283in))

#box(image("lab-9/assets/Pictures/1000000100000368000001E657571367.png", height: 3.75in, width: 6.7283in))

#strong[Отладка]

#box(image("lab-9/assets/Pictures/100000010000023B00000147F04DE844.png", height: 3.4055in, width: 5.9465in))Логи
сервера, которые выводятся в консоль

Клиентская часть --- окно авторизации

#box(image("lab-9/assets/Pictures/10000001000001CC000001E55604A126.png", height: 4.302in, width: 4.1575in))

#box(image("lab-9/assets/Pictures/10000001000001CC000001DE176411D3.png", height: 4.3591in, width: 4.1953in))

#box(image("lab-9/assets/Pictures/10000001000001CE000001DE67617088.png", height: 4.5398in, width: 4.3866in))

#box(image("lab-9/assets/Pictures/10000001000001D0000001DE5FEF49DA.png", height: 4.6547in, width: 4.5189in))

#box(image("lab-9/assets/Pictures/10000001000001D1000001E57E45D9A1.png", height: 4.6835in, width: 4.4902in))

#box(image("lab-9/assets/Pictures/10000001000001D0000001E0B87F4FE1.png", height: 4.6339in, width: 4.4783in))

#box(image("lab-9/assets/Pictures/10000001000001CE000001E5AD003509.png", height: 4.6319in, width: 4.4134in))

#box(image("lab-9/assets/Pictures/10000001000001D3000001E2988554B7.png", height: 4.5437in, width: 4.4028in))

#box(image("lab-9/assets/Pictures/10000001000002CD000003C488B8940F.png", height: 9.0457in, width: 6.7283in))
