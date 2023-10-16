#include "containers/ArrayList.h"
#include <iostream>

// #include "containers/all.h"

int main() {
    auto array_list = std::make_unique<ArrayList<int>>();

    array_list->add(1);
    array_list->add(2);
    array_list->add(3);
    array_list->add(4);
    array_list->add(5);
    array_list->add(6);
    array_list->add(7);
    array_list->add(8);
    array_list->add(9);
    array_list->add(10);
    array_list->add(11);
    array_list->add(12);
    array_list->add(13);
    array_list->add(14);
    array_list->add(15);
    array_list->add(16);
    array_list->add(17);
    array_list->add(18);

    std::cout << "Capacity is " << array_list->capacity() << std::endl;

    for (int i = 0; i < array_list->count(); i++) {
	std::cout << (*array_list)[i] << " ";
    }

    std::cout << *(array_list->binary_search(10)) << std::endl;

    std::cout << std::endl;
    return 0;
}
