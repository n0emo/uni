ФЕДЕРАЛЬНОЕ АГЕНСТВО ЖЕЛЕЗНОДОРОЖНОГО ТРАНСПОРТА

Федеральное государственное бюджетное образовательное учреждение высшего
образования

«ПЕТЕРБУРГСКИЙ ГОСУДАРСТВЕННЫЙ УНИВЕРСИТЕТ ПУТЕЙ СООБЩЕНИЯ Императора
Александра I»

Кафедра «Информационные и вычислительные системы»

Дисциплина «Программирование на языках высокого уровня (Python)»

#strong[ОТЧЁТ]

#strong[ПО ЛАБОРАТОРНОЙ РАБОТЕ № #strong[2] ]

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

Оценочный лист результатов ЛР № 2

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

#box(image("lab-2/assets/Pictures/100000010000023D0000016AADE7ED51B2D417E0.png", height: 3.7709in, width: 5.9689in))

Программа успешно проходит все приведённые ниже тесты.

#box(image("lab-2/assets/Pictures/10000001000002C800000099BB948B51BBE45439.png", height: 1.4457in, width: 6.7283in))

Более подробные результаты:

#box(image("lab-2/assets/Pictures/10000001000002CF000002C6DBF2635401040136.png", height: 6.6437in, width: 6.7283in))

#strong[\1. Выведите все символы из строки «Данная часть была посвящена
больше синтаксисуpython и вопросам документации кода», значения индексов
которых делятся на 2.]

#strong[Решение:]

#strong[#box(image("lab-2/assets/Pictures/1000000100000146000000381857343A68D2AD3A.png", height: 0.5835in, width: 3.3957in))]

#strong[]

#strong[]

#strong[Тесты:]

#box(image("lab-2/assets/Pictures/10000001000003F10000006331A6DDD72BCA5A73.png", height: 0.6598in, width: 6.7283in))#strong[]

#strong[2. Выведите все символы из строки «Данная часть была посвящена
больше синтаксису Python и вопросам документации кода», значения
индексов которых без остатка]

#strong[Решение:]

#box(image("lab-2/assets/Pictures/100000010000035700000062E3EC87D4ADE1B5F4.png", height: 0.7709in, width: 6.7283in))

#strong[Тесты:]

#strong[#box(image("lab-2/assets/Pictures/10000001000003F700000060C2D9789E43D58D5B.png", height: 0.6362in, width: 6.7283in))]

#strong[3. Выведите все символы из строки «Данная часть была посвящена
больше синтаксису Python и вопросам документации кода», значения
индексов которых при делении на 6 дают остаток 2, 4, и 5.]

#strong[Решение:]

#box(image("lab-2/assets/Pictures/100000010000030E00000062835FDF341AA54D65.png", height: 0.8429in, width: 6.7283in))

#strong[]

#strong[Тесты:]

#strong[#box(image("lab-2/assets/Pictures/10000001000003F10000005FBB0C5941F638DBEB.png", height: 0.6335in, width: 6.7283in))]

#strong[4. Выведите числа из диапазона от 1 до 10, используя цикл for и
while.]

#strong[Решение:]

#box(image("lab-2/assets/Pictures/10000001000001B30000011466C7B272A60D0547.png", height: 2.8752in, width: 4.5311in))

#strong[Тесты:]

#strong[#box(image("lab-2/assets/Pictures/1000000100000300000000CC52C587A84EA37E30.png", height: 1.7866in, width: 6.7283in))]

#strong[\5. Выведите числа из диапазона от --20 до 20 с шагом 3,
используя цикл for и while.]

#strong[]

#strong[Решение:]

#box(image("lab-2/assets/Pictures/10000001000002880000011003223C672CA7E2F5.png", height: 2.8236in, width: 6.7283in))

#strong[Тесты:]

#strong[#box(image("lab-2/assets/Pictures/100000010000035900000123A32977CC72784A1B.png", height: 2.2839in, width: 6.7283in))]

#strong[6. Посчитайте количество вхождений элемента со значением «3» в
следующем списке: \[3 0 1 3 0 4 3 3 4 56 6 1 3\], используя цикл for,
while и метод count.]

#strong[Решение:]

