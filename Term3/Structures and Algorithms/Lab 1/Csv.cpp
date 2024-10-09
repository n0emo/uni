#include <fstream>
#include <functional>
#include <sstream>
#include <regex>
#include "Csv.h"

Csv::Csv(std::vector<std::string> &headers)  {
    this->data = std::make_unique<std::vector<std::vector<std::string>>>();
    this->headers = std::make_unique<std::vector<std::string>>(headers);
}

size_t Csv::rows() const {
    return data->size();
}

size_t Csv::cols() const {
    return headers->size();
}

#pragma clang diagnostic push
#pragma ide diagnostic ignored "readability-make-member-function-const"
void Csv::append(const std::vector<std::string>& row) {
    if(row.size() != cols()) throw std::exception();
    data->push_back(row);
}
#pragma clang diagnostic pop

#pragma clang diagnostic push
#pragma ide diagnostic ignored "readability-make-member-function-const"
void Csv::sort(const std::string& field_name, SortOptions options) {
    int index = -1;

    for(int i = 0; i < cols(); i++) {
        if((*headers)[i] == field_name) {
            index = i;
            break;
        }
    }

    if(index == -1) throw std::exception();

    auto begin = begin_ptr();
    auto end = end_ptr();
    auto mode = options.mode;
    auto sort_f = options.sorting_function;
    auto sign = options.reverse ? -1 : 1;

    std::function<int(std::vector<std::string>&, std::vector<std::string>&)> cmp;
    switch (mode) {
        case string:
            cmp = [index, sign](auto &a, auto &b) {
               return a[index].compare(b[index]) * sign;
            };
            break;
        case floating:
            cmp = [index, sign](auto &a, auto &b) {
                auto res = (std::stof(a[index]) - std::stof(b[index])) * sign;
                if(res > 0) return 1;
                if(res < 0) return -1;
                return 0;
            };
            break;
        case integer:
            cmp = [index, sign](auto &a, auto &b) {
                return (std::stol(a[index]) - std::stol(b[index])) * sign;
            };
            break;
        default:
            throw std::exception();
    }

    sort_f(begin, end, cmp);
}

std::string add_quotes(std::string& str) {
    str = std::regex_replace(str, std::regex(R"(\")"), "\"\"");
    if(str.find(',') != std::string::npos || str.find('\"') != std::string::npos) {
        str = '\"' + str + '\"';
    }
    return str;
}

std::string Csv::to_string() {
    std::stringstream stream;

    auto col = cols();

    for(int i = 0; i < col; i++) {
        stream << add_quotes((*headers)[i]) << ',';
    }
    stream.seekp(-1, std::ios::end);
    stream << '\n';

    for(auto row : *data) {
        for(int i = 0; i < col; i++) {
            stream << add_quotes((row)[i]) << ',';
        }
        stream.seekp(-1, std::ios::end);
        stream << '\n';
    }

    return stream.str();
}

Csv::Csv(const Csv &csv) {
    headers = std::make_unique<std::vector<std::string>>(*csv.headers);
    data = std::make_unique<std::vector<std::vector<std::string>>>(*csv.data);
}

#pragma clang diagnostic pop
