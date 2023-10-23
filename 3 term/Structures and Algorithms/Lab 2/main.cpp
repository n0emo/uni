#include <bits/iterator_concepts.h>

#include <iostream>
#include <iterator>

#include "containers/ArrayList.h"

// #include "containers/all.h"

int main() {
    static_assert(std::random_access_iterator<ArrayList<int>::iterator>);

    auto array_list = std::make_unique<ArrayList<int>>();

    array_list->add(42);
    array_list->add(-9);
    array_list->add(22);
    array_list->add(1);
    array_list->add(41);
    array_list->add(87);
    array_list->add(2);
    array_list->add(-42);
    array_list->add(5);
    array_list->add(12);

    array_list->trim_excess();

    ArrayList<int> list_2;
    list_2.add(9);
    list_2.add(8);
    list_2.add(7);

    array_list->add_range<ArrayList<int>::iterator>(list_2.begin(),
                                                    list_2.end());

    for (auto n : *array_list) {
        std::cout << n << " ";
    }
    std::cout << std::endl;

    std::sort(array_list->begin(), array_list->end());

    for (auto n : *array_list) {
        std::cout << n << " ";
    }
    std::cout << std::endl;

    return 0;
}
