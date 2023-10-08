#include <fstream>
#include <iostream>
#include <string>
#include <vector>
#include <chrono>

#include "sort.h"
#include "CsvParser.h"
#include "App.h"


int main() {
    auto app = std::make_unique<App>();

    app->add_sort("Selection sort", selection_sort);
    app->add_sort("Bubble sort",bubble_sort);
    app->add_sort("Insertion sort",insertion_sort);
    app->add_sort("Merge sort",merge_sort);
    app->add_sort("Heap sort", heap_sort);
    app->add_sort("Quick sort", quick_sort);

    app->set_default_sort(heap_sort);

    int result = app->run();

    return result;
}


