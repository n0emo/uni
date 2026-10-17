ФЕДЕРАЛЬНОЕ АГЕНСТВО ЖЕЛЕЗНОДОРОЖНОГО ТРАНСПОРТА

Федеральное государственное бюджетное образовательное учреждение высшего
образования

«ПЕТЕРБУРГСКИЙ ГОСУДАРСТВЕННЫЙ УНИВЕРСИТЕТ ПУТЕЙ СООБЩЕНИЯ Императора
Александра I»

Кафедра «Информационные и вычислительные системы»

Дисциплина «Программирование на языке JAVA»

#strong[ОТЧЁТ]

#strong[ПО ЛАБОРАТОРНОЙ РАБОТЕ № 3]

#strong[«Reflection API»]

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

Оценочный лист результатов ЛР № 3

Ф.И.О. студента: #emph[Шефнер А.]

Группа \_\_\_\_\_\_\_\_\_\_\_\_\_#emph[ИВБ-211]\_\_\_\_\_\_\_\_\_\_\_\_

Профессор кафедры

«Информационные и вычислительные

системы»#strong[ «\_\_» \_\_\_\_\_\_\_\_\_\_2024 г. Божко Л.М. ]

#strong[Цель]

Получить теоретические и практические навыки работы интерфейсом
рефлексии языка программирования Clojure

#strong[Задание ]

Необходимо разработать приложение, которое, получая на вход наименование
экземпляра некоторого класса, выводит список его функционала.

#strong[Ход работы]

Стандартная библиотека Clojure в модуле clojure.reflect предоставляет
функцию reflect, которая принимает на вход класс, а возвращает словарь,
описывающий различные свойства класса. Основная работа заключается в
исследовании этого словаря и извлечении и выводе необходимой для
пользователя информации. Далее представлен полный код разработанной
программы.

\(ns reflections.core

\(:gen-class)

\(:require

\[clojure.reflect :as cr\]

\[clojure.string :as str\]))

\(defn- print-sorted \[fields\]

\(if (empty? fields)

\(println \" none\")

\(doseq \[f (sort fields)\]

\(println \" \" f))))

\(defn- print-members \[members msg to-str predicate\]

\(println msg)

\(print-sorted (-\> \[f (filter predicate members)\]

\(for (to-str f)))))

\(defn- static? \[member\]

\(contains? (get member :flags) :static))

\(defn- field? \[m\]

\(contains? m :type))

\(defn- method? \[m\]

\(contains? m :return-type))

\(defn- field-to-str \[f\]

\(format \"%s %s %s\"

\(str/join \" \" (map name (into \[\] (get f :flags))))

\(get f :type)

\(get f :name)))

\(defn- method-to-str \[f\]

\(format \"%s %s %s(%s)\"

\(str/join \" \" (map name (into \[\] (get f :flags))))

\(get f :return-type)

\(get f :name)

\(str/join \", \" (get f :parameter-types))))

\(defn- print-all-members \[members\]

\(print-members members \"Static fields\" field-to-str

(every-pred field? static?))

\(print-members members \"Static methods\" method-to-str

(every-pred method? static?))

\(println)

\(print-members members \"Instance fields\" field-to-str

(every-pred field? (complement static?)))

\(print-members members \"Instance methods\" method-to-str

(every-pred method? (complement static?))))

\(defn -main

\[cls & \_\]

\(try

\(-\>\> cls

(Class/forName)

(cr/reflect)

(:members)

(print-all-members))

\(catch Exception e

\(println

\(str/join \"\"

\[\"Error: \"

(-\>\> e (.getClass) (.getName))

\": \"

(.getMessage e)\])))))

#strong[]

#strong[Отладка]

Программа получает на вход полное имя класса и выводит в поток
стандартного вывода список его полей и
методов.#box(image("./assets/10000001000008CE00000716168EA845.png", height: 5.228in, width: 6.4957in))

Рис. 1 -- отладка программы

#strong[Вывод]

В ходе работы были приобретены теоретические и практические навыки
работы с рефлексией в языке программирования Clojure и была разработана
программа, позволяющая исследовать функционал какого-либо класса.
