#include <fstream>
#include <iostream>
#include <string>
#include <vector>

#include "sort.h"
#include "CsvParser.h"


int main() {
    auto cmp = *[](int a, int b) { return a - b; };
    bool ask_for_path = false;
    std::string input_path = "/home/albert/Downloads/people-5.csv";
    std::string output_path = "/home/albert/output.csv";
    CsvParser parser;

    if (ask_for_path) {
        std::cout << "Enter a path to file with data that needs to be sorted:\n";
        std::cin >> input_path;
    }

    std::ifstream input_file(input_path);
    auto csv = parser.parse(input_file);

    csv.sort("xd", string);

    std::ofstream output_file(output_path);
    if (ask_for_path) {
        std::cout << "Enter a path to file where sorted data needs to be stored\n";
        std::cin >> output_path;
    }

    output_file << csv.to_string();

    input_file.close();
    output_file.close();

    return 0;
}
