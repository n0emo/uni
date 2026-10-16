ФЕДЕРАЛЬНОЕ АГЕНСТВО ЖЕЛЕЗНОДОРОЖНОГО ТРАНСПОРТА

Федеральное государственное бюджетное образовательное учреждение высшего
образования

«ПЕТЕРБУРГСКИЙ ГОСУДАРСТВЕННЫЙ УНИВЕРСИТЕТ ПУТЕЙ СООБЩЕНИЯ Императора
Александра I»

Кафедра «Информационные и вычислительные системы»

Дисциплина «Программирование на языках высокого уровня (Python)»

#strong[ОТЧЁТ]

#strong[ПО ЛАБОРАТОРНОЙ РАБОТЕ № #strong[3]]

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

Оценочный лист результатов ЛР № 3

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

#box(image("lab-3/assets/Pictures/100000010000023D0000016AADE7ED51B2D417E0.png", height: 3.7709in, width: 5.9689in))

Программа успешно проходит все приведённые ниже тесты.

#box(image("lab-3/assets/Pictures/100000010000027B00000080C918E943770BDE2C.png", height: 1.3335in, width: 6.6146in))

Более подробные результаты:

#box(image("lab-3/assets/Pictures/100000010000027B000001E98DF2F066030047D4.png", height: 5.0937in, width: 6.6146in))

#strong[0. Подготовка]

#box(image("lab-3/assets/Pictures/100000010000025200000126A20EC736163E860F.png", height: 3.0626in, width: 6.1874in))#strong[]

#strong[]

#strong[]

#strong[]

#strong[]

#strong[]

#strong[]

#strong[]

#strong[]

#strong[1. Напишите функцию, вычисляющую максимальное из трех чисел.]

#strong[Решение:]

#box(image("lab-3/assets/Pictures/10000001000000DC0000002072BD5C47DA5DFA48.png", height: 0.3335in, width: 2.2917in))

#strong[Тесты:]

#strong[#box(image("lab-3/assets/Pictures/10000001000001D3000000681016A65736936C59.png", height: 1.0835in, width: 4.8646in))]

#strong[]

#strong[]

#strong[]

#strong[2. Напишите функцию, которая возвращает сумму элементов списка.]

#strong[Решение:]

#box(image("lab-3/assets/Pictures/10000001000000DC0000001C2A73DA2B259A8BEB.png", height: 0.2917in, width: 2.2917in))#strong[Тесты:]

#box(image("lab-3/assets/Pictures/10000001000001D30000006B12A4A755015FD74D.png", height: 1.1146in, width: 4.8646in))#strong[
\ ]

#strong[3. Напишите функцию, которая возвращает произведение элементов
списка.]

#strong[Решение:]

#box(image("lab-3/assets/Pictures/10000001000002A400000053BF032C1BEDB84CA6.png", height: 0.8256in, width: 6.7283in))#strong[]

#strong[Тесты:]

#strong[#box(image("lab-3/assets/Pictures/10000001000001D90000006B623641D622AFCB52.png", height: 1.1146in, width: 4.9272in))]

#strong[4. Напишите функцию, которая возвращает инвертированную строку,
подаваемую ей на вход.]

#strong[Решение:]

#box(image("lab-3/assets/Pictures/100000010000019200000035010937568B42A196.png", height: 0.552in, width: 4.1874in))

#strong[Тесты:]

#strong[#box(image("lab-3/assets/Pictures/10000001000002510000006E072E7ED66106CD58.png", height: 1.1457in, width: 6.1772in))]

#strong[\5. Напишите функцию для вычисления факториала задаваемого
числа.]

#strong[Решение:]

#box(image("lab-3/assets/Pictures/10000001000001CB0000007D72A6C53F9B061EA9.png", height: 1.302in, width: 4.7811in))

#strong[Тесты:]

#strong[]

#strong[#box(image("lab-3/assets/Pictures/10000001000001E000000096C69D8D073D80BB04.png", height: 1.5626in, width: 5in))]

#strong[6. Напишите функцию, которая проверяет, входит ли задаваемое
значение в определенный диапазон или нет.]

#strong[Решение:]

#box(image("lab-3/assets/Pictures/10000001000002CA0000003442317330ECAD3122.png", height: 0.4898in, width: 6.7283in))#strong[]

#strong[Тесты:]

#box(image("lab-3/assets/Pictures/10000001000002C10000009A862883E8F5896F07.png", height: 1.4693in, width: 6.7283in))#strong[]

#strong[]

#strong[7. Напишите функцию, которая подсчитывает количество элементов в
нижнем и верхнем регистрах у входной строки.]

#strong[Решение:]

#box(image("lab-3/assets/Pictures/100000010000030A00000065E9089E1D5DFB8841.png", height: 0.8728in, width: 6.7283in))#strong[]

#strong[Тесты:]

#box(image("lab-3/assets/Pictures/1000000100000359000000663C1A54EF15B18985.png", height: 0.8008in, width: 6.7283in))#strong[]

#strong[\8. Напишите функцию, удаляющую повторяющиеся элементы в
списке.]

#strong[Решение:]

#box(image("lab-3/assets/Pictures/100000010000023600000021FCD5E925C953F63A.png", height: 0.3437in, width: 5.8957in))

#strong[Тесты:]

