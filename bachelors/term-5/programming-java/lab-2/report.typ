ФЕДЕРАЛЬНОЕ АГЕНСТВО ЖЕЛЕЗНОДОРОЖНОГО ТРАНСПОРТА

Федеральное государственное бюджетное образовательное учреждение высшего
образования

«ПЕТЕРБУРГСКИЙ ГОСУДАРСТВЕННЫЙ УНИВЕРСИТЕТ ПУТЕЙ СООБЩЕНИЯ Императора
Александра I»

Кафедра «Информационные и вычислительные системы»

Дисциплина «Программирование на языке JAVA»

#strong[ОТЧЁТ]

#strong[ПО ЛАБОРАТОРНОЙ РАБОТЕ № 2]

#strong[«Чтение и запись текстовых файлов»]

#figure(
  align(center)[#table(
    columns: 2,
    align: (auto,auto,),
    [Выполнил студент

    Факультет: АИТ

    Группа: ИВБ-211

    ], [Шефнер А.],
    [Проверила:

    Профессор кафедры

    «Информационные и вычислительные

    системы

    ], [Божко Л.М.],
  )]
  , kind: table
  )

#strong[Санкт-Петербург]

#strong[2024]

Оценочный лист результатов ЛР № 2

Ф.И.О. студента: #emph[Шефнер А.]

Группа \_\_\_\_\_\_\_\_\_\_\_\_\_#emph[ИВБ-211]\_\_\_\_\_\_\_\_\_\_\_\_

Профессор кафедры

«Информационные и вычислительные

системы»#strong[ «\_\_» \_\_\_\_\_\_\_\_\_\_2024 г. Божко Л.М. ]

#strong[Цель]

Получить теоретические и практические навыки работы с текстовыми файлами
в языке программирования Clojure

#strong[Задание]

+ Считать с текстового файла формата. CSV таблицу с значениями.
+ Организовать вывод данных в виде таблицы.
+ Вычислить среднее значение ячеек строки таблицы.

#strong[Ход работы]

Для реализации необходимого функционала задействованы такие мощные
инструменты Clojure функционального программирования, как map, apply,
pattern matching, а также оператор thread-last. Это позволило сделать
решение задачи простым и лаконичным.

В основном файле программы представлен парсинг аргументов командной
строки и вызов необходимых функций.

#strong[#strong[src/csv/core.clj]]

\(ns csv.print

\(:require \[clojure.string :as str\]))

\(defn transpose

\(\[\] (vector))

\(\[m\] (apply mapv vector m)))

\(defn print-element

\[width element\]

\(let

\[space (- width (count element))

left (+ (/ space 2) (mod space 2) 1)

right (+ (/ space 2) 1)

print-spaces \#(print (str/join \"\" (repeat % \" \")))\]

\(print-spaces left)

\(print element)

\(print-spaces right)))

\(defn print-csv \[csv\]

\(let

\[max-row (apply max (map count csv))

table (map \#(map str %) csv)

matrix (map \#(concat % (repeat (- max-row (count %)) \" \")) table)

max-cols (map \#(apply max (map count %)) (transpose matrix))

rows (map \#(zipmap max-cols %) matrix)

delimeter-width (+ (apply + max-cols) (\* (count max-cols) 3) 1)

delimeter (str/join \"\" (repeat delimeter-width \"-\"))\]

(println delimeter)

\(doseq \[row rows\]

\(doseq \[element row\]

\(print \"|\")

\(print-element (first element) (second element)))

\(println \"|\")

\(println delimeter))))

\(defn print-rows \[rows\]

\(println \"Result:\")

\(doseq \[\[i row\] (map-indexed vector rows)\]

\(println (format \" %d: %f\" (inc i) row)))) \

В файле parse.clj представлен набор функций, необходимый для
представления последовательности строк в виде CSV таблицы. Обратите
внимание, что последовательность может быть ленивой.

#strong[#strong[src/csv/parse.clj]]

\(ns csv.parse

\(:require \[clojure.string :as str\]))

\(defn parse-line \[line\]

\(-\>\> line

(\#(str/split % \#\",\"))

(map str/trim)))

\(defn parse-csv \[lines\]

\(map parse-line lines))

\(defn csv-row-to-doubles \[row\]

\(map parse-double row))

\(defn csv-cells-to-doubles \[csv\]

\(map csv-row-to-doubles csv)) \

В файле print.clj представлен набор функций для вывода CSV данных в
поток стандартного вывода в виде таблицы.

#strong[#strong[src/csv/print.clj]]

\(ns csv.print

\(:require \[clojure.string :as str\]))

\(defn transpose

\(\[\] (vector))

\(\[m\] (apply mapv vector m)))

\(defn print-element

\[width element\]

\(let

\[space (- width (count element))

left (+ (/ space 2) (mod space 2) 1)

right (+ (/ space 2) 1)

print-spaces \#(print (str/join \"\" (repeat % \" \")))\]

\(print-spaces left)

\(print element)

\(print-spaces right)))

\(defn print-csv \[csv\]

\(let

\[max-row (apply max (map count csv))

table (map \#(map str %) csv)

matrix (map \#(concat % (repeat (- max-row (count %)) \" \")) table)

max-cols (map \#(apply max (map count %)) (transpose matrix))

rows (map \#(zipmap max-cols %) matrix)

delimeter-width (+ (apply + max-cols) (\* (count max-cols) 3) 1)

delimeter (str/join \"\" (repeat delimeter-width \"-\"))\]

(println delimeter)

\(doseq \[row rows\]

\(doseq \[element row\]

\(print \"|\")

\(print-element (first element) (second element)))

\(println \"|\")

\(println delimeter))))

\(defn print-rows \[rows\]

\(println \"Result:\")

\(doseq \[\[i row\] (map-indexed vector rows)\]

\(println (format \" %d: %f\" (inc i) row)))) \

В файле calculate.clj представлен набор функций для вычисления среднего
значения строк таблицы

#strong[#strong[src/csv/calculate.clj]]

\(ns csv.calculate)

\(defn calculate-row-average \[row\]

\(/ (apply + row) (count row)))

\(defn calculate-csv-averages \[csv\]

\(map calculate-row-average csv))

#strong[]

#strong[Отладка]

Программа получает на вход требуемое действие и путь к CSV файлу. В
целях отладки создан тестовый файл test.csv. На следующем рисунке
представлены различные варианты использования разработанной
программы.#box(image("./assets/100000010000086A0000062ACD08AB77.png", height: 4.7583in, width: 6.4957in))

Рис. 1 -- отладка программы

#strong[Вывод]

В ходе работы были приобретены теоретические и практические навыки
работы с файлами в языкы программирования Clojure и была реализована
программа с интерфейсом командной строки для работы с CSV файлами
