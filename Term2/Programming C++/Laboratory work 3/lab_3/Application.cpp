#include <iostream>
#include <iomanip>
#include "Application.h"

// Application решил сильно не усложнять объектно-ориентированной логикой,
// так как в конечном счёте Я интерфейс просто навелосипедил.
void Application::run() {
    if(m_factory == nullptr) {
        std::cout << "EmployeeFactory must be not null!";
        return;
    }

    m_is_running = true;
    while (m_is_running) {
        system("cls");

        show_action_list();
        int action_number;
        std::cin >> action_number;
        perform_action(action_number);

        system("pause");
    }
}

void Application::perform_action(int action_number) {
    system("cls");
    switch (action_number) {
        case 1:
            new_employee_table_action();
            break;
        case 2:
            add_one_employee_action();
            break;
        case 3:
            remove_employee_by_name_action();
            break;
        case 4:
            show_employees_action();
            break;
        case 5:
            show_salaries_action();
            break;
        case 6:
            m_is_running = false;
            break;
        default:
            std::cout << "Wrong action number! Must be from 1 to 4\n";
    }
}

void Application::show_action_list() const {
    std::cout << "Enter action number you want to perform:\n"
          << "1 - new employees table.\n"
          << "2 - add one employee.\n"
          << "3 - remove employee by name.\n"
          << "4 - show all employees.\n"
          << "5 - show only salaries.\n"
          << "6 - exit from program.\n";
}

void Application::new_employee_table_action() {
    m_employees = m_factory->get_employees();
}

void Application::add_one_employee_action() {
    m_employees->push_back(m_factory->get_employee());
}

void Application::show_employees_action() {
    std::cout << "Employees:\n";
    for(int i = 0; i < m_employees->size(); i++) {
        std::cout << i + 1 << ". " << (*m_employees)[i]->to_string() << '\n';
    }
    std::cout << std::endl;
}

void Application::show_salaries_action() {
    long sum = 0;
    std::cout << "Employees salaries:\n" <<
    "n | name                          |     salary\n" <<
    "----------------------------------------------\n";
    for(int i = 0; i < m_employees->size(); i++) {
        int salary = (*m_employees)[i]->evaluate_salary();
        sum += salary;
        std::cout << i + 1 << " | " <<
        std::setw(30) << std::left <<
        (*m_employees)[i]->name + " " + (*m_employees)[i]->surname << "| " <<
        std::setw(10) << std::right <<
       salary << ".\n";
    }
    std::cout << "----------------------------------------------\n" <<
        "Total: " << sum << '\n' << std::endl;
}

void Application::remove_employee_by_name_action() {
    std::cout << "Enter name and surname divided by whitespace:\n";
    std::string name, surname;
    std::cin >> name >> surname;
    int index = -1;
    for(int i = 0; i < m_employees->size(); i++) {
        if((*m_employees)[i]->name == name && (*m_employees)[i]->surname == surname) {
            index = i;
            break;
        }
    }
    if(index != -1) {
        m_employees->erase(m_employees->begin() + index);
        std::cout << "Employee removed successfully.\n";
    } else {
        std::cout << "No employee with this name.\n";
    }
}
