#include <iostream>
#include <fstream>
#include <chrono>
#include "App.h"
#include "CsvParser.h"


int App::run() {
    std::cout << "Enter task number:\n"
              << "1 - sort a CSV file\n"
              << "2 - test all sorts with a CSV file\n"
              << std::flush;

    unsigned int task;
    std::cin >> task;
    std::cout << std::flush;

    switch (task) {
        case 1:
            sort_file();
            break;
        case 2:
            test_all_sorts();
            break;
        default:
            std::cout << "Unrecognized task number.";
            return 1;
    }

    return 0;
}

void App::sort_file() {
    auto params = get_user_params();

    params.csv.sort(params.field, SortOptions(params.mode, params.reverse, default_sort));

    auto output_path = get_path("Enter a path to file where sorted data needs to be stored");
    std::ofstream output_file(output_path);

    output_file << params.csv.to_string();
    output_file.close();
}

void App::test_all_sorts() {
    auto params = get_user_params();

    std::vector<Csv> csvs;
    for (int i = 0; i < sorts.size(); i++) {
        csvs.emplace_back(params.csv);
    }

    for (int i = 0; i < sorts.size(); i++) {
        test_sort(params, sorts[i], csvs[i]);
    }

}

void App::test_sort(App::UserParams &params, App::Sort &sort, Csv &csv) {
    std::cout << "Testing: " << sort.name << '\n';
    auto start = std::chrono::high_resolution_clock::now();
    csv.sort(params.field, SortOptions(params.mode, params.reverse, sort.func));
    auto end = std::chrono::high_resolution_clock::now();
    auto seconds = std::chrono::duration_cast<std::chrono::duration<double>>(end - start);
    std::cout << "Sorted for " << seconds << " seconds\n";
}

App::UserParams App::get_user_params() {
    return UserParams{
            .csv = get_csv(),
            .field = get_field(),
            .reverse = get_reverse(),
            .mode = get_mode(),
    };
}

Csv App::get_csv() {
    auto path = get_path("Enter a path to CSV file");

    std::cout << "Reading file." << std::endl;
    std::ifstream csv_stream(path);
    CsvParser parser;
    Csv csv = parser.parse(csv_stream);

    return csv;
}

std::string App::get_field() {
    std::cout << "Enter field name:" << std::endl;
    std::string field;
    std::getline(std::cin, field);

    return field;
}

bool App::get_reverse() {
    std::cout << "Perform reverse sort? [y/n]:" << std::flush;
    bool reverse = prompt();

    return reverse;
}

bool App::prompt() {
    std::string answer;
    while (answer != "y" && answer != "Y" &&
           answer != "n" && answer != "N") {
        std::cin >> answer;
    }

    if (answer == "y" || answer == "Y") return true;
    return false;
}

sort_mode App::get_mode() {
    std::cout << "Enter mode (1-3):\n"
              << "1 - string\n"
              << "2 - integer\n"
              << "3 - floating\n"
              << std::flush;
    unsigned int mode;
    std::cin >> mode;
    switch (mode) {
        case 1:
            return string;
        case 2:
            return integer;
        case 3:
            return floating;
        default:
            return string;
    }
}

void App::add_sort(const char *name,
                   void (*func)(str_vec *, str_vec *, std::function<int(App::str_vec &, App::str_vec &)>)) {
    sorts.emplace_back(name, func);
}

App::App() {
    default_sort = heap_sort;
}

std::string App::get_path(const char* prompt) {
    std::cout << prompt << std::endl;
    std::string path;
    std::cin.ignore(100, '\n');
    std::getline(std::cin, path);
    return path;
}

void App::set_default_sort(void (*func)(str_vec *, str_vec *, std::function<int(App::str_vec &, App::str_vec &)>)) {
    default_sort = func;
}
