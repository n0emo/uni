ФЕДЕРАЛЬНОЕ АГЕНСТВО ЖЕЛЕЗНОДОРОЖНОГО ТРАНСПОРТА

Федеральное государственное бюджетное образовательное учреждение высшего
образования

«ПЕТЕРБУРГСКИЙ ГОСУДАРСТВЕННЫЙ УНИВЕРСИТЕТ ПУТЕЙ СООБЩЕНИЯ Императора
Александра I»

Кафедра «Информационные и вычислительные системы»

Дисциплина «Программирование на языках высокого уровня (Python)»

#strong[ОТЧЁТ]

#strong[ПО ЛАБОРАТОРНОЙ РАБОТЕ № 1 ]

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

Оценочный лист результатов ЛР № 1

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

#strong[#strong[Тестирование]]

Для тестов используется модуль встроенной библиотеки unittest. Формат
тестов везде одинаковы: сначала вызов функции или процедуры, потом
сверка её результата с ожидаемым с помощью assert. Если assert имеет два
параметра, тестируемое значение всегда слева, ожидаемое всегда справа.
Вот пример одного из тестов:

#box(image("lab-1/assets/Pictures/100000010000023D0000016AADE7ED51B2D417E0.png", height: 3.7709in, width: 5.9689in))

Программа успешно проходит все приведённые ниже тесты.

#box(image("lab-1/assets/Pictures/100000010000030D0000006926CE1EF77F72118D.png", height: 0.9043in, width: 6.7283in))

Более подробные результаты:

#box(image("lab-1/assets/Pictures/10000001000003AC000003C5AA9C1FA6516FE1A9.png", height: 6.9071in, width: 6.7283in))

#strong[#strong[\1. Что будет результатом следующих выражений?]]

\"agility\"\[2:5\] + \"taxonomy\"\[3:6\]

\[115,202,192,334,257\]\[:4\]

len(\"crazy\"\[3:3+4\])

\[9,8,7,6,5,4,3,2,1<anchor>\]\[-3:\]

type(\[False,True,False,True\]\[2:3\])

\"-\-\-\".join( \"this is important\".split() )

int( \'\'.join( \"7/7/07\".split(\'/\') ) )

\"too soon to tell\".replace(\'o\',\'\*\').replace(\'\* \',\'\')

#strong[Решение:]

#box(image("lab-1/assets/Pictures/10000001000001880000013BB4F103008BCE0F62.png", height: 3.2811in, width: 4.0835in))#strong[]

#strong[#strong[\2. Напишите скрипт, вычисляющий двумя способами длину
строки.]]

#strong[#strong[Решение:]]

#strong[#box(image("lab-1/assets/Pictures/10000001000001870000009EE7648381FB907708.png", height: 1.6457in, width: 4.0728in))#strong[]]

#strong[]

#strong[]

#strong[]

#strong[]

#strong[Тесты:]

#strong[#box(image("lab-1/assets/Pictures/10000001000003E3000001F9B68664C11FA0C782.png", height: 3.4146in, width: 6.7283in))]

#strong[]

#strong[#strong[\3. Напишите скрипт, который позволяет из строки собрать
другую по следующим правилам: новая строка должна состоять из двух
первых и двух последних элементов исходной строки. Если длина исходной
строки меньше двух, то результатом будет пустая строка.]]

#strong[#strong[Решение:]]

#strong[#box(image("lab-1/assets/Pictures/10000001000001710000006CBBA01C3910B8E066.png", height: 1.1252in, width: 3.8437in))]

#strong[]

#strong[]

#strong[]

#strong[Тесты:]

#strong[#box(image("lab-1/assets/Pictures/1000000100000255000001509669ABAE66551336.png", height: 3.5in, width: 6.2189in))]

#strong[]

#strong[]

#strong[]

#strong[#strong[\4. Напишите скрипт, который заменяет произвольный
символ/букву в строке на «\$».]]

#strong[#strong[Решение:]]

#strong[#box(image("lab-1/assets/Pictures/10000001000002660000006B214463D53FC5265C.png", height: 1.1146in, width: 6.3957in))#strong[]]

#strong[#strong[Тесты:]]

#strong[#box(image("lab-1/assets/Pictures/10000001000002A700000150ECB23F4A5A59D4D0.png", height: 3.3291in, width: 6.7283in))#strong[]]

