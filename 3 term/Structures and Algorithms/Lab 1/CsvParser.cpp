#include <sstream>
#include <regex>
#include "CsvParser.h"

Csv CsvParser::parse(std::istream &istream) {
    std::string buf;
    std::getline(istream, buf);

    auto headers = split(buf);
    Csv csv(headers);

    while(!std::getline(istream, buf).eof()) {
        csv.append(split(buf));
    }

    return csv;
}

std::vector<std::string> CsvParser::split(const std::string& str) {
    std::vector<std::string> result;

    std::vector<size_t> commas = get_commas(str);

    if(commas.empty()) {
        result.push_back(str);
        return result;
    }

    result.push_back(str.substr(0, commas[0]));

    for(int i = 0; i < commas.size() - 1; i++) {
        result.push_back(str.substr(commas[i] + 1, commas[i + 1] - commas[i] - 1));
    }
    result.push_back(str.substr(commas.back() + 1));

    for(auto &s : result) {
        s = process_quotes(s);
    }

    return result;
}

std::vector<size_t> CsvParser::get_commas(const std::string &str) {
    std::vector<size_t> result;
    bool opened_quote = false;
    for(size_t i = 0; i < str.size(); i++) {
        if(str[i] == ',' && !opened_quote)
            result.push_back(i);
        else if(str[i] == '\"')
            opened_quote = !opened_quote;
    }
    return result;
}

std::string CsvParser::process_quotes(std::string str) {
    str = std::regex_replace(str, std::regex(R"(^"|"$)"), "");
    str = std::regex_replace(str, std::regex(R"(\"")"), "\"");
    return str;
}
