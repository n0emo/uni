#include <array>
#include <cstddef>
#include <functional>
#include <iostream>

#include "strs.h"

int main() {
    // std::array<std::string, 5> as = {"book", "apple", "kitten", "lol",
    //                                  "smal str"};
    // std::array<std::string, 5> bs = {"back", "appel", "sitting", "xd",
    //                                  "big string"};
    //
    // for (size_t i = 0; i < as.size(); i++) {
    //     auto result_naive = l_distance_naive(as[i], bs[i]);
    //     auto result_optimal = l_distance(as[i], bs[i]);
    //
    //     std::cout << "Strings: \"" << as[i] << "\", \"" << bs[i] << "\"\n";
    //     std::cout << "Results: naive = " << result_naive
    //               << ", optimal = " << result_optimal << std::endl;
    // }
    // substr_index_rk<std::hash<std::string>>("xdxdaaxdaabmwxdadxd", "bmw");
    // std::cout << substr_index_rk("xdxdaaxdaabmwxdadxd", "bmw").value()
    //           << std::endl;

    // std::string s = "abcdabcabcdabcdab";
    // auto result = prefix_f(s);
    // for (auto n : result) {
    //     std::cout << n << " ";
    // }
    // std::cout << std::endl;

    // std::string s = "aaaabmwaabmwaaaabmw";
    // auto result = substr_index_kmp(s, "bmw");
    // for (auto n : result) {
    //     std::cout << n << " ";
    // }
    // std::cout << std::endl;

    // std::string a = "abcdef";
    // std::string b = "oobcdx";
    // std::cout << lcs(a, b) << std::endl;
    // std::cout << lcs(a, b).size() << std::endl;
    std::wstring a = L"гипнотизёр";
    std::wstring b = L"гипноз";

    std::cout << l_distance(a, b) << std::endl;
    // std::cout << l_distance_naive(a, b) << std::endl;

    return 0;
}