#strong[#strong[]]

#strong[#strong[\5. Напишите скрипт, который позволяет инвертировать
последовательность элементов в строке.]]

#strong[#strong[Решение:]]

#strong[#box(image("lab-1/assets/Pictures/1000000100000195000000396B0E191CECEC130F.png", height: 0.5937in, width: 4.2189in))#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[Тесты:]]

#strong[#box(image("lab-1/assets/Pictures/10000001000001D4000000BA456F33FDBAC66FB9.png", height: 1.9374in, width: 4.8752in))#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[\6. Напишите скрипт, который считает количество
вхождений символа в строку. Например: «google.com» --- {\'o\': 3, \'g\':
2, \'.\': 1, \'e\': 1, \'l\': 1, \'m\': 1, \'c\': 1}]]

#strong[#strong[Решение:]]

#strong[#box(image("lab-1/assets/Pictures/100000010000036A000000EAAF546A30004AB5CE.png", height: 1.8016in, width: 6.7283in))#strong[]]

#strong[#strong[Тесты:]]

#strong[#box(image("lab-1/assets/Pictures/1000000100000398000000E7EFA2AA727299ED85.png", height: 1.689in, width: 6.7283in))#strong[]]

#strong[#strong[\7. Напишите скрипт, позволяющий из исходной строки
собрать две новые. Первая строка должна состоять только из элементов с
нечетными индексами исходной строки, а вторая --- с четными.]]

#strong[#strong[Решение:]]

#strong[#box(image("lab-1/assets/Pictures/10000001000002200000003CDEAE13F54497C6D0.png", height: 0.6252in, width: 5.6665in))#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[Тесты:]]

#strong[#box(image("lab-1/assets/Pictures/1000000100000277000000BB4E56D2B992D74C0D.png", height: 1.948in, width: 6.5728in))#strong[]]

#strong[#strong[]]

#strong[#strong[\8. Напишите скрипт, который удаляет задаваемый
произвольный символ в строке.]]

#strong[#strong[Решение:]]

#strong[#box(image("lab-1/assets/Pictures/10000001000002150000006EA7BE90E32A2F72CF.png", height: 1.1457in, width: 5.552in))#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[Тесты:]]

#strong[#box(image("lab-1/assets/Pictures/10000001000002090000006E6A88635AB6239F7B.png", height: 1.1457in, width: 5.4272in))#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[\9. Напишите скрипт, который позволяет переводить все
символы исходной строки в верхний и нижний регистры.]]

#strong[#strong[Решение:]]

#strong[#box(image("lab-1/assets/Pictures/10000001000002670000003AC9B514D8A4A7461B.png", height: 0.6043in, width: 6.4063in))#strong[]]

#strong[#strong[Тесты:]]

#strong[#box(image("lab-1/assets/Pictures/10000001000003DF000000A276116426C4C6538F.png", height: 1.0992in, width: 6.7283in))#strong[]]

#strong[#strong[]]

#strong[#strong[\10. Напишите скрипт, выводящий все элементы строки с их
номерами индексов.]]

#strong[#strong[Решение:]]

#strong[#box(image("lab-1/assets/Pictures/10000001000001D6000000572B87687E1E59DBEC.png", height: 0.9063in, width: 4.8957in))#strong[]]

#strong[#strong[ \ ]]

#strong[#strong[]]

#strong[#strong[Тесты:]]

#strong[#box(image("lab-1/assets/Pictures/10000001000001C60000019526FB844F66228F5C.png", height: 4.2189in, width: 4.7291in))#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[\11. Напишите скрипт, проверяющий, содержится ли
произвольный символ (элемент) или слово в строке.]]

#strong[#strong[Решение:]]

#strong[#box(image("lab-1/assets/Pictures/10000001000001A800000037578919123C09C33A.png", height: 0.5728in, width: 4.4165in))#strong[]]

#strong[#strong[ \ ]]

#strong[#strong[Тесты:]]

#strong[#box(image("lab-1/assets/Pictures/100000010000031700000070730E88092F92C71A.png", height: 0.952in, width: 6.7283in))#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[\12. Выведите символ, который встречается в строке чаще,
чем остальные.]]

