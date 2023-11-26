#include "strs.h"

#include <algorithm>
#include <cstddef>
int l_distance_naive(const char* a, std::size_t a_size, const char* b,
                     size_t b_size) {
    if (a_size == 0) {
        return b_size;
    } else if (b_size == 0) {
        return a_size;
    } else if (a[a_size - 1] == b[b_size - 1]) {
        return l_distance_naive(a, a_size - 1, b, b_size - 1);
    } else {
        return 1 + std::min(l_distance_naive(a, a_size - 1, b, b_size),
                            std::min(l_distance_naive(a, a_size, b, b_size - 1),
                                     l_distance_naive(a, a_size - 1, b,
                                                      b_size - 1)));
    }
}