#box(image("lab-2/assets/Pictures/10000001000001F20000007661C043E50282F734.png", height: 1.2291in, width: 5.1874in))

#strong[]

#box(image("lab-2/assets/Pictures/100000010000021100000129AD4ADF662964B696.png", height: 3.0937in, width: 5.5102in))#strong[]

#strong[]

#strong[]

#strong[]

#strong[]

#strong[ \ \ ]

#strong[]

#strong[]

#strong[]

#strong[]

#strong[]

#strong[Тесты:]

#box(image("lab-2/assets/Pictures/100000010000026B0000013B71643E64B038188E.png", height: 3.2811in, width: 6.448in))#strong[]

#strong[]

#strong[7. Сформируйте список из элементов строки «список доступных
атрибутов», используя механизм списковых включений и цикл for.]

#strong[Решение:]

#box(image("lab-2/assets/Pictures/10000001000001800000003693DB1B6E7BC9ED65.png", height: 0.5626in, width: 4in))

#strong[]

#strong[]

#strong[]

#box(image("lab-2/assets/Pictures/100000010000018000000077CCF1CF7528571BC3.png", height: 1.2398in, width: 4in))#strong[]

#strong[]

#strong[]

#strong[]

#strong[]

#strong[]

#strong[Тесты:]

#box(image("lab-2/assets/Pictures/10000001000001E4000002F479F2E38414604E30.png", height: 7.8752in, width: 5.0417in))#strong[]

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

#strong[#box(image("lab-2/assets/Pictures/10000001000001E4000002F414E8C780D66D8100.png", height: 7.8752in, width: 5.0417in))]

#strong[]

#strong[]

#strong[]

#strong[]

#strong[2. ]

#strong[\8. Сформируйте единичную матрицу N × N, используя механизм
списковых включений.]

#strong[Решение:]

#box(image("lab-2/assets/Pictures/100000010000033B00000036ECE6095AD61FD69F.png", height: 0.439in, width: 6.7283in))

#strong[Тесты:]

#box(image("lab-2/assets/Pictures/10000001000002DB0000004E3AEC73411415DF67.png", height: 0.7173in, width: 6.7283in))

#strong[]

#strong[9. Напишите программу, выводящую элементы списка \[3 0 1 3 0 4 3
3 4 56 6 1 3\] в обратной последовательности.]

#strong[Решение:]

#box(image("lab-2/assets/Pictures/100000010000016A000000360328F8BB0AAB1E0C.png", height: 0.5626in, width: 3.7709in))

#strong[]

#strong[]

#strong[Тесты:]

#strong[#box(image("lab-2/assets/Pictures/100000010000032B00000064D2EE2EB96CB479E0.png", height: 0.8291in, width: 6.7283in))]

#strong[10. Напишите программу, которая выводит числе в диапазоне от 1
до 9, кроме 5 и 7.]

#strong[Решение:]

#box(image("lab-2/assets/Pictures/10000001000002DF00000060F8F3A8F297850AFA.png", height: 0.8783in, width: 6.7283in))#strong[Тесты:]

#box(image("lab-2/assets/Pictures/10000001000002E400000062B91D958C8F3EC25D.png", height: 0.8909in, width: 6.7283in))

#strong[]

#strong[11. Напишите программу, выводящую сумму элементов списка \[3 0 1
3 0 4 3 3 4 56 6 1 3\], используя цикл for, while и метод sum.]

#strong[Решение:]

#box(image("lab-2/assets/Pictures/10000001000002130000017FB9EB1E9E296DFD82.png", height: 3.9898in, width: 5.5311in))

#strong[Тесты:]

#strong[#box(image("lab-2/assets/Pictures/100000010000026D000001391FB44DF4B2143903.png", height: 3.2602in, width: 6.4689in))]

#strong[]

#strong[12. Напишите программу, выводящую сумму элементов списка \[3 0 1
3 0 4 3 3 4 56 6 1 3\], значения индексов которых делятся на без остатка
на 3, используя цикл for и while.]

#strong[Решение:]

#box(image("lab-2/assets/Pictures/10000001000002AE000000CFF87C2CCC57F84429.png", height: 2.0299in, width: 6.7283in))

#strong[Тесты:]