#strong[#strong[Решение:]]

#strong[#box(image("lab-1/assets/Pictures/100000010000022000000057C58C4FB259CC5334.png", height: 0.9063in, width: 5.6665in))#strong[]]

#strong[#strong[ \ ]]

#strong[#strong[Тесты:]]

#strong[#box(image("lab-1/assets/Pictures/1000000100000357000000B96D2EF1C9007D1435.png", height: 1.4555in, width: 6.7283in))#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[\13. Поменяйте регистр элементов строки.]]

#strong[#strong[Решение:]]

#strong[#box(image("lab-1/assets/Pictures/10000001000001A600000039DE387C125E03976F.png", height: 0.5937in, width: 4.3957in))#strong[]]

#strong[#strong[ \ ]]

#strong[#strong[Тесты:]]

#strong[#box(image("lab-1/assets/Pictures/100000010000030B0000006F20931709AA64F3ED.png", height: 0.9583in, width: 6.7283in))#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[\14. Вычислите сумму элементов (чисел) в списке двумя
разными способами.]]

#strong[#strong[Решение:]]

#strong[#box(image("lab-1/assets/Pictures/10000001000003820000009C04D2299DB01B092C.png", height: 1.1689in, width: 6.7283in))#strong[]]

#strong[#strong[Тесты:]]

#strong[#box(image("lab-1/assets/Pictures/100000010000023F00000168D736659B21A38FE2.png", height: 3.75in, width: 5.9898in))#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[\15. Умножьте каждый элемент списка на произвольное
число.]]

#strong[#strong[Решение:]]

#strong[#box(image("lab-1/assets/Pictures/10000001000002FF0000003C2CCD34B5C20BB87E.png", height: 0.5256in, width: 6.7283in))#strong[]]

#strong[#strong[Тесты:]]

#strong[#box(image("lab-1/assets/Pictures/10000001000002870000008B8ECDC4B8E91BC51B.png", height: 1.4453in, width: 6.7283in))#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[\16. Найдите максимальное и минимальное числа,
хранящиеся в списке.]]

#strong[#strong[Решение:]]

#strong[#box(image("lab-1/assets/Pictures/10000001000002ED0000003986A63E3AC663A23B.png", height: 0.5118in, width: 6.7283in))#strong[]]

#strong[#strong[Тесты:]]

#strong[#box(image("lab-1/assets/Pictures/10000001000002DE0000006F859FB85BC929B007.png", height: 1.0173in, width: 6.7283in))#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[\17. Напишите скрипт, удаляющий все повторяющиеся
элементы из списка.]]

#strong[#strong[Решение:]]

#strong[#box(image("lab-1/assets/Pictures/10000001000002910000003A7EB66E70DF2A31B1.png", height: 0.5937in, width: 6.7283in))#strong[]]

#strong[#strong[Тесты:]]

#strong[#box(image("lab-1/assets/Pictures/10000001000002A00000006E8606707C8239050D.png", height: 1.1008in, width: 6.7283in))#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[\18. Скопируйте список двумя различными способами.]]

#strong[#strong[Решение:]]

#strong[#box(image("lab-1/assets/Pictures/10000001000001C0000000A1B5DD6D61E3EFCD47.png", height: 1.6772in, width: 4.6665in))#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[Тесты:]]

#strong[#box(image("lab-1/assets/Pictures/100000010000020100000104AA69BC67F49E8340.png", height: 2.7083in, width: 5.3437in))#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[\17. Напишите скрипт, удаляющий все повторяющиеся
элементы из списка.]]

#strong[#strong[Решение:]]

#strong[#box(image("lab-1/assets/Pictures/10000001000002910000003A7EB66E70DF2A31B1.png", height: 0.5937in, width: 6.7283in))#strong[]]

#strong[#strong[Тесты:]]

#strong[#box(image("lab-1/assets/Pictures/10000001000002A00000006E8606707C8239050D.png", height: 1.1008in, width: 6.7283in))#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[\19. Напишите скрипт для слияния (конкатенации) двух
списков различными способами.]]

#strong[#strong[Решение:]]

#strong[#box(image("lab-1/assets/Pictures/1000000100000295000001988F88D13BB4C5B3FA.png", height: 4.1528in, width: 6.7283in))#strong[]]