#box(image("lab-3/assets/Pictures/10000001000002DB0000004E3AEC73411415DF67.png", height: 0.7173in, width: 6.7283in))

#strong[]

#strong[\9. Напишите функцию, выводящую элементы списка с четным
индексом.]

#strong[Решение:]

#box(image("lab-3/assets/Pictures/10000001000001FC0000003535E8DF56DE9399F3.png", height: 0.552in, width: 5.2917in))#strong[]

#strong[Тесты:]

#strong[#box(image("lab-3/assets/Pictures/10000001000002560000006D9B1B83FDF6349BB4.png", height: 1.1354in, width: 6.2291in))]

#strong[10. Напишите функцию, которая проверяет, является ли строка
палиндромом (читается одинаково как слева направо, так и наоборот).]

#strong[Решение:]

#box(image("lab-3/assets/Pictures/10000001000001B9000000392CBEF82BBBC83733.png", height: 0.5937in, width: 4.5937in))#strong[]

#strong[Тесты:]

#box(image("lab-3/assets/Pictures/10000001000002450000009596047C1CBA8251AC.png", height: 1.552in, width: 6.052in))

#strong[]

#strong[11. Напишите декоратор, обертывающий возвращаемое строковое
значение функции в тег «\<b\> \</b\>».]

#strong[Решение:]

#box(image("lab-3/assets/Pictures/10000001000002380000003BF751918C1A6DBD9F.png", height: 0.6146in, width: 5.9165in))

#strong[Тесты:]

#strong[#box(image("lab-3/assets/Pictures/1000000100000274000000B1250C2497765631A6.png", height: 1.8437in, width: 6.5417in))]

#strong[12. Декорируйте функцию из первого упражнения таким образом,
чтобы возвращаемое ей значение возводилось в квадрат.]

#strong[Решение:]

#box(image("lab-3/assets/Pictures/1000000100000210000000387F597EB610508A86.png", height: 0.5835in, width: 5.5in))

#strong[Тесты:]

#strong[#box(image("lab-3/assets/Pictures/100000010000023E0000007BFCC945DFC60366D2.png", height: 1.2811in, width: 5.9791in))]

#strong[13. Декорируйте функцию из четвертого упражнения таким образом,
чтобы возвращалась строка в верхнем регистре.]

#strong[Решение:]

#box(image("lab-3/assets/Pictures/10000001000001E400000037526206B16D254965.png", height: 0.5728in, width: 5.0417in))

#strong[Тесты:]

#strong[#box(image("lab-3/assets/Pictures/100000010000024D00000081622DAA53BAAAA57E.png", height: 1.3437in, width: 6.1354in))]

#strong[14. Напишите декоратор, выводящий значения аргументов,
подаваемых на вход декорируемой функции.]

#strong[Решение:]

#box(image("lab-3/assets/Pictures/100000010000021A000000ADEDE6646D98CDF275.png", height: 1.802in, width: 5.6043in))

#strong[Тесты:]

#strong[#box(image("lab-3/assets/Pictures/10000001000003000000017141618DA6A568A0D5.png", height: 3.2327in, width: 6.7283in))]

#strong[]

#strong[]

#strong[15. Напишите генераторную функцию, позволяющую проводить
итерацию по значениям в диапазоне от 23 до 37.]

#strong[Решение:]

#box(image("lab-3/assets/Pictures/100000010000022C0000004B913DCCFC74B965EB.png", height: 0.7811in, width: 5.7917in))

#strong[Тесты:]

#strong[#box(image("lab-3/assets/Pictures/100000010000035A000000974178BDAA4FF533C8.png", height: 1.1839in, width: 6.7283in))]

#strong[16. Напишите генераторную функцию, позволяющую проводить
итерацию по значениям в диапазоне от 5 до 37 с шагом 4.]

#strong[Решение:]

#box(image("lab-3/assets/Pictures/10000001000002E00000004FAA416FF7849D8DD1.png", height: 0.7217in, width: 6.7283in))#strong[]

#strong[Тесты:]

#strong[#box(image("lab-3/assets/Pictures/100000010000023A0000009A7179DF122B3A927B.png", height: 1.6043in, width: 5.9374in))]

#strong[18. Напишите генераторное выражение, позволяющее итерироваться
элементам списка \[3 0 1 3 0 4 3 3 4 56 6 1 3\] возводя их при этом в
квадрат.]

#strong[Решение:]

#strong[#box(image("lab-3/assets/Pictures/10000001000001B50000004F4B978CC6F6E68D56.png", height: 0.8228in, width: 4.552in))]

#strong[Тесты:]

#strong[#box(image("lab-3/assets/Pictures/10000001000002B6000000AF373099C69B78BC0D.png", height: 1.6965in, width: 6.7283in))]

#strong[19. Напишите генераторную функцию, позволяющую проводить
итерацию по значениям в диапазоне от 0 до 100 с шагом, регулируемым в
процессе ее работы.]

#strong[Решение:]

#box(image("lab-3/assets/Pictures/10000001000003340000019DCC7E34140937A71D.png", height: 3.3882in, width: 6.7283in))

#strong[Тесты:]

#strong[#box(image("lab-3/assets/Pictures/1000000100000291000000E06C22C32CF6151A30.png", height: 2.0866in, width: 6.1201in))]

#strong[]
