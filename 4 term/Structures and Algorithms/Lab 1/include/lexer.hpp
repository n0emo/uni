#ifndef LEXER_HPP
#define LEXER_HPP

#include "token.hpp"
#include <string>
#include <variant>
#include <vector>

struct Lexer
{
    std::string data;
    size_t pos;

    Lexer(const std::string data);

    std::variant<Token, std::string> next_token();
    std::variant<std::vector<Token>, std::string> get_all_tokens();
};

#endif // LEXER_HPP
