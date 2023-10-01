#include <fstream>
#include <iostream>
#include <string>
#include <vector>

#include "sort.h"
#include "CsvParser.h"

void sort_file();
void test_all_sorts();

template<typename T>
struct Sort {
    std::string name;
    void(*func)(T*, T*, std::function<int(T&, T&)>);
    Sort(std::string &_name, void(*_func)(T*, T*, std::function<int(T&, T&)>)) {
        name = _name;
        func = _func;
    }
};

int main() {
    auto cmp = *[](int a, int b) { return a - b; };
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

    return 0;
}
