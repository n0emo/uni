ФЕДЕРАЛЬНОЕ АГЕНСТВО ЖЕЛЕЗНОДОРОЖНОГО ТРАНСПОРТА

Федеральное государственное бюджетное образовательное учреждение высшего
образования

«ПЕТЕРБУРГСКИЙ ГОСУДАРСТВЕННЫЙ УНИВЕРСИТЕТ ПУТЕЙ СООБЩЕНИЯ Императора
Александра I»

Кафедра «Информационные и вычислительные системы»

Дисциплина «Программирование на языках высокого уровня (Python)»

#strong[ОТЧЁТ]

#strong[ПО ЛАБОРАТОРНОЙ РАБОТЕ № #strong[5]]

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

Оценочный лист результатов ЛР № 5

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

#strong[Тестирование]

Для тестов используется модуль встроенной библиотеки unittest. Формат
тестов везде одинаковы: сначала вызов функции или процедуры, потом
сверка её результата с ожидаемым с помощью assert. Если assert имеет два
параметра, тестируемое значение всегда слева, ожидаемое всегда справа.
Вот пример одного из тестов:

#box(image("lab-5/assets/Pictures/100000010000023D0000016AADE7ED51B2D417E0.png", height: 3.7709in, width: 5.9689in))

Программа успешно проходит все приведённые ниже тесты.

#box(image("lab-5/assets/Pictures/10000001000002C50000008813095ACC8F8A2F67.png", height: 1.2902in, width: 6.7283in))

Более подробные результаты:

#box(image("lab-5/assets/Pictures/10000001000002DA0000028B083A38B3F3A7FA78.png", height: 6in, width: 6.7283in))

#strong[\1. Напишите класс, позволяющий сформировать все уникальные
подмножества из списка целых чисел, например: \[2, 4, 10, 1\].]

#strong[Решение:]

#box(image("lab-5/assets/Pictures/100000010000026B0000017CBA547346E21FEDD8.png", height: 3.9583in, width: 6.448in))#strong[]

#strong[Тесты:]

#box(image("lab-5/assets/Pictures/10000001000001D900000151FF1A2848F2F71257.png", height: 3.5102in, width: 4.9272in))#strong[]

#strong[2. Напишите класс, реализующий все арифметические операции над
двумя значениями (a и b).]

#strong[Решение:]

#box(image("lab-5/assets/Pictures/1000000100000249000001A9F0C8AD3351AEFC2A.png", height: 4.4272in, width: 6.0937in))

#strong[Тесты:]

#strong[#box(image("lab-5/assets/Pictures/10000001000001DD000000B7F7E6EA660FEE6639.png", height: 1.9063in, width: 4.9689in))]

#strong[3. Напишите класс, описывающий такой объект, как автомобиль.
Продумайте, какие методы и переменные он должен иметь.]

#strong[Решение:]

#strong[]

#box(image("lab-5/assets/Pictures/10000001000001B3000001E97E35D2A5D4514277.png", height: 5.0937in, width: 4.5311in))#strong[Тесты:]

#strong[#box(image("lab-5/assets/Pictures/1000000100000242000000E1DAEC88081B513CF3.png", height: 2.3437in, width: 6.0209in))]

#strong[4. Напишите класс, описывающий такой объект, как прямоугольник.
Перегрузите у реализованного класса методы сравнения (сравнивать по
площади), после чего создайте два экземпляра класса и проверьте, как
работают перегруженные методы.]

#strong[Решение:]

#box(image("lab-5/assets/Pictures/100000010000024E000002740DCA64391C1656DE.png", height: 6.5417in, width: 6.1457in))

#strong[]

#strong[Тесты:]

#strong[#box(image("lab-5/assets/Pictures/10000001000001E6000001812C318FF43483A7DC.png", height: 4.0102in, width: 5.0626in))]

#strong[\5. Напишите класс, описывающий такой объект, как автомобиль. У
него может быть различное количество состояний, реализуемых посредством
перечислений. Добавьте методы, позволяющие экземпляру класса менять свое
текущее состояние (например: остановка, движение, поворот налево и т.
д.)]

#strong[Решение:]

#box(image("lab-5/assets/Pictures/10000001000001D40000012105B365C90EBE40E5.png", height: 3.0102in, width: 4.8752in))#box(image("lab-5/assets/Pictures/100000010000036A000002AC27ABE9FA3434750F.png", height: 5.2654in, width: 6.7283in))

#strong[Тесты:]

#strong[#box(image("lab-5/assets/Pictures/10000001000002E000000113F9E8AACC7A66AE27.png", height: 2.5138in, width: 6.7283in))]

#strong[]

#strong[]

#strong[]

#strong[]

#box(image("lab-5/assets/Pictures/10000001000002E0000001927022EB0D3638E99B.png", height: 3.6752in, width: 6.7283in))#strong[]

