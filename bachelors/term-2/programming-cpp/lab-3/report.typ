#import "../common.typ": *

#show: report.with(number: "3", title: "Структуры и полиморфизм подтипов")

= Цель работы

- Использовать структуры.
- Применить наследование и полиморфизм подтипов.

= Задание

Написать приложение для работы с сотрудниками предприятия. Сотрудники бывают разных видов с разными
характеристиками и способы расчёта зарплаты. В приложении можно создать новый список сотрудников,
добавлять и удалять сотрудников, посчитать зарплату каждого сотрудника и вывести таблицу зарплат с
общей суммой всех зарплат.

= Используемые средства

В качестве интегрированной среды разработки использовалась JetBrains CLion.

Для работы в консоли с потоками ввода-вывода использовалась стандартная библиотека `<iostream>`, а
также библиотека `<iomanip>` инструментов для работы с форматированием.

Для управления памятью используется стандартная библиотека `memory` и умные указатели
(`unique_ptr`).

В программе есть несколько файлов, для сборки проекта использовался CMake в связке с Ninja.

Для создания UML-диаграммы использовался плагин с поддержкой языка разметки PlantUML и отрисовки
диаграммы на основе кода на языке разметки.

= UML-диаграмма программы

#figure(
  caption: "UML-диаграмма программы",
  image("./assets/uml-diagram.png", width: 90%),
)

= Код программы с комментариями

#code-file(read("./src/main.cpp"), name: "main.cpp")

#code-file(read("./src/Application.h"), name: "Application.h")

#code-file(read("./src/Application.cpp"), name: "Application.cpp")

#code-file(read("./src/employees/employees.cpp"), name: "employees/employees.cpp")

#code-file(read("./src/employees/EmployeeFactory.h"), name: "employees/EmployeeFactory.h")

#code-file(read("./src/employees/EmployeeCinFactory.h"), name: "employees/EmployeeCinFactory.h")

#code-file(read("./src/employees/EmployeeCinFactory.cpp"), name: "employees/EmployeeCinFactory.cpp")

= Тестовые примеры

#figure(
  caption: "Меню приложения",
  image("./assets/menu.png", width: 55%),
)

#figure(
  caption: "Создание новой таблицы сотрудников",
  image("./assets/new-employee-table.png", width: 45%),
)

#figure(
  caption: "Добавление одного сотрудника",
  image("./assets/add-employee.png", width: 55%),
)

#figure(
  caption: "Удаление сотрудника из списка",
  image("./assets/remove-employee.png", width: 70%),
)

#figure(
  caption: "Вывод полной информации о всех сотрудниках",
  image("./assets/show-employees.png", width: 90%),
)

#figure(
  caption: "Вывод таблицы зарплат",
  image("./assets/show-salaries.png", width: 75%),
)
