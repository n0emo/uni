
#include <sstream>
#include "CsvParser.h"

Csv CsvParser::parse(std::istream &istream) {
    std::string buf;
    istream >> buf;
    auto headers = split(buf);
    Csv csv(headers);

    while(istream >> buf) {
        csv.append(split(buf));
    }

    return csv;
}

std::vector<std::string> CsvParser::split(const std::string& str) {
    std::vector<std::string> result;
    std::vector<size_t> commas;

    commas.push_back(-1);
    for(int i = 0; i < str.size(); i++) {
        if(str[i] == ',' || str[i] == ';') {
            commas.push_back(i);
        }
    }

    if(commas.size() == 1) {
        result.push_back(str);
        return result;
    }

    for(int i = 0; i < commas.size() - 1; i++) {
        result.push_back(str.substr(commas[i] + 1, commas[i + 1] - commas[i] - 1));
    }
    result.push_back(str.substr(commas.back() + 1));

    return result;
}
