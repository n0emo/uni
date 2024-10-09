#include <iostream>
#include <iomanip>
#include <cmath>
#include <string>
#include <array>
#include "windows.h"

// я не знаю что мне тут комментировать
// наверное нет смысла писать,
// что func вычисляет значение функции
// или get_description получает описание таска

// базовый класс Task, который содержит в себе 2 абстрактных метода для переопределения
// и 2 защищённых для вычисления функции
class Task {
public:
    virtual std::string get_description() = 0;

    virtual void execute() = 0;

protected:
    static double func(double argument) {
        argument = trim(argument);
        return (2 + argument * argument) / (1 - argument) * pow(cos(argument), 3);
    }

    static double trim(double argument) {
        if (argument < -10) {
            argument = -10;
        } else if (argument > 10) {
            argument = 10;
        }

        return argument;
    }
};

// задание 1
class FunctionValueCalculation : public Task {
public:
    std::string get_description() override {
        return "Вычислить значение функции в одной точке.";
    }

    void execute() override {
        get_argument();
        evaluate_function();
        output_value();
    }

private:

    double argument = 0;
    double value = 0;
    // по-хорошему бы в конструктор передать указатель на эту функцию, чтобы можно
    // было задать другой вариант ввода значения, но во-первых мне лень,
    // во-вторых это не нужно.
    void get_argument() {
        std::cout << "Введите аргумент функции: ";
        std::cin >> argument;
    }

    // evaluate переводится как вычислить
    void evaluate_function() {
        value = func(argument);
    }

    // возводим объектно-ориентированный подход в абсолют там, где
    // это совсем не нужно.
    // Нам же надо из задачи на 30 строк сделать код на 300 строк, правильно?
    void output_value() const {
        std::cout << "Значение функции: " << value << '\n';
    }
};


// задание 2
class FunctionValueComparison : public Task {
public:
    std::string get_description() override {
        return "Вычислить значение функции в двух точках и найти максимальное значение.";
    }

    void execute() override {
        get_arguments();
        evaluate_max_value();
        output_value();
    }

private:

    double argument_a = 0;
    double argument_b = 0;
    double value = 0;

    void get_arguments() {
        std::cout << "Введите два аргумента: ";
        std::cin >> argument_a >> argument_b;
    }

    void output_value() const {
        std::cout << "Наибольшее значение функции: " << value << '\n';
    }


    void evaluate_max_value() {
        value = std::max(func(argument_a), func(argument_b));
    }
};

// задание 3
class FunctionTableCalculation : public Task {
public:
    std::string get_description() override {
        return "Вычислить таблицу значений функции.";
    }

    void execute() override {
        get_table_args();
        output_table();
    }

private:
    double start = 0;
    double end = 0;
    double step = 0;
    double argument = 0;

    const int OUTPUT_WIDTH = 10;
    const int OUTPUT_PRECISION = 5;

    void get_table_args() {
        std::cout << "Введите начальное значение аргумента: ";
        std::cin >> start;
        std::cout << "Введите конечное значение аргумента: ";
        std::cin >> end;
        std::cout << "Введите шаг аргумента: ";
        std::cin >> step;
    }

    // вывести таблицу
    void output_table() {
        argument = start;
        while (argument <= end) {
            write_table_row();
            argument += step;
        }
    }

    // вывести одну строку таблицы ыы
    void write_table_row() const {
        std::cout << "Значение аргумента:" << std::setw(OUTPUT_WIDTH) << std::setprecision(OUTPUT_PRECISION) << argument;
        std::cout << ", значение функции:" << std::setw(OUTPUT_WIDTH) << std::setprecision(OUTPUT_PRECISION)
                  << func(argument) << '\n';
    }
};

// объявление функций
void enable_russian_text();
void clear();
void display_menu();
void get_task_number();
void execute_task();
void pause();

// массив с тасками, к которому будет применён полиморфизм
std::array<Task *, 3> tasks{new FunctionValueCalculation(), new FunctionValueComparison(),
                            new FunctionTableCalculation(),};
bool is_running = true;
int task_number;

// в данном случае он равен 3 так как в массиве 3 элемента (3 задания в ЛР)
const int EXIT_NUMBER = tasks.size();

// int main() - функция main с типом возвращаемого значение int
int main() {
    enable_russian_text();

    while (is_running) {
        clear();
        display_menu();
        get_task_number();
        execute_task();
        pause();
    }

    return 0;
}

// реализация функций

void enable_russian_text() {
    SetConsoleCP(CP_UTF8);
    SetConsoleOutputCP(CP_UTF8);
}

// это выглядит довольно странно, но во-первых не всегда очевидно что
// такое system("cls"), а во-вторых не хочется мешать уровни абстракции
// внутри одной функции.
void clear() {
    system("cls");
}

void display_menu() {
    std::cout << "Введите номер действия, которое хотите выполнить:\n";

    for (int i = 0; i < tasks.size(); i++) {
        std::cout << i + 1 << " - " << tasks[i]->get_description() << "\n";
    }
    std::cout << EXIT_NUMBER + 1 << " - Выход из программы\n";
}

void get_task_number() {
    std::cin >> task_number;
    task_number--;
}

void execute_task() {
    if (task_number == EXIT_NUMBER) {
        is_running = false;
        return;
    }
    if (task_number < 0 || task_number >= tasks.size()) {
        std::cout << "Неверный номер задание. Попробуйте ещё раз." << std::endl;
        return;
    }
    tasks[task_number]->execute();
}

void pause() {
    system("pause");
}
