#ifndef CPP_LAB_1_CSV_H
#define CPP_LAB_1_CSV_H

#include <memory>
#include <vector>
#include "sort.h"
#include "SortOptions.h"

class Csv {
public:
    std::unique_ptr<std::vector<std::vector<std::string>>> data;
    std::unique_ptr<std::vector<std::string>> headers;

public:
    explicit Csv(std::vector<std::string> &headers);

    Csv(const Csv &csv);

    size_t rows() const;

    size_t cols() const;

    void append(const std::vector<std::string> &row);

    std::vector<std::string> *begin_ptr() {
        return data->begin().base();
    }

    std::vector<std::string> *end_ptr() {
        return data->end().base();
    }

    void sort(const std::string& field_name, SortOptions options = SortOptions());

    std::string to_string();
};


#endif //CPP_LAB_1_CSV_H
