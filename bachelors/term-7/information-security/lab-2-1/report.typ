ФЕДЕРАЛЬНОЕ АГЕНТСТВО ЖЕЛЕЗНОДОРОЖНОГО ТРАНСПОРТА

Федеральное государственное бюджетное образовательное учреждение

высшего образования

«Петербургский государственный университет путей сообщения

#strong[Императора Александра I»]

(ФГБОУ ВО ПГУПС)

Факультет «Автоматизация и интеллектуальные технологии»

Кафедра «Информатика и информационная безопасность»

Лабораторная работа № 2.1

по дисциплине

«Защита информации»

«Изучение простейших методов шифрования информации в ручном режиме»

Вариант № 7

#figure(
  align(center)[#table(
    columns: 3,
    align: (auto,auto,auto,),
    [Выполнили обучающиеся

    Курс 4

    Группа ИВБ-211

    ], [], [А. Шефнер

    Н.М. Егупов

    ],
    [], [], [],
    [Проверил

    ], [], [М.Л. Глухарев

    ],
  )]
  , kind: table
  )

Санкт-Петербург

2025

Оценка лабораторной работы

#figure(
  align(center)[#table(
    columns: 3,
    align: (auto,auto,auto,),
    [Показатель

    #strong[ оценивания]

    ], [Критерии

    оценивания

    ], [Шкала оценивания],
    table.cell(rowspan: 2)[Выполнение задания], [Задание
    выполнено], [​<anchor>],
    [Задание не выполнено], [],
    table.cell(rowspan: 2)[Замечания к разработанному программному
    обеспечению], [Недостатки в работе отсутствуют или устраняются
    студентом в течение лабораторного занятия, на котором работа
    представляется к сдаче], [],
    [В работе имеются недостатки, не устраненные студентом в день сдачи
    лабораторной работы (в течение лабораторного занятия)], [],
    table.cell(colspan: 2)[Количество баллов по результатам проверки и
    защиты лабораторной работы (вписывается преподавателем)], [],
  )]
  , kind: table
  )

\1. Задание

В ручном режиме зашифровать открытый текст методами простой замены,
простой перестановки и гаммирования, используя соответствующие ключи:

#figure(
  align(center)[#table(
    columns: 4,
    align: (auto,auto,auto,auto,),
    table.cell(rowspan: 2)[Открытый текст], table.cell(colspan: 3)[Ключ
    шифрования],
    [Подстановка], [Перестановка], [Гаммирование],
    [ГНЕВ ЭТО КРАТКОВРЕМЕННОЕ БЕЗУМИЕ], [14], [52641730], [ГОРАЦИИ],
  )]
  , kind: table
  )

Для контроля правильности шифрования использовать программное средство
ElementalCiphers.

\2. Выполнение

Для выполнения лабораторной работы была разработана программа,
реализующая используемые в работе алгоритмы шифрования, на языке
программирования Go.

Исходный текст программы:

```
package main

import (
 "fmt"
 "os"
 "strconv"
 "unicode"
)

var ALPHABET = []rune("АБВГДЕЖЗИКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ ")

func main() {
 if len(os.Args) == 1 {
 printHelp()
 os.Exit(64)
 }

 subcommand := os.Args[1]
 if subcommand == "help" || subcommand == "--help" || subcommand == "-h" {
 printHelp()
 os.Exit(0)
 }

 if len(os.Args) != 4 {
 fmt.Println("Incorrect number of arguments")
 printHelp()
 os.Exit(64)
 }

 input := os.Args[2]
 key := os.Args[3]
 inputRunes := []rune(input)
 outputRunes := make([]rune, len(inputRunes))

 switch subcommand {
 case "replace":
 offset, err := strconv.ParseInt(key, 10, 32)
 if err != nil {
 fmt.Println("Replace key must be integer")
 os.Exit(64)
 }

 for i := range inputRunes {
 outputRunes[i] = replaceChar(inputRunes[i], int(offset))
 }

 case "permute":
 permutes := make([]int, len(key))
 for i, r := range key {
 if !unicode.IsDigit(r) {
 fmt.Println("Permute key must consist only of decimal digits")
 os.Exit(64)
 }

 permutes[i] = int(r) - '0'
 }

 blockSize := len(permutes)
 leftover := len(inputRunes) % blockSize
 if leftover != 0 {
 for ; leftover < blockSize; leftover += 1 {

 inputRunes = append(inputRunes, ' ')
 outputRunes = append(inputRunes, ' ')
 }
 }

 for i := 0; i < len(inputRunes); i += blockSize {
 for j := 0; j < blockSize; j += 1 {
 offset := permutes[j]
 outputRunes[i+offset] = inputRunes[i+j]
 }
 }

 case "gamming":
 gamma := []rune(key)
 gammaIndices := make([]int, len(gamma))
 for i := 0; i < len(gammaIndices); i += 1 {
 index, _ := alphabetIndex(gamma[i])
 gammaIndices[i] = index
 }

 for i := 0; i < len(inputRunes); i++ {
 gammaIndex := gammaIndices[rem(i, len(gammaIndices))]
 inputIndex, _ := alphabetIndex(inputRunes[i])
 if gammaIndex != -1 && inputIndex != -1 {
 newIndex := gammaIndex ^ inputIndex
 outputRunes[i] = ALPHABET[newIndex]
 } else {
 outputRunes[i] = inputRunes[i]
 }
 }

 default:
 fmt.Printf("Unknown cipher `%s`\n", subcommand)
 printHelp()
 os.Exit(64)
 }

 fmt.Println(string(outputRunes))
}

func printHelp() {
 fmt.Println("Usage: ./program <cipher> <input> <key>")
 fmt.Println("Possible ciphers:")
 fmt.Println("   - replace")
 fmt.Println("   - permute")
 fmt.Println("   - gamming")
}

func replaceChar(c rune, offset int) rune {
 index, ok := alphabetIndex(c)
 if !ok {
 return c
 }

 index = rem(index+offset, len(ALPHABET))
 return ALPHABET[index]
}

func alphabetIndex(c rune) (index int, ok bool) {
 for i, r := range ALPHABET {
 if r == c {
 return i, true
 }
 }

 return -1, false
}

func rem(a int, b int) int {
 rem := a % b
 if rem < 0 {
 rem += b
 }
 return rem
}
```

Пример вывода программы:

#box(image("./assets/image-1.png", height: 37.68mm, width: 165.01mm))

2.1. Зашифрование методом подстановки

#box(image("./assets/image-2.png", height: 93.64mm, width: 111.8mm))

2.2. Зашифрование методом перестановки

#box(image("./assets/image-3.png", height: 99.62mm, width: 118.41mm))#emph[]

2.3. Зашифрование методом гаммирования

#box(image("./assets/image-4.png", height: 99.47mm, width: 118.59mm))#emph[]
