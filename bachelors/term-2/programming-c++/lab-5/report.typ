#import "../common.typ": *

#show: report.with(number: "5", title: "Наследование классов")

= Цель работы

- Использовать наследование классов.

= Задание

+ Создать базовый класс согласно индивидуальному заданию.

+ Создать два производных от него класса согласно индивидуальному заданию

Требования к базовому классу:

- члены-данные должны быть общими для обоих производных классов и иметь защищённый спецификатор
  доступа;

- два конструктора (по умолчанию и с параметрами) и деструктор.

- чисто виртуальная функция просмотра состояния;

== Вариант 9

Создать иерархическую систему классов:

- базовым классом должен быть абстрактный класс «Жидкость» (`CLiquid`);

- производными классами должны стать классы «Спирт» (`CAlcohol`) и «Бензин» (`CPetrol`).

При этом:

- в базовом классе `CLiquid` должны быть заданы поля для названия и плотности.

- в производном классе `CAlcohol` должно быть задано поля для хранения крепости (основная
  характеристика жидкости);

- в производном классе `CPetrol` должно быть задано поля для хранения октанового числа (основная
  характеристика жидкости);

- все классы иерархии должны иметь следующие методы: методы получения значения и задания основной
  характеристики жидкости (два последних метода должны быть чисто виртуальными в базовом классе), а
  также метод для выведения на экран основных характеристик (данный метод должен быть чисто
  виртуальным).

= Используемые средства

В качестве интегрированной среды разработки использовалась JetBrains CLion.

Для работы в консоли с потоками ввода-вывода использовалась стандартная библиотека `<iostream>`.

= UML-диаграмма программы

#figure(
  caption: "UML-диаграмма программы",
  image("./assets/uml-diagram.png", width: 80%),
)

= Код программы

#code-file(read("./src/main.cpp"), name: "main.cpp")

#code-file(read("./src/liquids/BaseLiquid.h"), name: "liquids/BaseLiquid.h")

#code-file(read("./src/liquids/BaseLiquid.cpp"), name: "liquids/BaseLiquid.cpp")

#code-file(read("./src/liquids/AlcoholDrink.h"), name: "liquids/AlcoholDrink.h")

#code-file(read("./src/liquids/AlcoholDrink.cpp"), name: "liquids/AlcoholDrink.cpp")

#code-file(read("./src/liquids/FizzyDrink.h"), name: "liquids/FizzyDrink.h")

#code-file(read("./src/liquids/FizzyDrink.cpp"), name: "liquids/FizzyDrink.cpp")

#code-file(read("./src/liquids/Petrol.h"), name: "liquids/Petrol.h")

#code-file(read("./src/liquids/Petrol.cpp"), name: "liquids/Petrol.cpp")

= Тестовые примеры

#figure(
  caption: "Результат выполнения программы",
  image("./assets/console-output.png", width: 90%),
)