#strong[6. Напишите класс, который подсчитывает текущее количество его
экземпляров в приложении. Для корректного отображения этого числа
перегрузите у класса метод \_\_del\_\_ и напишите необходимую логику.]

#strong[Решение:]

#box(image("lab-5/assets/Pictures/100000010000015D0000010E1C44B6DAE6484CED.png", height: 2.8126in, width: 3.6354in))

#strong[]

#strong[Тесты:]

#box(image("lab-5/assets/Pictures/10000001000002870000016CF6EEAC1798F4CEDF.png", height: 3.7846in, width: 6.7283in))#strong[]

#strong[]

#strong[7. Напишите базовый класс, задающий интерфейс и часть
характеристик (если надо) таких объектов, как геометрические фигуры,
автомобиль и магазин, животное.]

#strong[Решение:]

#box(image("lab-5/assets/Pictures/100000010000018A000000BA71F97FEAFD52489C.png", height: 1.9374in, width: 4.1043in))#strong[]

#strong[]

#box(image("lab-5/assets/Pictures/100000010000018A0000011C86632098807E57F8.png", height: 2.9583in, width: 4.1043in))#strong[]

#strong[]

#box(image("lab-5/assets/Pictures/100000010000018A000000D830EDDF38193FD504.png", height: 2.25in, width: 4.1043in))#strong[]

#box(image("lab-5/assets/Pictures/100000010000035E0000010E47EC234F97335BE1.png", height: 2.1071in, width: 6.7283in))#strong[]

#strong[#box(image("lab-5/assets/Pictures/100000010000022F000000B24645440EEA49ABCC.png", height: 1.8543in, width: 5.8228in))]

#strong[\8. Напишите несколько производных классов от базового класса
геометрических фигур (например: прямоугольник и квадрат).]

#strong[Решение:]

#box(image("lab-5/assets/Pictures/1000000100000233000001677760C18FBD9F3E95.png", height: 2.9189in, width: 4.5772in))

#strong[#box(image("lab-5/assets/Pictures/10000001000001E20000013E67662163CDC9DA20.png", height: 2.9252in, width: 4.4339in))]

#strong[#box(image("lab-5/assets/Pictures/100000010000024B0000013798A7D51FAD20D3E9.png", height: 3.2398in, width: 6.1146in))Тесты:]

#box(image("lab-5/assets/Pictures/10000001000002E8000001E80324BF86052F2E30.png", height: 4.4134in, width: 6.7283in))

#strong[]

#strong[9. Напишите несколько производных классов от базового класса
автомобилей (например: легковой и грузовой автомобиль).]

#strong[Решение:]

#strong[#box(image("lab-5/assets/Pictures/100000010000025D0000029C7D317A225CD28025.png", height: 6.9583in, width: 6.302in))]

#box(image("lab-5/assets/Pictures/10000001000002B70000035D01809BFF5B0DABE9.png", height: 8.3354in, width: 6.7283in))

#strong[]

#strong[]

#strong[]

#strong[Тесты:]

#strong[#box(image("lab-5/assets/Pictures/10000001000002B700000268DF48C0DE4ECBE197.png", height: 5.7744in, width: 6.5154in))]

#strong[#box(image("lab-5/assets/Pictures/10000001000002B700000123B0B3642BB8182A88.png", height: 2.711in, width: 6.4764in))]

#strong[10. Напишите несколько производных классов от базового класса
магазинов (например: ларек и супермаркет).]

#strong[Решение:]

#strong[]

#box(image("lab-5/assets/Pictures/10000001000003960000034A2D90A432E2CC2124.png", height: 6.1709in, width: 6.7283in))#strong[]

#strong[]

#box(image("lab-5/assets/Pictures/10000001000003AF0000036122BD45812E6B5516.png", height: 6.1717in, width: 6.7283in))#strong[Тесты:]

#box(image("lab-5/assets/Pictures/100000010000039D00000131F14ED91DA4020496.png", height: 2.2181in, width: 6.7283in))

#strong[]

#strong[11. Напишите несколько производных классов от базового класса
автомобилей (например: лошадь и тигр).]

#strong[Решение:]

#box(image("lab-5/assets/Pictures/10000001000002DA000002F582479E3CF8FF5062.png", height: 6.9772in, width: 6.7283in))

#strong[]

#strong[Тесты:]

#strong[#box(image("lab-5/assets/Pictures/100000010000037E00000288D68BBEFBBEA289AA.png", height: 4.8764in, width: 6.7283in))]

#strong[12. Напишите класс, доступ к атрибутам (переменным) которого
осуществляется с помощью декоратора \@property.]

#strong[#box(image("lab-5/assets/Pictures/10000001000002130000009CBB09A9D134DF740B.png", height: 1.6252in, width: 5.5311in))Решение:]

#strong[#box(image("lab-5/assets/Pictures/1000000100000213000001D20E06716DA07718B1.png", height: 4.8543in, width: 5.5311in))]

#strong[Тесты:]

