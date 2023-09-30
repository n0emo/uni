#ifndef CPP_LAB_1_CSVPARSER_H
#define CPP_LAB_1_CSVPARSER_H


#include "Csv.h"

class CsvParser {
private:
    std::vector<std::string> split(const std::string& str);
public:
    Csv parse(std::istream &istream);
};


#endif //CPP_LAB_1_CSVPARSER_H
