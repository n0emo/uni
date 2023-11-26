#include <cstddef>
#include <iostream>
#include "strs.h"

int main() {
    std::cout << "Hello, World!\n";
    const char* a = "kitten";
    size_t a_size = 6;
    const char* b = "sitting";
    size_t b_size = 7;

    int result = l_distance_naive(a, a_size, b, b_size);
    std::cout << result << std::endl;
    return 0;
}
