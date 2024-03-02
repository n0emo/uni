#ifndef TOKEN_HPP
#define TOKEN_HPP

#include <cstddef>
#include <string>

enum TokenType
{
    OP_AND,
    OP_OR,
    OP_NOT,
    TOK_OB,
    TOK_CB,
    TOK_X,
    TOK_1,
    TOK_0,
    TOK_EOF,
    TOK_INVALID,
};

struct Token
{
    TokenType type;
    size_t x_num;

    Token() : type(TOK_INVALID), x_num(0)
    {
    }
    Token(TokenType type) : type(type), x_num(0)
    {
    }
    Token(TokenType type, size_t x_num) : type(type), x_num(x_num)
    {
    }

    std::string str() const;
};

#endif // TOKEN_HPP
