#include <sstream>
#include <string>

// Базовая структура работника
struct EmployeeBase {
    // string поля имени и фамилии
    std::string name;
    std::string surname;

    // Абстрактный метод вычисления зарплаты работника
    // по его характеристикам. Переопределяется в
    // дочерних структурах (я не знаю как их обязать его
    // переопределять, в C++ нет ключевого слова abstract...)
    virtual int evaluate_salary() = 0;

    // Абстрактный метод преобразования характеристик структуры в string
    virtual std::string to_string() = 0;
};

// Дочерняя структура стандартного работника
struct StandardEmployee : public EmployeeBase {
    int salary;

    explicit StandardEmployee(int salary) {
        this->salary = salary;
    }

    std::string to_string() override {
        std::stringstream stringstream;
        stringstream
            << "Standard employee "
            << name << " " << surname
            << ". Overall salary: "
            << salary;
        return std::string(stringstream.str());
    }

    int evaluate_salary() override {
        return salary;
    }
};

// Дочерняя структура стажёра
struct Trainee : public EmployeeBase {
    int hours;
    int salary_per_hour;

    Trainee(int hours, int salary_per_hour) {
        this->hours = hours;
        this->salary_per_hour = salary_per_hour;
    }

    std::string to_string() override {
        std::stringstream stringstream;
        stringstream
            << "Trainee "
            << name << " " << surname
            << ". Hours: " << hours
            << ", salary per hour: " << salary_per_hour
            << ". Overall salary: " << evaluate_salary();
        return std::string(stringstream.str());
    }

    int evaluate_salary() override {
        return hours * salary_per_hour;
    }
};

// Дочерняя структура начальника
struct Boss : public EmployeeBase {
    int salary_base;
    int employees_count;
    int salary_per_employee;

    Boss(int salary_base, int employees_count, int salary_per_employee) {
        this->salary_base = salary_base;
        this->employees_count = employees_count;
        this->salary_per_employee = salary_per_employee;
    }

    std::string to_string() override {
        std::stringstream stringstream;
        stringstream
            << "Boss "
            << name << " " << surname
            << ". Salary base: " << salary_base
            << ", employees count: " << employees_count
            << ", salary per employee: " << salary_per_employee
            << ". Overall salary: " << evaluate_salary();
        return std::string(stringstream.str());
    }

    int evaluate_salary() override {
        return salary_base + employees_count * salary_per_employee;
    }
};

// Дочерняя структура льготника
struct Beneficiary : public EmployeeBase {
    int salary;
    int percent;

    Beneficiary(int salary, int percent) {
        this->salary = salary;
        this->percent = percent;
    }

    std::string to_string() override {
        std::stringstream stringstream;
        stringstream
            << "Beneficiary "
            << name << " " << surname
            << ". Salary: " << salary
            << ", percent: " << percent << '%'
            << ". Overall salary: " << evaluate_salary();
        return std::string(stringstream.str());
    }

    int evaluate_salary() override {
        return (int)(salary * (1 + percent * 0.01));
    }
};