#strong[#strong[Тесты:]]

#strong[#box(image("lab-1/assets/Pictures/10000001000002B200000137A62296F8E7ECAAB6.png", height: 3.0327in, width: 6.7283in))#strong[]]

#strong[#strong[\20. Напишите скрипт, меняющий позициями элементы списка
с индексами n и n + 1.]]

#strong[#strong[Решение:]]

#strong[#box(image("lab-1/assets/Pictures/10000001000003A4000000B732BFBC71FDEBAFC0.png", height: 1.3209in, width: 6.7283in))#strong[]]

#strong[#strong[Тесты:]]

#strong[#box(image("lab-1/assets/Pictures/10000001000002440000016679E554CDD60713B7.png", height: 3.7291in, width: 6.0417in))#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[\21. Напишите скрипт, переводящий список из различного
количества числовых целочисленных элементов в одно число. Пример списка:
\[15, 23, 150\], результат: 1523150]]

#strong[#strong[Решение:]]

#strong[#box(image("lab-1/assets/Pictures/100000010000020E0000006D9D08A66BA75249D0.png", height: 1.1354in, width: 5.4791in))#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[Тесты:]]

#strong[#box(image("lab-1/assets/Pictures/1000000100000206000000896E7E7D47D36223CD.png", height: 1.4272in, width: 5.3957in))#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[\22. Объявите и инициализируйте словарь различными
способами.]]

#strong[#strong[Решение:]]

#strong[#box(image("lab-1/assets/Pictures/1000000100000192000000E92E66E5E445359A78.png", height: 2.4272in, width: 4.1874in))#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[Тесты:]]

#strong[#box(image("lab-1/assets/Pictures/100000010000011C000000514472016F53F5AD9A.png", height: 0.8437in, width: 2.9583in))#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[\23. Добавьте еще несколько пар «ключ: значение» в
следующий словарь: {0: 10, 1: 20}.]]

#strong[#strong[Решение:]]

#strong[#box(image("lab-1/assets/Pictures/10000001000001BA000000D215B7175A18829BCB.png", height: 2.1874in, width: 4.6043in))#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[Тесты:]]

#strong[#box(image("lab-1/assets/Pictures/10000001000001980000003C9D27CAF408520FCF.png", height: 0.6252in, width: 4.25in))#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[\24. Напишите скрипт, который из трех словарей создаст
один новый.]]

#strong[#strong[Решение:]]

#strong[#box(image("lab-1/assets/Pictures/100000010000031100000086E9A419F9C0A9E345.png", height: 1.148in, width: 6.7283in))#strong[]]

#strong[#strong[Тесты:]]

#strong[#box(image("lab-1/assets/Pictures/100000010000037D000000ECFE98F75FFE4C90AF.png", height: 1.778in, width: 6.7283in))#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[\25. Напишите скрипт, проверяющий, существует ли
заданный ключ в словаре.]]

#strong[#strong[Решение:]]

#strong[#box(image("lab-1/assets/Pictures/100000010000026B00000039970A6571A3E6DF3C.png", height: 0.5937in, width: 6.448in))#strong[]]

#strong[#strong[Тесты:]]

#strong[#box(image("lab-1/assets/Pictures/10000001000002960000008A0121DDBF36EBD6DD.png", height: 1.402in, width: 6.7283in))#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[\26. Напишите скрипт для удаления элемента словаря.]]

#strong[#strong[Решение:]]

#strong[#box(image("lab-1/assets/Pictures/100000010000025B0000003E2A93DA0F64F0103D.png", height: 0.6457in, width: 6.2811in))#strong[]]

#strong[#strong[Тесты:]]

#strong[#box(image("lab-1/assets/Pictures/1000000100000245000000864E99D4467AD146AB.png", height: 1.3957in, width: 6.052in))#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[\27. Напишите скрипт, который выводит максимальное и
минимальное числа среди значений словаря.]]

#strong[#strong[Решение:]]

#strong[#box(image("lab-1/assets/Pictures/100000010000025500000070C49FF7F6B432644B.png", height: 1.1665in, width: 6.2189in))#strong[]]

#strong[#strong[Тесты:]]

