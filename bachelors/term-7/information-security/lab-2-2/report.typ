ФЕДЕРАЛЬНОЕ АГЕНТСТВО ЖЕЛЕЗНОДОРОЖНОГО ТРАНСПОРТА

Федеральное государственное бюджетное образовательное учреждение

высшего образования

«Петербургский государственный университет путей сообщения

#strong[Императора Александра I»]

(ФГБОУ ВО ПГУПС)

Факультет «Автоматизация и интеллектуальные технологии»

Кафедра «Информатика и информационная безопасность»

Лабораторная работа № 2.2

по дисциплине

«Защита информации»

«Использование криптографических сервис-провайдеров при решении задач
профессиональной деятельности. Симметричное шифрование. Исследование
статистических свойств открытого и зашифрованного текста»

#figure(
  align(center)[#table(
    columns: 3,
    align: (auto,auto,auto,),
    [Выполнили обучающиеся

    Курс 4<anchor>

    Группа ИВБ-211

    ], [], [А. Шефнер

    Н.М. Егупов

    ],
    [], [], [],
    [Проверил

    ], [], [М. Л. Глухарев

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

    #strong[ оценивания ]

    ], [Критерии

    оценивания

    ], [Шкала оценивания],
    table.cell(rowspan: 4)[Качество выполнения задания, отчета и защиты
    по лабораторной работе], [Нет замечаний], [],
    [Зафиксирован #emph[один из] следующих недочетов:

    - допущены ошибки при выполнении задания, но в целом задание
      выполнено;
    - даны неверные ответы на часть контрольных вопросов;
    - имеются отдельные недостатки в оформлении отчета;
    - работа сдана с опозданием на две недели и более.

    ], [],
    [Зафиксировано два недочета из перечисленных в предыдущем
    пункте], [],
    [Допущено значительное количество неточностей или задание не
    выполнено, не даны ответы на контрольные вопросы], [],
    table.cell(colspan: 2)[Количество баллов по результатам проверки и
    защиты лабораторной работы (вписывается преподавателем)], [],
  )]
  , kind: table
  )

1.~Задание

\1. Разработать на языке Go приложение, которое выполняет следующие
функции:

- выбор алгоритма симметричного шифрования пользователем по названию
  (варианты: RC2, RC4, RC5, DES, DESede, AES);
- генерацию симметричного ключа для выбранного алгоритма шифрования;
- зашифрования произвольного сообщения;
- расшифрование сообщения;
- расчет средней энтропии байта в открытом тексте;
- расчет средней энтропии байта в зашифрованном тексте.

\2. Выполнить тестирование приложения.

2.1. Выбрать произвольное короткое сообщение.

2.2. Измерить среднюю энтропию байта в сообщении.

2.3. Выбирая поочерёдно каждый из предложенных методов шифрования:

- зашифровать сообщение, измерить среднюю энтропию байта в шифртексте;
- расшифровать сообщение, проверить правильность результата;
- ответить на вопрос, как изменилась средняя энтропия байта в результате
  шифрования и как это характеризует качество шифрования.

2.4. Выбрать произвольное сообщение в два раза длиннее предыдущего.
Выполнить над ним действия, описанные в пунктах 2.2, 2.3.

2.5. Выбрать произвольное сообщение в четыре раза длиннее предыдущего.
Выполнить над ним действия, описанные в пунктах 2.2, 2.3.

2.6. Сделать вывод о том, как повлияла длина сообщения на полученные
статистические характеристики шифртекстов.

\2. Выполнение

1.~В ходе выполнения лабораторной работы разработано программное
обеспечение на языке программирования Go. Следует отметить, что вместо
использования блочных шифров напрямую, программное обеспечение создаёт
потоковый шифр на основе выбранного блочного, что в целом приведёт к
увеличению энтропии зашифрованного текста. Исходный текст которого
выглядит следующим образом:

package main

import (

\"crypto/aes\"

\"crypto/cipher\"

\"crypto/des\"

\"crypto/rand\"

\"crypto/rc4\"

\"crypto/sha256\"

\"encoding/base64\"

\"errors\"

\"fmt\"

\"io\"

\"math\"

\"os\"

\"strconv\"

\"time\"

\"github.com/resaec/go-rc5\"

\"github.com/zmap/rc2\"

)

