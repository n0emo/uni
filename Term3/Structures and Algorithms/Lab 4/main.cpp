#include <array>
#include <codecvt>
#include <cstddef>
#include <functional>
#include <iostream>
#include <locale>

#include "strs.h"

int main() {
    std::wbuffer_convert<std::codecvt_utf8<wchar_t>> conv_out(
        std::cout.rdbuf());
    std::wostream out(&conv_out);

    // std::array<std::string, 5> as = {"book", "apple", "kitten", "lol",
    //                                  "smal str"};
    // std::array<std::string, 5> bs = {"back", "appel", "sitting", "xd",
    //                                  "big string"};
    //
    // for (size_t i = 0; i < as.size(); i++) {
    //     auto result_naive = l_distance_naive(as[i], bs[i]);
    //     auto result_optimal = l_distance(as[i], bs[i]);
    //
    //     out << "Strings: \"" << as[i] << "\", \"" << bs[i] << "\"\n";
    //     out << "Results: naive = " << result_naive
    //               << ", optimal = " << result_optimal << std::endl;
    // }
    // substr_index_rk<std::hash<std::wstring>>(L"xdxdaaxdaabmwxdadxd", L"bmw");
    // out << substr_index_rk(L"xdxdaaxdaabmwxdadxd", L"bmw").value() <<
    // std::endl;
    //
    // std::wstring s = L"abcdabcabcdabcdab";
    // auto result = prefix_f(s);
    // for (auto n : result) {
    //     out << n << " ";
    // }
    // out << std::endl;

    // std::string s = "aaaabmwaabmwaaaabmw";
    // auto result = substr_index_kmp(s, "bmw");
    // for (auto n : result) {
    //     out << n << " ";
    // }
    // out << std::endl;

    std::wstring a = L"абвгд";
    std::wstring b = L"ооовг";
    out << lcs(a, b) << std::endl;
    out << lcs(a, b).size() << std::endl;

    // out << L"日本国" << std::endl;
    // std::wstring a = L"гипнотизёр";
    // std::wstring b = L"гипноз";
    // out << l_distance(a, b) << std::endl;
    // out << l_distance_naive(a, b) << std::endl;

    return 0;
}
