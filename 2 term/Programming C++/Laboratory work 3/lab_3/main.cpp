#include "Application.h"
#include "employees/EmployeeCinFactory.h"

void set_white_theme() {
    system("color F0");
}

int main() {
    //set_white_theme();
    // Создание нового приложения с фабрикой, которая получает работников из консоли
    auto app = new Application(new EmployeeCinFactory);
    app->run();

    return 0;
}
