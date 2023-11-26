#include "strs.h"

#include <algorithm>
#include <cstddef>

template <typename T>
T min3(T v1, T v2, T v3) {
    return std::min(v1, std::min(v2, v3));
}

std::string tail(std::string x) { return x.substr(0, x.size() - 1); }

size_t l_distance_naive(std::string a, std::string b) {
    if (a.size() == 0) {
        return b.size();
    } else if (b.size() == 0) {
        return a.size();
    } else if (a[a.size() - 1] == b[b.size() - 1]) {
        return l_distance_naive(tail(a), tail(b));
    } else {
        return 1 + min3(l_distance_naive(tail(a), b),
                        l_distance_naive(a, tail(b)),
                        l_distance_naive(tail(a), tail(b)));
    }
}

size_t l_distance(std::string a, std::string b) {
    auto v0 = new size_t[b.size() + 1];
    auto v1 = new size_t[b.size() + 1];

    for (size_t i = 0; i <= b.size(); i++) {
        v0[i] = i;
    }

    for (size_t i = 0; i < a.size(); i++) {
        v1[0] = i + 1;
        for (size_t j = 0; j < b.size(); j++) {
            auto deletion_cost = v0[j + 1] + 1;
            auto insertion_cost = v1[j] + 1;
            auto substitution_cost = a[i] == b[j] ? v0[j] : v0[j] + 1;

            v1[j + 1] = min3(deletion_cost, insertion_cost, substitution_cost);
        }
        std::swap(v0, v1);
    }

    delete[] v0;
    delete[] v1;
    return v0[b.size()];
}
