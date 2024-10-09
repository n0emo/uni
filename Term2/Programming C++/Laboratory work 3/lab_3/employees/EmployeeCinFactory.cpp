#include <iostream>
#include "EmployeeCinFactory.h"
#include "memory.h"

// Я решил реализовать фабрику в функциональном стиле

// Получение вектора работников
std::unique_ptr<std::vector<EmployeeBase*>> EmployeeCinFactory::get_employees() {
    int employee_count;
    std::cout << "Enter employees count\n";
    std::cin >> employee_count;

    // Делаю умный указатель на вектор, пусть он там сам памятью занимается.
    auto employees = std::make_unique<std::vector<EmployeeBase*>>();

    // заполнение вектора
    for (int i = 0; i < employee_count; i++) {
        system("cls");
        std::cout << "Employee " << i + 1 << ":\n";
        employees->push_back(get_employee());
    }

    return employees;
}

EmployeeBase *EmployeeCinFactory::get_employee() {
    EmployeeBase* employee;

    // Имя и фамилия считываются заранее, чтобы избежать дублирование кода,
    // но задаются в самом конце так как структуры на данный момент нет
    auto name = std::string();
    auto surname = std::string();
    std::cout << "Enter name: ";
    std::cin >> name;
    std::cout << "Enter surname: ";
    std::cin >> surname;

    // Получение типа
    std::cout << "Enter type number. Types:\n";
    std::cout << "1 - standard\n" << "2 - trainee\n" << "3 - boss\n" << "4 - beneficiary\n";
    int type_number = get_type_number();

    // Получение сотрудника нужного типа через switch.
    switch (type_number) {
        case 1:
            employee = get_standard();
            break;
        case 2:
            employee = get_trainee();
            break;
        case 3:
            employee = get_boss();
            break;
        case 4:
            employee = get_beneficiary();
            break;
        default:
            // IDE ругается, что я дефолт не учитываю, хотя я его учёл в другой функции.
            exit(1);
    }

    //После получения структуры можно установить имя и фамилию
    employee->name = name;
    employee->surname = surname;

    return employee;
}

// Получение номера типа сотрудника.
int EmployeeCinFactory::get_type_number() {
    int num;
    while(true) {
        std::cout << "Enter type number: ";
        std::cin >> num;
        if(num >= 1 && num <= 4) break;
        else std::cout << "Wrong type number.\n";
    }
    return num;
}

// Методы на каждый тип структуры, работают предельно просто
StandardEmployee* EmployeeCinFactory::get_standard() {
    std::cout << "Enter salary: ";
    int salary;
    std::cin >> salary;
    return new StandardEmployee(salary);
}

Trainee *EmployeeCinFactory::get_trainee() {
    int hours;
    int salary_per_hour;
    std::cout<<"Enter hours count: ";
    std::cin >> hours;
    std::cout << "Enter salary per hour: ";
    std::cin >> salary_per_hour;
    return new Trainee(hours, salary_per_hour);
}

Boss *EmployeeCinFactory::get_boss() {
    int salary_base;
    int employees_count;
    int salary_per_employee;
    std::cout << "Enter salary base: ";
    std::cin >> salary_base;
    std::cout << "Enter employees count ";
    std::cin >> employees_count;
    std::cout << "Enter salary per employee: ";
    std::cin >> salary_per_employee;
    return new Boss(salary_base, employees_count, salary_per_employee);
}

Beneficiary *EmployeeCinFactory::get_beneficiary() {
    int salary;
    int percent;
    std::cout << "Enter salary: ";
    std::cin >> salary;
    std::cout << "Enter percent: ";
    std::cin >>percent;
    return new Beneficiary(salary, percent);
}
