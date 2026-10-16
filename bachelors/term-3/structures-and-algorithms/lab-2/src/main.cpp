#include <bits/iterator_concepts.h>

#include <iostream>
#include <iterator>
#include <memory>

#include "ArrayList.hpp"

int main() {
    auto array_list = std::make_unique<ArrayList<int>>();

    array_list->add(42);
    array_list->add(-9);
    array_list->add(22);
    array_list->add(1);
    array_list->add(41);
    array_list->add(87);
    array_list->add(2);
    array_list->add(-42);
    array_list->add(23);
    array_list->add(12);

    // array_list->trim_excess();

    for (auto n : *array_list) {
        std::cout << n << " ";
    }
    std::cout << std::endl;

    // auto list2 = std::make_unique<ArrayList<int>>();
    // list2->add(60);
    // list2->add(61);
    // list2->add(62);
    // array_list->insert_range(3, list2->begin(), list2->end());

    array_list->sort();
    std::cout << array_list->binary_search(22).value_or(-1) << std::endl;
    for (auto n : *array_list) {
        std::cout << n << " ";
    }
    std::cout << std::endl;

    return 0;
}
