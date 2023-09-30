#ifndef CPP_LAB_1_CSVPARSER_H
#define CPP_LAB_1_CSVPARSER_H


#include "Csv.h"

class CsvParser {
private:
    static std::vector<std::string> split(const std::string& str);

    static std::vector<size_t> get_commas(const std::string& str);

    static std::string process_quotes(std::string str);
public:
    Csv parse(std::istream &istream);

    std::ostream& write_to(std::ostream &ostream, Csv csv);
};


#endif //CPP_LAB_1_CSVPARSER_H
