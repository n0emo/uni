#include <fstream>
#include <cassert>
#include <functional>
#include <sstream>
#include <cstring>
#include "Csv.h"

Csv::Csv(std::vector<std::string> &headers)  {
    this->data = std::make_unique<std::vector<std::vector<std::string>>>();
    this->headers = std::make_unique<std::vector<std::string>>(headers);
}

size_t Csv::rows() {
    return data->size();
}

size_t Csv::cols() {
    return headers->size();
}

void Csv::append(const std::vector<std::string>& row) {
    if(row.size() != cols()) throw std::exception();
    data->push_back(row);
}

void Csv::sort(const std::string& field_name, sort_mode mode) {
    size_t index = 3;
    auto begin = data->begin().base();
    auto end = data->end().base();

    std::function<int(std::vector<std::string>&, std::vector<std::string>&)> cmp;
    switch (mode) {
        case string:
            cmp = [index](auto &a, auto &b) {
               return a[index] < b[index];
            };
            break;
        case number:
            cmp = [index](auto &a, auto &b) { return (int)(std::stof(a[index]) - std::stof(b[index]));};

    }

    quick_sort(begin, end, cmp);
    // std::sort(data->begin(), data->end(), cmp);
}