#strong[#box(image("lab-5/assets/Pictures/100000010000029300000089D16FFE4CF6031403.png", height: 1.3984in, width: 6.7283in))]

#strong[13. Напишите класс, хранящий целое число. Перегрузите у него
методы арифметических операций. Объявите два экземпляра класса и
проверьте, как работают перегруженные методы.]

#strong[Решение:]

#box(image("lab-5/assets/Pictures/100000010000022D000001D544AB52685D4D3F8C.png", height: 4.8854in, width: 5.802in))

#strong[Тесты:]

#strong[#box(image("lab-5/assets/Pictures/10000001000001FF000000CCBC10A48D10D6687C.png", height: 2.1252in, width: 5.3228in))]

#strong[14. Напишите класс, который позволяет работать с json-файлом,
осуществляя его чтение, запись, добавление, удаление и изменение
значений.]

#strong[]

#strong[]

#strong[Решение:]

#box(image("lab-5/assets/Pictures/100000010000020000000127EF1A659BD958A605.png", height: 3.0728in, width: 5.3335in))

#strong[Тесты:]

#strong[#box(image("lab-5/assets/Pictures/1000000100000235000000DF8A314195EF4BB2F4.png", height: 2.3228in, width: 5.8854in))]

#strong[]

#strong[15. Напишите класс, который находит прямоугольник с максимальной
площадью из списка.]

#strong[Решение:]

#box(image("lab-5/assets/Pictures/1000000100000279000000F8A0EF62EEA270FEDA.png", height: 2.3217in, width: 5.9252in))

#strong[Тесты:]

#strong[#box(image("lab-5/assets/Pictures/1000000100000273000001133E8F5A452B5934C2.png", height: 2.8646in, width: 6.5311in))]

#strong[16. Напишите класс, осуществляющий преобразование целого числа
из десятичной системы счисления в двоичную и наоборот.]

#strong[Решение:]

#box(image("lab-5/assets/Pictures/100000010000028B0000031CE992EF0F0C236D6A.png", height: 8.2272in, width: 6.7283in))

#strong[]

#strong[]

#strong[Тесты:]

#strong[#box(image("lab-5/assets/Pictures/100000010000029D000000CB9651612ADF00F695.png", height: 2.0417in, width: 6.7283in))]

#strong[17. Напишите класс, вычисляющий наименьший общий делитель (НОД).
Значения, участвующие в поиске НОД должны устанавливаться отдельными
методами или посредством декоратора \@property до вызова метода
расчета.]

#strong[Решение:]

#box(image("lab-5/assets/Pictures/10000001000002E30000028BCBDEBAAADEED2CD0.png", height: 5.1008in, width: 5.7902in))

#strong[Тесты:]

#strong[#box(image("lab-5/assets/Pictures/10000001000001F7000000858BE72082ED31D6A6.png", height: 1.3854in, width: 5.2398in))]

#strong[\18. Напишите класс, вычисляющий корни квадратного уравнения.]

#strong[Решение:]

#box(image("lab-5/assets/Pictures/1000000100000314000001F10518D19C631BF842.png", height: 4.2429in, width: 6.7283in))

#strong[Тесты:]

#box(image("lab-5/assets/Pictures/10000001000002830000006105547CCE2083F414.png", height: 1.0102in, width: 6.698in))#strong[]

#strong[]

#strong[19. Напишите класс, хранящий данные сотрудника фирмы и имеющий
метод, возвращающий характеристики текущего сотрудника в виде словаря.]

#strong[Решение:]

#box(image("lab-5/assets/Pictures/100000010000031D00000370B7795FFF0AA17ACE.png", height: 7.4291in, width: 6.7283in))

#strong[]

#strong[Тесты:]

#strong[#box(image("lab-5/assets/Pictures/10000001000002EC000000A0FE5FFB33143D1A7C.png", height: 1.439in, width: 6.7283in))]

#strong[20. Напишите класс, представляющий собой записную книжку. Каждый
элементnзаписной книжки должен содержать следующие поля: ФИО, номер
телефона, e-mail, день рождения. Записная книжка может сохраняться на
диск в виде json- файла, а также должна иметь метод загрузки данных из
файла.]

#strong[Решение:]

#box(image("lab-5/assets/Pictures/1000000100000375000002639029BD3F0EA1A47F.png", height: 4.6453in, width: 6.7283in))

#strong[]

#strong[]

#strong[]

#strong[#box(image("lab-5/assets/Pictures/100000010000037500000154E7F91B25A102ABC4.png", height: 2.5846in, width: 6.7283in))]

#strong[]

#strong[#box(image("lab-5/assets/Pictures/10000001000001FA000000BCE1A2DC6FF5C22202.png", height: 1.9583in, width: 5.2709in))]

#box(image("lab-5/assets/Pictures/1000000100000335000001D548F9662B5AA457B1.png", height: 3.8429in, width: 6.7283in))#strong[]