#strong[#box(image("lab-1/assets/Pictures/10000001000003DC00000086F0679874FB40998F.png", height: 0.9126in, width: 6.7283in))#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[\28. Объявите и инициализируйте кортеж различными
способами, после чего распакуйте его.]]

#strong[#strong[Решение:]]

#strong[#box(image("lab-1/assets/Pictures/1000000100000168000000A001B1AF112C4301A7.png", height: 1.6665in, width: 3.75in))#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[Тесты:]]

#strong[#box(image("lab-1/assets/Pictures/10000001000001000000004DEAE6AF2010352EA2.png", height: 0.802in, width: 2.6665in))#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[\29. Напишите скрипт для добавления элементов в
кортеж.]]

#strong[#strong[Решение:]]

#strong[#box(image("lab-1/assets/Pictures/10000001000002890000003C82ED55BB1733F0FB.png", height: 0.6217in, width: 6.7283in))#strong[]]

#strong[#strong[Тесты:]]

#strong[#box(image("lab-1/assets/Pictures/1000000100000257000000868CBDE6241A0DA75C.png", height: 1.3957in, width: 6.2398in))#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[\30. Напишите скрипт, конвертирующий список в кортеж.]]

#strong[#strong[Решение:]]

#strong[#box(image("lab-1/assets/Pictures/10000001000001DB0000003A31B80A60871726FD.png", height: 0.6043in, width: 4.948in))#strong[]]

#strong[#strong[]]

#strong[#strong[Тесты:]]

#strong[#box(image("lab-1/assets/Pictures/100000010000021F000000890036FEF82F4DFFD6.png", height: 1.4272in, width: 5.6563in))#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[\31. Конвертируйте кортеж в словарь.]]

#strong[#strong[Решение:]]

#strong[#box(image("lab-1/assets/Pictures/10000001000003140000003CC6A19BC78D05C7CD.png", height: 0.5118in, width: 6.7283in))#strong[]]

#strong[#strong[Тесты:]]

#strong[#box(image("lab-1/assets/Pictures/1000000100000292000000B41F0D3210773BACC8.png", height: 1.8402in, width: 6.7283in))#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[\32. Напишите скрипт, подсчитывающий количество
элементов типа кортеж в списке.]]

#strong[#strong[Решение:]]

#strong[#box(image("lab-1/assets/Pictures/100000010000025B0000003A83AD9303EA9057B1.png", height: 0.6043in, width: 6.2811in))#strong[]]

#strong[#strong[Тесты:]]

#strong[#box(image("lab-1/assets/Pictures/1000000100000320000000B72B590AC1DB868ECC.png", height: 1.539in, width: 6.7283in))#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[\33. Объявите и инициализируйте множество различными
способами.]]

#strong[#strong[Решение:]]

#strong[#box(image("lab-1/assets/Pictures/1000000100000196000000CD0D03CD311FA83F7B.png", height: 2.1354in, width: 4.2291in))#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[Тесты:]]

#strong[#box(image("lab-1/assets/Pictures/10000001000000E6000000810B19365A7F555AC3.png", height: 1.3437in, width: 2.3957in))#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[\34. Добавьте элемент в множество.]]

#strong[#strong[Решение:]]

#strong[#box(image("lab-1/assets/Pictures/10000001000001F50000003AEC51D7462559CFCD.png", height: 0.6043in, width: 5.2189in))#strong[]]

#strong[#strong[]]

#strong[#strong[Тесты:]]

#strong[#box(image("lab-1/assets/Pictures/10000001000001F900000087FFD5990CC6DF1A68.png", height: 1.4063in, width: 5.2602in))#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[\35. Удалите элемент из множества.]]

#strong[#strong[Решение:]]

#strong[#box(image("lab-1/assets/Pictures/100000010000021F0000003B8D9ECBC531169F54.png", height: 0.6146in, width: 5.6563in))#strong[]]

#strong[#strong[Тесты:]]

#strong[#box(image("lab-1/assets/Pictures/10000001000001D200000089C1278DA783E7413C.png", height: 1.4272in, width: 4.8543in))#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[\37. Напишите скрипт для объединения двух множеств.]]

#strong[#strong[Решение:]]

#strong[#box(image("lab-1/assets/Pictures/100000010000021600000086606C0BAFD923814B.png", height: 1.3957in, width: 5.5626in))#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[Тесты:]]

