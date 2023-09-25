#include <fstream>
#include <iostream>
#include <string>
#include <vector>

#include "sort.h"

// TODO: create CSV parser

int main() {
    bool ask_for_path = false;
    std::string input_path = "/home/albert/input.txt";
    std::string output_path = "/home/albert/output.txt";

    if (ask_for_path) {
        std::cout << "Enter a path to file with data that needs to be sorted:\n";
        std::cin >> input_path;
    }

    std::ifstream input_file(input_path);
    std::ofstream output_file(output_path);

    auto cmp = *[](int a, int b) { return a - b; };

    std::vector<int> data;
    int input;
    while (input_file >> input) {
        data.push_back(input);
    }

    quick_sort(data.begin().base(), data.end().base(), cmp);

    std::cout << "Sorted.\n";
    std::cout << std::endl;

    if (ask_for_path) {
        std::cout << "Enter a path to file where sorted data needs to be stored\n";
        std::cin >> output_path;
    }

    for (auto n: data) {
        output_file << n << '\n';
    }

    input_file.close();
    output_file.close();

    return 0;
}
