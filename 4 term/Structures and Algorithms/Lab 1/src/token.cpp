#include "token.hpp"
#include <sstream>

std::string Token::str() const
{
    char c;
    switch (type)
    {
    case OP_AND:
        c = '&';
        break;
    case OP_OR:
        c = '|';
        break;
    case OP_NOT:
        c = '!';
        break;
    case TOK_OB:
        c = '(';
        break;
    case TOK_CB:
        c = ')';
        break;
    case TOK_X:
        c = 'x';
        break;
    case TOK_1:
        c = '1';
        break;
    case TOK_0:
        c = '0';
        break;
    case TOK_EOF:
        c = '\0';
        break;
    case TOK_INVALID:
        c = 'E';
        break;
    }
    std::stringstream ss;
    ss << c;
    if (type == TOK_X)
        ss << x_num;

    return ss.str();
}
