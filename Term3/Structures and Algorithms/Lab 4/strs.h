#ifndef STRS_H
#define STRS_H

#include <cstddef>
#include <cstdint>
#include <optional>
#include <string>
#include <vector>

struct PolynomialHash {
    struct Powers {
        static const size_t INITIAL_SIZE = 1;
        static const size_t PRIME = 31;

        Powers();
        size_t operator[](size_t index);

    private:
        std::vector<size_t> _vec = std::vector<size_t>(INITIAL_SIZE);
        size_t _size = INITIAL_SIZE;

        void expand();
    };

    inline static Powers powers = Powers();
    size_t operator()(const std::wstring& s) const;
};

template <typename THash = PolynomialHash>
std::optional<size_t> substr_index_rk(const std::wstring& str,
                                      const std::wstring& substr);

std::vector<size_t> prefix_f(const std::wstring& s);

std::vector<size_t> substr_index_kmp(const std::wstring& str,
                                     const std::wstring& substr);

std::wstring lcs(const std::wstring& a, const std::wstring& b);

size_t l_distance_naive(std::wstring a, std::wstring b);

size_t l_distance(const std::wstring& a, const std::wstring& b);

#endif  // STRS_H