var IvSource =
\[\]byte(\"47NpeJQkhyKOx8zcVur0PQljGgh1k927ThPSNIkvFJaZphiPO3ZXqpAfYsqUzj352eyOEYbZkaKNCFJObJcFwux8HALI4Lc44BaVHGaVVNAYtBFM39OvOsT26IuY6Sob\")

type Flags struct {

algorithm string

key string

printDecrypted bool

}

func main() {

if len(os.Args) == 1 {

printUsage()

os.Exit(0)

}

subcommand := os.Args\[1\]

flags := Flags{}

for i := 2; i \< len(os.Args); i += 2 {

if i+1 \>= len(os.Args) {

printUsage()

os.Exit(64)

}

flag := os.Args\[i\]

value := os.Args\[i+1\]

switch flag {

case \"-a\":

fallthrough

case \"-\-alg\":

flags.algorithm = value

case \"-k\":

fallthrough

case \"-\-key\":

flags.key = value

case \"-p\":

fallthrough

case \"-\-print-encrypted\":

var err error

flags.printDecrypted, err = strconv.ParseBool(value)

if err != nil {

fmt.Printf(\"Invalid value for flag %s: %s: %v\\n\", flag, value, err)

os.Exit(64)

}

default:

fmt.Printf(\"unknown flag %s\\n\", flag)

os.Exit(64)

}

}

switch subcommand {

case \"help\":

fallthrough

case \"-\-help\":

fallthrough

case \"-h\":

printUsage()

os.Exit(0)

case \"encrypt\":

ciph, err := getCipher(flags.algorithm, flags.key)

if err != nil {

fmt.Println(err)

os.Exit(1)

}

input, err := io.ReadAll(os.Stdin)

if err != nil {

fmt.Println(err)

os.Exit(1)

}

ciph.XORKeyStream(input, input)

encoder := base64.NewEncoder(base64.URLEncoding, os.Stdout)

encoder.Write(input)

case \"decrypt\":

ciph, err := getCipher(flags.algorithm, flags.key)

if err != nil {

fmt.Println(err)

os.Exit(1)

}

decoder := base64.NewDecoder(base64.URLEncoding, os.Stdin)

input, err := io.ReadAll(decoder)

if err != nil {

fmt.Println(err)

os.Exit(1)

}

ciph.XORKeyStream(input, input)

fmt.Println(string(input))

case \"stats\":

ciph, err := getCipher(flags.algorithm, flags.key)

if err != nil {

fmt.Println(err)

os.Exit(1)

}

input, err := io.ReadAll(os.Stdin)

if err != nil {

fmt.Println(err)

os.Exit(1)

}

inputEntropy := computeEntropy(input)

beginTime := time.Now()

ciph.XORKeyStream(input, input)

execTime := time.Since(beginTime)

outputEntropy := computeEntropy(input)

fmt.Printf(\"Open text entropy: %v\\n\", inputEntropy)

fmt.Printf(\"Encrypted text entropy: %v\\n\", outputEntropy)

fmt.Printf(\"Encryption time: %v\\n\", execTime)

if flags.printDecrypted {

fmt.Printf(\"Encrypted text: \")

encoder := base64.NewEncoder(base64.URLEncoding, os.Stdout)

encoder.Write(input)

fmt.Println()

}

}

}

func printUsage() {

fmt.Println(\"Usage: \./program \<subcommand\> \[OPTIONS\]\")

fmt.Println()

fmt.Println(\"Subcommands:\")

fmt.Println(\" help print this message\")

fmt.Println(\" encrypt encrypt input from stdin\")

fmt.Println(\" decrypt decrypt input from stdin\")

fmt.Println(\" stats compute some statistics about cipher using input
from stdin\")

fmt.Println()

fmt.Println(\"Options:\")

fmt.Println(\" -a, -\-alg \<algorithm\> algorithm to use
\[aes|des|tdes\]\")

fmt.Println(\" -k, -\-key \<key\> provide your own key\")

fmt.Println(\" -p, -\-print-encrypted \<boolean\> when computing statd,
print encrypted text?\")

}

func getCipher(name string, key string) (cipher.Stream, error) {

var keyHash \[32\]byte

if len(key) == 0 {

rand.Read(keyHash\[:\])

} else {

keyHash = sha256.Sum256(\[\]byte(key))

}

var stream cipher.Stream

switch name {

case \"aes\":

block, err := aes.NewCipher(keyHash\[:aes.BlockSize\])

if err != nil {

return nil, err

}

iv := IvSource\[:aes.BlockSize\]

stream = cipher.NewCTR(block, iv)

case \"des\":

block, err := des.NewCipher(keyHash\[:des.BlockSize\])

if err != nil {

return nil, err

}

iv := IvSource\[:des.BlockSize\]

stream = cipher.NewCTR(block, iv)

case \"tdes\":

block, err := des.NewTripleDESCipher(keyHash\[:des.BlockSize\*3\])

if err != nil {

return nil, err

}

iv := IvSource\[:des.BlockSize\]

stream = cipher.NewCTR(block, iv)

case \"rc2\":

block, err := rc2.NewCipher(keyHash\[:\])

if err != nil {

return nil, err

}

iv := IvSource\[:block.BlockSize()\]

stream = cipher.NewCTR(block, iv)

case \"rc4\":

block, err := rc4.NewCipher(keyHash\[:\])

if err != nil {

return nil, err

}

stream = block

case \"rc5\":

block, err := rc5.NewCipher64(keyHash\[:\], 12)

if err != nil {

return nil, err

}

iv := IvSource\[:block.BlockSize()\]

stream = cipher.NewCTR(block, iv)

default:

return nil, errors.New(\"unknown algorithm\")

}

return stream, nil

}

func computeEntropy(bytes \[\]byte) float64 {

counts := \[256\]int{}

for \_, b := range bytes {

counts\[b\] += 1

}

sum := float64(0)

for i := range counts {

p := float64(counts\[i\]) / float64(len(bytes))

if p == 0 {

continue

}

sum += p \* math.Log2(p)

}

return -sum

}

2.~Результат тестирования разработанного программного обеспечения:

Результат шифрования сообщения «He мысля гордый свет забавить», средняя
энтропия байта в котором составляет 3.844 бит.

#figure(
  align(center)[#table(
    columns: 3,
    align: (auto,auto,auto,),
    [Алгоритм шифрования], [Шифртекст], [Средняя энтропия байта в
    шифртексте, бит],
    [RC2], [qFxHRA7SErndQjFUa8FXdr4CGSxfR6l4Iv\_felnsBzLRPoYLbe9PEq-4lRPsw5sWdJnC], [5.614712907393384],
    [RC4], [5NXBDV9q4IF-d\_QnEqx5zRcNsK4ZCZ6LimhIvXgPsOet1asjSeYWdEUz\_e859qCtIduG], [5.576977058336781],
    [RC5], [yneGjvixCyv0dd1WVpU\_ndC-0YDQtNGL0Lkg0YHQstC10YIg0LfQsNCx0LDQstC40YLR], [4.4908728543870255],
    [DES], [\_xKBDvRJf2z0gYe1eXM47YDRoxr2GQp3iWieoaq2Fdy6dLyP7T9\_LkaTOlK49u6V6GE4], [5.501505360223574],
    [DESede], [2Aa51Od9vMPp520CzDcI2Z7\_9skkl-gfwPdD89AcK8DoUrmXptEGoF4ZtmBtLcTdmUZn], [5.463769511166971],
    [AES], [ejF47p\_HwXBkDPP5vqEfU9fDze28EkT5xiW-HslzexRxEA1IFGmO63iSxzsZa4wsF3FG], [5.501505360223574],
  )]
  , kind: table
  )

Вывод: RC2 показал наибольшее увеличение энтропии, в то время как RC5
--- наименьшее. Можно предположить, что RC2 является самым качественным
шифром.

Результат шифрования сообщения «He мысля гордый свет забавить, Вниманье
дружбы возлюбя», средняя энтропия байта в котором составляет 3.961 бит.

#figure(
  align(center)[#table(
    columns: 3,
    align: (auto,auto,auto,),
    [Алгоритм шифрования], [Шифртекст], [Средняя энтропия байта в
    шифртексте, бит],
    [RC2], [qFxHRA7SErndQjFUa8FXdr4CGSxfR6l4Iv\_felnsBzLRPoYLbe9PEq-4lRPsw5sWdJnCuzsiu8OrvbCj2JN8mfG\_eS5xv7cH\_MiFjdMFr6tr5ioKhc9zK\_PCR2w49goTuhiZ], [6.250470003874293],
    [RC4], [5NXBDV9q4IF-d\_QnEqx5zRcNsK4ZCZ6LimhIvXgPsOet1asjSeYWdEUz\_e859qCtIduGBMRVk2QFu7zrsdNB\_siGeDmAH\_\_8OoPzBCl9pfHfR5F-UgxqOyvOB-n4eCY-GPW6], [6.399509271572916],
    [RC5], [yneGjvixCyv0dd1WVpU\_ndC-0YDQtNGL0Lkg0YHQstC10YIg0LfQsNCx0LDQstC40YLRjCwg0JLQvdC40LzQsNC90YzQtSDQtNGA0YPQttCx0Ysg0LLQvtC30LvRjtCx0Y8K], [4.423797042715106],
    [DES], [\_xKBDvRJf2z0gYe1eXM47YDRoxr2GQp3iWieoaq2Fdy6dLyP7T9\_LkaTOlK49u6V6GE4HLt\_PdtNoT8kSXH\_reVjjgPXC10rnsEtBd1pIPSCG82pbfaHAn36HAtVbGTTRMLE], [6.242844877589815],
    [DESede], [2Aa51Od9vMPp520CzDcI2Z7\_9skkl-gfwPdD89AcK8DoUrmXptEGoF4ZtmBtLcTdmUZnrzcVe3dbFPMRB1bqr5XBfKh\_aXT0tjIlXfJu1JLcn4BJJBzKkbj9-JX0AaUmRmsc], [6.258095130158773],
    [AES], [ejF47p\_HwXBkDPP5vqEfU9fDze28EkT5xiW-HslzexRxEA1IFGmO63iSxzsZa4wsF3FGEQF-e8BDcSgGJpqhDuoDVMFGjVA97wmjoWWl9E2pSYZfjFrB0D57ficUpO0uqBeH], [6.2073926048188355],
  )]
  , kind: table
  )

Вывод: все шифры, кроме RC5, увеличили энтропию и пришли примерно к
одному результату в ≈6.3 бит. RC5, в свою очередь, показал меньшую
энтропию по сравнению с предыдущим результатом. Можно предположить, что
RC5 имеет самое низкое качество среди остальных.

Результат шифрования сообщения «He мысля гордый свет забавить, Вниманье
дружбы возлюбя, Хотел бы я тебе представить Залог достойнее тебя»,
средняя энтропия байта в котором составляет 3.897 бит.

#figure(
  align(center)[#table(
    columns: 3,
    align: (auto,auto,auto,),
    [Алгоритм шифрования], [Шифртекст], [Средняя энтропия байта в
    шифртексте, бит],
    [RC2], [qFxHRA7SErndQjFUa8FXdr4CGSxfR6l4Iv\_felnsBzLRPoYLbe9PEq-4lRPsw5sWdJnCuzsiu8OrvbCj2JN8mfG\_eS5xv7cH\_MiFjdMFr6tr5ioKhc9zK\_PCR2w49goTuhi\_x2TeDlWyuzM49yHgppIIknXb-Hz-n22zY5y0xjkUq7jkTqbQc1iCrZztJKwVmgGKeWenzdVX-ERyifN6cWiiUNgFxN1XEJZmqQeoIY5SqP0LY-gwicFBojF5], [6.990702450345122],
    [RC4], [5NXBDV9q4IF-d\_QnEqx5zRcNsK4ZCZ6LimhIvXgPsOet1asjSeYWdEUz\_e859qCtIduGBMRVk2QFu7zrsdNB\_siGeDmAH\_\_8OoPzBCl9pfHfR5F-UgxqOyvOB-n4eCY-GPWclnw8sQ4zOEGEbqNv1vBqd7tbD7AWMjegXUWEKLII-koWf8pneqXpf2478VBBRddqhT7bDhZbWY604gsBglOqdQFFML0U6OdcikT9mNCYaxfceKQcheUsQSkV], [6.976408832003776],
    [RC5], [yneGjvixCyv0dd1WVpU\_ndC-0YDQtNGL0Lkg0YHQstC10YIg0LfQsNCx0LDQstC40YLRjCwg0JLQvdC40LzQsNC90YzQtSDQtNGA0YPQttCx0Ysg0LLQvtC30LvRjtCx0Y8sINCl0L7RgtC10Lsg0LHRiyDRjyDRgtC10LHQtSBSrXfelNVQTqQktwUJBT-c0LjRgtGMINCX0LDQu9C-0LMg0LTQvtGB0YLQvtC50L3QtdC1INGC0LXQsdGP], [4.575430736014608],
    [DES], [\_xKBDvRJf2z0gYe1eXM47YDRoxr2GQp3iWieoaq2Fdy6dLyP7T9\_LkaTOlK49u6V6GE4HLt\_PdtNoT8kSXH\_reVjjgPXC10rnsEtBd1pIPSCG82pbfaHAn36HAtVbGTTRMLi6BIaKI\_LHyrp-kP5Aa\_gnSx1H-w4ZF0g0ilyhZCLgp1lemtk2\_xmmNqDwn0HbxbE702kCxWbSlifKUCd\_IGxJJMO1WRh4KVts89xPhJfuYCeqDVfgXMa2H2J], [6.898545739796035],
    [DESede], [2Aa51Od9vMPp520CzDcI2Z7\_9skkl-gfwPdD89AcK8DoUrmXptEGoF4ZtmBtLcTdmUZnrzcVe3dbFPMRB1bqr5XBfKh\_aXT0tjIlXfJu1JLcn4BJJBzKkbj9-JX0AaUmRms6HfYvWT0WRgmnSOB7s8bWlxBHZj-Fx096wu\_5eEKftxQxJBOoDrjNLtRIAPP86pq2u4Qdm0NGvA1sE8Nl19gJdGG9n065rUpzkkMfT-xQwSFeTD\_G9uP8dT67], [6.965676726649521],
    [AES], [ejF47p\_HwXBkDPP5vqEfU9fDze28EkT5xiW-HslzexRxEA1IFGmO63iSxzsZa4wsF3FGEQF-e8BDcSgGJpqhDuoDVMFGjVA97wmjoWWl9E2pSYZfjFrB0D57ficUpO0uqBehhoU-\_DoC2M9060YkfjGTQupS88YL4cPw1mlrUqdaM95HRMbYxxMq8w6RDUWzsouA33egLW4tDFDA5jzHZNWLDTgWGoiW2QRyn0-u5V9Vuj25rQAruvkZLNHq], [6.894572647679382],
  )]
  , kind: table
  )

Вывод: результаты для данного сообщения полностью аналогичны результатам
для предыдущего кроме того, что средняя энтропия между всеми шифрами,
кроме RC5, выросла до ≈6.9.

Результат шифрования полного текста произведения А.С. Пушкина «Евгений
Онегин», средняя энтропия байта в котором составляет 4.416 бит.

#figure(
  align(center)[#table(
    columns: 3,
    align: (auto,auto,auto,),
    [Алгоритм шифрования], [Шифртекст], [Средняя энтропия байта в
    шифртексте, бит],
    [RC2], table.cell(rowspan: 6)[Опущен в связи со слишком большим
    размером (≈600 килобайт)], [7.999384365363326],
    [RC4], [7.999410719029977],
    [RC5], [5.177961326745027],
    [DES], [7.999467776264637],
    [DESede], [7.999461947640753],
    [AES], [7.99948698718201],
  )]
  , kind: table
  )

Вывод: для достаточно большого по величине текста средняя энтропия
зашифрованного текста всеми алгоритмами, кроме RC5, примерно в 2 раза
больше открытого и составила ≈8 бит. Это значение очень близко к
максимально возможному значению средней энтропии каждого байта. Каждый
шифр, кроме RC5, показал хорошее качество шифрование, если брать прирост
средней энтропии байта в качестве метрики качества.

Вывод о влиянии длины текста на полученные статистические характеристики
шифртекстов: чем больше длина открытого текста, тем выше средняя
энтропия байта как для открытого, так и для зашифрованного текста.