#strong[#box(image("lab-1/assets/Pictures/100000010000024F000000A021D45FE4C93EABD7.png", height: 1.6665in, width: 6.1563in))#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[\38. Напишите скрипт, находящий длину множества двумя
различными способами.]]

#strong[#strong[Решение:]]

#strong[#box(image("lab-1/assets/Pictures/100000010000019D0000009EFC06BD7F30D1887A.png", height: 1.6457in, width: 4.302in))#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[Тесты:]]

#strong[#box(image("lab-1/assets/Pictures/1000000100000242000001655A94A2DBC388CC84.png", height: 3.7189in, width: 6.0209in))#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[\39. Напишите скрипт для проверки, входит ли элемент в
множество.]]

#strong[#strong[Решение:]]

#strong[#box(image("lab-1/assets/Pictures/10000001000002280000003944866778B82DEADE.png", height: 0.5937in, width: 5.75in))#strong[]]

#strong[#strong[Тесты:]]

#strong[#box(image("lab-1/assets/Pictures/10000001000002840000006B1C007AAA5E40AD03.png", height: 1.1146in, width: 6.7083in))#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[\40. Напишите скрипт для записи текста в файл.]]

#strong[#strong[Решение:]]

#strong[#box(image("lab-1/assets/Pictures/10000001000002630000005301D26A80A5AA955A.png", height: 0.8646in, width: 6.3646in))#strong[]]

#strong[#strong[Тесты:]]

#strong[#box(image("lab-1/assets/Pictures/100000010000022E000000EE53D4B20970833F71.png", height: 2.4791in, width: 5.8126in))#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[Файлы, появляющиеся при тестах:]]

#strong[#box(image("lab-1/assets/Pictures/1000000100000107000000636EC7F54678B85740.png", height: 1.0311in, width: 2.7398in))#strong[]]

#strong[#strong[]]

#strong[#strong[\41. Напишите скрипт для чтения текста из файла.]]

#strong[#strong[Решение:]]

#strong[#box(image("lab-1/assets/Pictures/10000001000001DF00000084454F1C0D1AB3A75A.png", height: 1.3752in, width: 4.9898in))#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[Тесты:]]

#strong[#box(image("lab-1/assets/Pictures/100000010000022C000000E911401223C4F25CA5.png", height: 2.4272in, width: 5.7917in))#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[Файлы, появляющиеся при тестах:]]

#strong[#box(image("lab-1/assets/Pictures/10000001000001560000005E404A6ADC4C5DE018.png", height: 0.9791in, width: 3.5626in))#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[\42. Напишите скрипт для добавления текста в файл и
отображения содержимого файла.]]

#strong[#strong[Решение:]]

#strong[#box(image("lab-1/assets/Pictures/10000001000002150000011D8E4A4AAE56893C18.png", height: 2.7717in, width: 5.1827in))#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[Тесты:]]

#strong[#box(image("lab-1/assets/Pictures/100000010000014400000256C21C82C5F71E9BC6.png", height: 5.1945in, width: 2.8146in))#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[Файлы, появляющиеся при тестах:]]

#strong[#box(image("lab-1/assets/Pictures/100000010000016A0000008E9A13DCB17644A584.png", height: 1.4791in, width: 3.7709in))#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[\43. Напишите скрипт для чтения последних n строк
файла.]]

#strong[#strong[Решение:]]

#strong[#box(image("lab-1/assets/Pictures/100000010000026A000000839B5B0E3084E9D9DB.png", height: 1.3646in, width: 6.4374in))#strong[]]

#strong[#strong[Тесты:]]

#strong[#box(image("lab-1/assets/Pictures/10000001000002C0000000FF76D1B417939AD864.png", height: 2.4366in, width: 6.7283in))#strong[]]

#strong[#strong[Файлы, появляющиеся при тестах:]]

#strong[#box(image("lab-1/assets/Pictures/10000001000000C0000000BB63A6442EA40EC8D8.png", height: 1.948in, width: 2in))#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[\44. Напишите скрипт, подсчитывающий количество строк в
файле.]]

#strong[#strong[Решение:]]

#strong[#box(image("lab-1/assets/Pictures/10000001000002340000009E81D7CFF8FFEC5CFA.png", height: 1.6457in, width: 5.8752in))#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[Тесты:]]

