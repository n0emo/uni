#ifndef LAB_3_APPLICATION_H
#define LAB_3_APPLICATION_H

#include "employees/EmployeeFactory.h"
#include "array"
#include "memory"

// Главный класс программы
class Application {
public:
    // У класса application есть всего одно поле, которое задаётся через конструктор.
    // Делать ApplicationBuilder будет избыточно.
    explicit Application(EmployeeFactory* factory) {
        m_factory = std::unique_ptr<EmployeeFactory>(factory);
    }

    // Отправная точка приложения
    void run();

private:
    // Абстрактная фабрика, которая отвечает за получение сотрудников.
    // Это может быть консоль, файл, база данных, api сервера, в
    // зависимости от реализации фабрики
    std::unique_ptr<EmployeeFactory> m_factory = nullptr;
    // Список работников
    std::unique_ptr<std::vector<EmployeeBase*>> m_employees = std::unique_ptr<std::vector<EmployeeBase*>>(new std::vector<EmployeeBase*>);
    bool m_is_running = false;

    void show_action_list() const;

    // action означает один из 5 пунктов в меню приложения.
    void new_employee_table_action();

    void add_one_employee_action();

    void remove_employee_by_name_action();

    void show_employees_action();

    void show_salaries_action();

    void perform_action(int action_number);
};

#endif //LAB_3_APPLICATION_H
