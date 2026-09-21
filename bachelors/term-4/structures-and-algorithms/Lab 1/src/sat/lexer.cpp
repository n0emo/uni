#include "lexer.hpp"
#include <string>
#include <variant>

const std::string skippable(" \n\r");

Lexer::Lexer(const std::string data)
{
    this->data = data;
    this->pos = 0;
}

std::variant<Token, std::string> Lexer::next_token()
{
    while (pos < data.size() && skippable.find(data[pos]) != std::string::npos)
    {
        pos++;
    }

    if (pos >= data.size())
        return Token(TOK_EOF);

    Token tok;
    switch (data[pos])
    {
    case '&':
        tok.type = OP_AND;
        break;
    case '|':
        tok.type = OP_OR;
        break;
    case '!':
        tok.type = OP_NOT;
        break;
    case '(':
        tok.type = TOK_OB;
        break;
    case ')':
        tok.type = TOK_CB;
        break;
    case '1':
        tok.type = TOK_1;
        break;
    case '0':
        tok.type = TOK_0;
        break;
    case 'x': {
        size_t digit_count = 0;
        tok.type = TOK_X;
        while (pos < data.size() && isdigit(data[pos + digit_count + 1]))
            digit_count++;

        if (digit_count == 0)
        {
            tok.x_num = 0;
            break;
        }

        tok.x_num = std::stoi(data.substr(pos + 1, digit_count));

        pos += digit_count;
    }
    break;
    default:
        return "Unexpected symbol";
    }

    pos++;
    return tok;
}

std::variant<std::vector<Token>, std::string> Lexer::get_all_tokens()
{
    std::vector<Token> result;

    std::variant<Token, std::string> tok;
    while (true)
    {
        tok = next_token();
        if (std::holds_alternative<std::string>(tok))
        {
            return std::get<std::string>(tok);
        }

        if (Token t = std::get<Token>(tok); t.type == TOK_EOF)
            break;
        else
            result.emplace_back(t);
    }

    return result;
}
