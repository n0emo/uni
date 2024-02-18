#include <assert.h>
#include <ctype.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define SKIPPABLE " \n\r"

typedef struct
{
    const char *data;
    size_t pos;
} Lexer;

typedef enum
{
    TOK_AND,
    TOK_OR,
    TOK_NOT,
    TOK_OB,
    TOK_CB,
    TOK_X,
    TOK_1,
    TOK_0,
    TOK_INVALID
} TokenType;

typedef struct
{
    TokenType type;
    size_t x_num;
} Token;

#define INVALID_TOKEN                                                                                                  \
    (Token)                                                                                                            \
    {                                                                                                                  \
        .type = TOK_INVALID, .x_num = 0                                                                                \
    }

Token next_token(Lexer *lex)
{
    const char *cur = lex->data + lex->pos;
    while (*cur != 0 && strchr(SKIPPABLE, *cur) != NULL)
    {
        cur++;
        lex->pos++;
    }

    if (*cur == 0)
        return INVALID_TOKEN;

    Token tok;
    switch (*cur)
    {
    case '&':
        tok.type = TOK_AND;
        break;
    case '|':
        tok.type = TOK_OR;
        break;
    case '!':
        tok.type = TOK_NOT;
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
        const char *d_cur = cur;
        tok.type = TOK_X;
        while (isdigit(*(d_cur + 1)))
            d_cur++;

        if (d_cur == cur)
        {
            tok.x_num = 0;
            break;
        }

        ptrdiff_t len = d_cur - cur;
        char *x_num_str = malloc(sizeof(char) * (len + 1));
        strncpy(x_num_str, cur + 1, len);
        x_num_str[len] = 0;
        tok.x_num = atoi(x_num_str);
        free(x_num_str);

        lex->pos += len;
    }
    break;
    default:
        return INVALID_TOKEN;
    }
    lex->pos++;
    return tok;
}

void print_token(Token tok)
{
    char c;
    switch (tok.type)
    {
    case TOK_AND:
        c = '&';
        break;
    case TOK_OR:
        c = '|';
        break;
    case TOK_NOT:
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
    case TOK_INVALID:
        c = 'E';
        break;
    }
    putchar(c);
    if (tok.type == TOK_X)
        printf("%zu", tok.x_num);
}

int main()
{
    const char *data = "1&x1 | !x2 | (x3&!0) | x3 ";
    printf("%s\n", data);
    Lexer lex = {.data = data, .pos = 0};

    Token tok;
    while ((tok = next_token(&lex)).type != TOK_INVALID)
    {
        print_token(tok);
        printf(" ");
    }
    printf("\n");
    return 0;
}
