#include <fstream>
#include <cassert>
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
    assert(row.size() == cols());
    data->push_back(row);
}

