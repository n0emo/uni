#ifndef STRS_H
#define STRS_H

#include <cstddef>
#include <cstdint>
#include <optional>
#include <string>
#include <vector>

struct PolynomialHash {
    size_t window = INT32_MAX;
    size_t prime = 31;

    size_t operator()(const std::string& s) const {
        size_t hash = 0;
        size_t pow = 1;
        for (size_t i = 0; i < s.size(); i++) {
            hash = ((hash + s[i]) * pow) % window;
            pow = (pow * prime) % window;
        }

        return hash;
    }
};

template <typename THash = PolynomialHash>
std::optional<size_t> substr_index_rk(const std::string& str,
                                      const std::string& substr);

std::vector<size_t> prefix_f(const std::string& s);

std::vector<size_t> substr_index_kmp(const std::string& str,
                                     const std::string& substr);

std::string lcs(const std::string& a, const std::string& b);

size_t l_distance_naive(std::string a, std::string b);

size_t l_distance(const std::wstring& a, const std::wstring& b);

#endif  // STRS_H