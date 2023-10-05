#include <fstream>
#include <iostream>
#include <string>
#include <vector>
#include <chrono>

#include "sort.h"
#include "CsvParser.h"

struct UserParams {
    Csv csv;
    std::string field;
    bool reverse;
    sort_mode mode;
};

struct Sort {
    typedef std::vector<std::string> T;
    std::string name;
    void(*func)(T*, T*, std::function<int(T&, T&)>);
    Sort(const char* _name, void(*_func)(T*, T*, std::function<int(T&, T&)>)) {
        name = _name;
        func = _func;
    }
};

void sort_file();

void test_all_sorts();

UserParams get_user_params();

Csv get_csv();

std::string get_field();

bool prompt();

bool get_reverse();

sort_mode get_mode();

std::vector<Sort> sorts = {
        Sort("Selection sort", selection_sort),
        Sort("Bubble sort",bubble_sort),
        Sort("Insertion sort",insertion_sort),
        Sort("Merge sort",merge_sort),
        Sort("Heap sort", heap_sort),
        Sort("Quick sort", quick_sort),
};

int main() {
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

void sort_file() {
    auto params = get_user_params();

    params.csv.sort(params.field, SortOptions(params.mode, params.reverse));

    std::string output_path;
    std::cout << "Enter a path to file where sorted data needs to be stored" << std::endl;
    std::cin.ignore(100, '\n');
    std::getline(std::cin, output_path);
    std::ofstream output_file(output_path);

    output_file << params.csv.to_string();
    output_file.close();
}

void test_all_sorts() {
    auto params = get_user_params();

    std::vector<Csv> csvs;
    for(int i = 0; i < sorts.size(); i++) {
        csvs.emplace_back(params.csv);
    }

    for(int i = 0; i < sorts.size(); i++) {
        std::cout << "Testing: " << sorts[i].name << '\n';
        auto start = std::chrono::high_resolution_clock::now();
        csvs[i].sort(params.field, SortOptions(params.mode, params.reverse, sorts[i].func));
        auto end = std::chrono::high_resolution_clock::now();
        auto seconds = std::chrono::duration_cast<std::chrono::duration<double>>(end - start);
        std::cout << "Sorted for " << seconds << " seconds\n";
    }

}

UserParams get_user_params() {
    return UserParams {
            .csv = get_csv(),
            .field = get_field(),
            .reverse = get_reverse(),
            .mode = get_mode(),
    };
}

Csv get_csv() {
    std::cout << "Enter a path to CSV file:\n";
    std::string path;
    std::cin.ignore(100, '\n');
    std::getline(std::cin, path);
    std::cout << "Reading file." << std::endl;
    std::ifstream csv_stream(path);
    CsvParser parser;
    Csv csv = parser.parse(csv_stream);

    return csv;
}

std::string get_field() {
    std::cout << "Enter field name:" << std::endl;
    std::string field;
    std::getline(std::cin, field);

    return field;
}

bool get_reverse() {
    std::cout << "Perform reverse sort? [y/n]:" << std::flush;
    bool reverse = prompt();

    return reverse;
}

bool prompt() {
    std::string answer;
    while (answer != "y" && answer != "Y" &&
           answer != "n" && answer != "N") {
        std::cin >> answer;
    }

    if(answer == "y" || answer == "Y") return true;
    return false;
}

sort_mode get_mode() {
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
};
