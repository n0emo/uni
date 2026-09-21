#ifndef LAB_3_EMPLOYEECINFACTORY_H
#define LAB_3_EMPLOYEECINFACTORY_H

#include <array>
#include <vector>
#include "EmployeeFactory.h"

// "Консольная" фабрика работников, реализующая интерфейс EmployeeFactory
class EmployeeCinFactory : public EmployeeFactory {
public:
    std::unique_ptr<std::vector<EmployeeBase*>> get_employees() override;

    EmployeeBase* get_employee() override;

private:
    int get_type_number();

    StandardEmployee* get_standard();

    Trainee* get_trainee();

    Boss* get_boss();

    Beneficiary* get_beneficiary();
};

#endif //LAB_3_EMPLOYEECINFACTORY_H
