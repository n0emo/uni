#ifndef CPP_LAB_1_CSV_H
#define CPP_LAB_1_CSV_H


#include <memory>
#include <vector>

class Csv {
private:
    std::unique_ptr<std::vector<std::vector<std::string>>> data;
    std::unique_ptr<std::vector<std::string>> headers;

public:
    Csv(std::vector<std::string> &headers);

    size_t rows();
    size_t cols();

    void append(const std::vector<std::string>& row);

    std::vector<std::string>* begin_ptr() {
        return data->begin().base();
    }

    std::vector<std::string>* end_ptr() {
        return data->end().base();
    }
};


#endif //CPP_LAB_1_CSV_H