#strong[#box(image("lab-1/assets/Pictures/10000001000002990000011A1A1F4E102B1F6E80.png", height: 2.8528in, width: 6.7283in))#strong[]]

#strong[#strong[Файлы, появляющиеся при тестах:]]

#strong[#box(image("lab-1/assets/Pictures/10000001000000BC000000B2D77D3D8E7038D80E.png", height: 1.8543in, width: 1.9583in))#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[\45. Напишите скрипт, позволяющий найти самое
встречаемое слово в файле.]]

#strong[#strong[Решение:]]

#strong[#box(image("lab-1/assets/Pictures/10000001000002C0000001CC623EAFAC54477DD5.png", height: 4.3957in, width: 6.7283in))#strong[]]

#strong[#strong[Тесты:]]

#strong[#box(image("lab-1/assets/Pictures/10000001000002E60000008888CB4D17559655B1.png", height: 1.2327in, width: 6.7283in))#strong[]]

#strong[#strong[]]

#strong[#strong[Файлы, появляющиеся при тестах:]]

#strong[#box(image("lab-1/assets/Pictures/10000001000003110000028F30A33EE58859AFE6.png", height: 5.6138in, width: 6.7283in))#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[\46. Напишите скрипт, копирующий содержимое одного файла
в другой.]]

#strong[#strong[Решение:]]

#strong[#box(image("lab-1/assets/Pictures/1000000100000218000000B73E092390228797ED.png", height: 1.9063in, width: 5.5835in))#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[Тесты:]]

#strong[#box(image("lab-1/assets/Pictures/10000001000003DA00000198F6E8F66B4DB84867.png", height: 2.7839in, width: 6.7283in))]

#strong[#strong[Файлы, появляющиеся при тестах:]]

#strong[#box(image("lab-1/assets/Pictures/100000010000032100000062E73BDF4A2F10A222.png", height: 0.8228in, width: 6.7283in))#box(image("lab-1/assets/Pictures/100000010000032100000062C2A8BEAD7F14A2E9.png", height: 0.8228in, width: 6.7283in))#strong[]]

#strong[#strong[\47. Запишите словарь в файл посредством модуля pickle и
прочитайте его.]]

#strong[#strong[Решение:]]

#strong[#box(image("lab-1/assets/Pictures/10000001000003D9000000EB9EAE03BBC44A5C71.png", height: 1.6047in, width: 6.7283in))#strong[]]

#strong[#strong[Тесты:]]

#strong[#box(image("lab-1/assets/Pictures/1000000100000398000000B46BAC192307A62113.png", height: 1.3161in, width: 6.7283in))#strong[]]

#strong[#strong[Файлы, появляющиеся при тестах:]]

#strong[#box(image("lab-1/assets/Pictures/100000010000054A000000668EAC82B6F9FADF54.png", height: 0.5063in, width: 6.7283in))#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[\48. Запишите список в файл посредством модуля pickle и
прочитайте его.]]

#strong[#strong[Решение:]]

См. задание 47#strong[]

#strong[#strong[Тесты:]]

#strong[#box(image("lab-1/assets/Pictures/100000010000039C000000B8447DB26FBE084679.png", height: 1.3398in, width: 6.7283in))]

#strong[#strong[Файлы, появляющиеся при тестах:]]

#strong[#box(image("lab-1/assets/Pictures/10000001000005430000006B11E840DD9138860A.png", height: 0.5339in, width: 6.7283in))#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[\49. Запишите словарь в файл посредством модуля json и
прочитайте его.]]

#strong[#strong[Решение:]]

#strong[#box(image("lab-1/assets/Pictures/100000010000036C000000E6A21D6CE133F4213F.png", height: 1.7661in, width: 6.7283in))#strong[]]

#strong[#strong[Тесты:]]

#strong[#box(image("lab-1/assets/Pictures/1000000100000397000000B828CABBD47402DB6C.png", height: 1.3465in, width: 6.7283in))#strong[]]

#strong[#strong[Файлы, появляющиеся при тестах:]]

#strong[#box(image("lab-1/assets/Pictures/10000001000001DF0000006141F83D812A1CC578.png", height: 1.0102in, width: 4.9898in))#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]

#strong[#strong[]]