#strong[#box(image("lab-2/assets/Pictures/10000001000002680000005F69D1E33282A5DE8D.png", height: 0.9898in, width: 6.4165in))]

#strong[13. Сформируйте список, значения элементов которого находятся в
диапазоне от 23 до 35.]

#strong[Решение:]

#box(image("lab-2/assets/Pictures/10000001000002240000003A1FE875E1B002F761.png", height: 0.6043in, width: 5.7083in))

#strong[Тесты:]

#strong[#box(image("lab-2/assets/Pictures/100000010000038C0000004E6621B419D3CEE137.png", height: 0.578in, width: 6.7283in))]

#strong[14. Сформируйте список, значения элементов которого находятся в
диапазонеот 3 до 15 с шагом 4.]

#strong[]

#strong[]

#strong[Решение:]

#box(image("lab-2/assets/Pictures/100000010000028100000035FCDAD60B679356A9.png", height: 0.552in, width: 6.6772in))

#strong[Тесты:]

#strong[#box(image("lab-2/assets/Pictures/10000001000001FF0000004E42F895E0F4A22C21.png", height: 0.8126in, width: 5.3228in))]

#strong[]

#strong[]

#strong[]

#strong[15. Сформируйте список, значения элементов которого находятся в
диапазонеот 3 до 25 и без остатка делятся на 3.]

#strong[Решение:]

#box(image("lab-2/assets/Pictures/100000010000036D00000036766E73048E49314B.png", height: 0.4138in, width: 6.7283in))

#strong[Тесты:]

#strong[#box(image("lab-2/assets/Pictures/100000010000029E00000091D4939293CDF8C9F4.png", height: 1.4555in, width: 6.7283in))]

#strong[16. Сформируйте словарь из двух списков \[3 0 1 3 0 4 3 3 4 56 6
1 3\] и \[2, 4, 7, 26, 33\], используя встроенную функцию zip. Выведите
словарь в консоль и объясните, почему он получился такого вида.]

#strong[Решение:]

#box(image("lab-2/assets/Pictures/100000010000014C0000001E23D73AFC911A804D.png", height: 0.3126in, width: 3.4583in))

#strong[]

#strong[Тесты:]

#strong[#box(image("lab-2/assets/Pictures/100000010000026200000075FAA4340DF07B4039.png", height: 1.1472in, width: 5.9811in))]

#strong[17. Выведите различными способами в консоль элементы списка \[3
0 1 3 0 4 3 3 4 56 6 1 3\] с их индексами.]

#strong[Решение:]

#box(image("lab-2/assets/Pictures/100000010000026C00000088BD7A201AB9592DB9.png", height: 1.4165in, width: 6.4583in))

#strong[Тесты:]

#strong[#box(image("lab-2/assets/Pictures/1000000100000413000000B829992014D7EE0F59.png", height: 1.1866in, width: 6.7283in))]

#strong[18. Напишите программу, которая считывает целое число (месяц),
после чего выводит сезон к которому этот месяц относится.]

#strong[Решение:]

#box(image("lab-2/assets/Pictures/100000010000017E00000111C45899BE56CFAAA2.png", height: 2.7264in, width: 3.8146in))

#strong[Тесты:]

#box(image("lab-2/assets/Pictures/100000010000023F00000078E5AD93D0E80BF93C.png", height: 1.25in, width: 5.9898in))#strong[]

#strong[]

#strong[19. Напишите программу, выводящую среднее из трех значений.]

#strong[Решение:]

#box(image("lab-2/assets/Pictures/10000001000002FB0000016875FFCCC18DC8A7A4.png", height: 3.1744in, width: 6.7283in))

#strong[Тесты:]

#strong[#box(image("lab-2/assets/Pictures/10000001000001A8000000664391C0CD342982A0.png", height: 1.0626in, width: 4.4165in))]

#strong[2. Напишите программу, выводящую таблицу умножения для
задаваемого пользователем числа от 1 до 9 (включительно).]

#strong[Решение:]

#box(image("lab-2/assets/Pictures/10000001000002E3000000504F97B439AD671B91.png", height: 0.728in, width: 6.7283in))

#strong[Тесты:]

#box(image("lab-2/assets/Pictures/10000001000002EF000000BB286BD706B16C0244.png", height: 1.5457in, width: 6.2098in))#strong[]
