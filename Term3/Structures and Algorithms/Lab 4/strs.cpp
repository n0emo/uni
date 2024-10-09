#include "strs.h"

#include <algorithm>
#include <functional>
#include <iostream>
#include <sstream>

PolynomialHash::Powers::Powers() {
    _vec[0] = 1;
    for (size_t i = 1; i < INITIAL_SIZE; i++) {
        _vec[i] = _vec[i - 1] * PRIME;
    }
}

size_t PolynomialHash::Powers::operator[](size_t index) {
    if (index >= _size) {
        expand();
    }
    return _vec[index];
}

void PolynomialHash::Powers::expand() {
    size_t new_size = _size * 2;
    _vec.resize(new_size);
    for (size_t i = 0; i < new_size - _size; i++) {
        _vec[_size + i] = _vec[_size + i - 1] * PRIME;
    }
    _size = new_size;
}

size_t PolynomialHash::operator()(const std::wstring& s) const {
    size_t hash = 0;
    for (size_t i = 0; i < s.size(); i++) {
        hash = (hash + s[i]) * powers[i];
    }
    return hash;
}

template <typename THash = PolynomialHash>
size_t str_hash(const std::wstring& str, size_t start = 0,
                size_t count = SIZE_MAX) {
    if (count == SIZE_MAX) {
        count = str.size();
    }

    return THash{}(str.substr(start, count));
}

template <typename T>
T min3(T v1, T v2, T v3) {
    return std::min(v1, std::min(v2, v3));
}

std::wstring tail(std::wstring x) { return x.substr(0, x.size() - 1); }

template <typename THash>
std::optional<size_t> substr_index_rk(const std::wstring& str,
                                      const std::wstring& substr) {
    size_t substr_size = substr.size();
    size_t str_size = str.size();
    if (substr_size > str_size) {
        return std::nullopt;
    }

    size_t substr_hash = str_hash<THash>(substr);

    for (size_t i = 0; i < str_size - substr_size; i++) {
        size_t hash = str_hash<THash>(str, i, substr_size);
        if (hash == substr_hash && str.substr(i, substr_size) == substr) {
            return std::optional(i);
        }
    }

    return std::nullopt;
}

std::vector<size_t> prefix_f(const std::wstring& s) {
    size_t size = s.size();
    std::vector<size_t> result(size);

    for (size_t i = 1; i < size; i++) {
        size_t max_prefix = result[i - 1];
        while (max_prefix > 0 && s[max_prefix] != s[i]) {
            max_prefix = result[max_prefix - 1];
        }
        if (s[max_prefix] == s[i]) {
            max_prefix++;
        }
        result[i] = max_prefix;
    }

    return result;
}

std::vector<size_t> substr_index_kmp(const std::wstring& str,
                                     const std::wstring& substr) {
    auto prefix = prefix_f(str);
    std::vector<size_t> a;
    for (size_t i = 0, k = 0; i < str.size(); i++) {
        while (k > 0 && str[i] != substr[k]) {
            k = prefix[k - 1];
        }
        if (str[i] == substr[k]) {
            k++;
        }
        if (k == substr.size()) {
            a.emplace_back(i - substr.size() + 1);
            k = prefix[k];
        }
    }
    return a;
}

std::wstring lcs(const std::wstring& a, const std::wstring& b) {
    std::wstringstream ss;
    auto steps = new size_t[a.size() * b.size()];
    size_t z = 0;
    for (size_t i = 0; i < a.size(); i++) {
        for (size_t j = 0; j < b.size(); j++) {
            if (a[i] == b[j]) {
                if (i == 0 || j == 0) {
                    steps[i + j * a.size()] = 1;
                } else {
                    steps[i + j * a.size()] =
                        steps[i - 1 + (j - 1) * a.size()] + 1;
                }
                if (steps[i + j * a.size()] > z) {
                    z = steps[i + j * a.size()];
                    ss = std::wstringstream(a.substr(i - z + 1, z));
                } else if (steps[i + j * a.size()] == z) {
                    ss << a.substr(i - z + 1, z);
                }
            } else {
                steps[i + j * a.size()] = 0;
            }
        }
    }

    delete[] steps;
    return ss.str();
}

size_t l_distance_naive(std::wstring a, std::wstring b) {
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

size_t l_distance(const std::wstring& a, const std::wstring& b) {
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

template std::optional<size_t> substr_index_rk<PolynomialHash>(
    const std::wstring& str, const std::wstring& substr);

template std::optional<size_t> substr_index_rk<std::hash<std::wstring>>(
    const std::wstring& str, const std::wstring& substr);
