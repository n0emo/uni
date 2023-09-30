#ifndef CPP_LAB_1_CSV_H
#define CPP_LAB_1_CSV_H


#include <memory>
#include <vector>
#include "sort.h"

enum sort_mode{
    number,
    string
};

class Csv {
public:
    std::unique_ptr<std::vector<std::vector<std::string>>> data;
    std::unique_ptr<std::vector<std::string>> headers;

public:
    Csv(std::vector<std::string> &headers);

    size_t rows();

    size_t cols();

    void append(const std::vector<std::string> &row);

    std::vector<std::string> *begin_ptr() {
        return data->begin().base();
    }

    std::vector<std::string> *end_ptr() {
        return data->end().base();
    }

    void sort(const std::string& field_name, sort_mode mode);
};


#endif //CPP_LAB_1_CSV_H
