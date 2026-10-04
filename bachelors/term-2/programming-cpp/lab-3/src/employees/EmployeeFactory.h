#ifndef LAB_3_EMPLOYEEFACTORY_H
#define LAB_3_EMPLOYEEFACTORY_H

#include <vector>
#include <memory>

#include "employees.cpp"

// Интерфейс фабрики работников. Ключевого слова interface в C++
// нет, и Я не знаю как заставить дочерние классы переопределять эти
// чистые виртуальные методы. Как я понял, если не переопределить,
// то просто нельзя будет создать объект дочернего класса.
class EmployeeFactory {
public:
    // Получить много работников
    virtual std::unique_ptr<std::vector<EmployeeBase*>> get_employees() = 0;

    //получить одного работника
    virtual EmployeeBase* get_employee() = 0;
};


#endif //LAB_3_EMPLOYEEFACTORY_H
