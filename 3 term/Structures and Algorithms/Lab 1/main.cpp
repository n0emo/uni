#include <fstream>
#include <iostream>
#include <string>
#include <vector>
#include <chrono>

#include "sort.h"
#include "CsvParser.h"

void sort_file();

void test_all_sorts();

struct Sort {
    typedef std::vector<std::string> T;
    std::string name;
    void(*func)(T*, T*, std::function<int(T&, T&)>);
    Sort(const char* _name, void(*_func)(T*, T*, std::function<int(T&, T&)>)) {
        name = _name;
        func = _func;
    }
};

std::vector<Sort> sorts = {
        Sort("Selection sort", selection_sort),
        Sort("Bubble sort",bubble_sort),
        Sort("Insertion sort",insertion_sort),
        Sort("Merge sort",merge_sort),
        Sort("Heap sort", heap_sort),
        Sort("Quick sort", quick_sort),
};

int main() {
    test_all_sorts();
    return 0;
}

void sort_file() {
    bool ask_for_path = false;
    std::string input_path = "/home/albert/Downloads/people.csv";
    std::string output_path = "/home/albert/output.csv";
    CsvParser parser;

    if (ask_for_path) {
        std::cout << "Enter a path to file with data that needs to be sorted:\n";
        std::cin >> input_path;
    }

    std::ifstream input_file(input_path);
    auto csv = parser.parse(input_file);
    auto csv2(csv);

    csv2.sort("Index", SortOptions(floating, true, merge_sort));
    //csv2.sort("User Id");

    std::ofstream output_file(output_path);
    if (ask_for_path) {
        std::cout << "Enter a path to file where sorted data needs to be stored\n";
        std::cin >> output_path;
    }

    output_file << csv2.to_string();

    input_file.close();
    output_file.close();
}

void test_all_sorts() {
    std::cout << "Testing all sorts.\nEnter a path to CSV file:" << std::endl;
    std::string path;
    std::getline(std::cin, path);

    std::cout << "Enter field name:" << std::endl;
    std::string name;
    std::getline(std::cin, name);

    std::cout << "Reading file." << std::endl;

    std::ifstream csv_stream(path);
    CsvParser parser;
    Csv csv = parser.parse(csv_stream);

    std::vector<Csv> csvs;
    for(int i = 0; i < sorts.size(); i++) {
        csvs.emplace_back(csv);
    }

    for(int i = 0; i < sorts.size(); i++) {
        std::cout << "Testing: " << sorts[i].name << '\n';
        auto start = std::chrono::high_resolution_clock::now();
        csvs[i].sort(name, SortOptions(string, false, sorts[i].func));
        auto end = std::chrono::high_resolution_clock::now();
        auto seconds = std::chrono::duration_cast<std::chrono::duration<double>>(end - start);
        std::cout << "Sorted for " << seconds << " seconds\n";
    }

}


