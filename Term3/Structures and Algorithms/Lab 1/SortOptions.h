#ifndef CPP_LAB_1_SORTOPTIONS_H
#define CPP_LAB_1_SORTOPTIONS_H


#include <vector>
#include "Csv.h"

enum sort_mode {
    integer,
    string,
    floating,
};

class SortOptions {
public:
    sort_mode mode;
    bool reverse;
    void(*sorting_function)
            (std::vector<std::string> *, std::vector<std::string> *,
             std::function<int(std::vector<std::string> &, std::vector<std::string> &)>);

    explicit SortOptions(
            sort_mode _mode = string,
            bool _reverse = false,
            void(*_sorting_function)
                    (std::vector<std::string> *, std::vector<std::string> *,
                     std::function<int(std::vector<std::string> &, std::vector<std::string> &)>)
            = quick_sort) {
        mode = _mode;
        reverse = _reverse;
        sorting_function = _sorting_function;
    }
};


#endif //CPP_LAB_1_SORTOPTIONS_H
