#include "da.h"
#include <ctype.h>
#include <limits.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>

#define SKIPPABLE " \n\r"
#define MIN(x, y) (x < y ? x : y)

typedef struct
{
    const char *data;
    size_t pos;
} Lexer;

typedef enum
{
    OP_AND,
    OP_OR,
    OP_NOT,
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

typedef struct
{
    Token *items;
    size_t count;
    size_t capacity;
} Tokens;

typedef enum
{
    NODE_UN_OP,
    NODE_BIN_OP,
    NODE_LEAF
} NodeType;

typedef struct ExpressionTree
{
    NodeType type;
    union {
        Token leaf;
        struct
        {
            Token operation;
            struct ExpressionTree *operand;
        } unary;
        struct
        {
            Token operation;
            struct ExpressionTree *left_operand;
            struct ExpressionTree *right_operand;
        } binary;
    } as;
} ExpressionTree;

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
    case TOK_INVALID:
        c = 'E';
        break;
    }
    putchar(c);
    if (tok.type == TOK_X)
        printf("%zu", tok.x_num);
}

ssize_t find_root(Tokens *tokens)
{
    ssize_t last_1_prec = -1; // !
    ssize_t last_1_brace = SSIZE_MAX;

    ssize_t last_2_prec = -1; // &
    ssize_t last_2_brace = SSIZE_MAX;

    ssize_t last_3_prec = -1; // |
    ssize_t last_3_brace = SSIZE_MAX;

    ssize_t braces_count = 0;

    for (size_t i = 0; i < tokens->count; i++)
    {
        switch (tokens->items[i].type)
        {
        case OP_NOT:
            if (braces_count <= last_1_brace)
            {
                last_1_prec = i;
                last_1_brace = braces_count;
            }
            break;
        case OP_AND:
            if (braces_count <= last_2_brace)
            {
                last_2_prec = i;
                last_2_brace = braces_count;
            }
            break;
        case OP_OR:
            if (braces_count <= last_3_brace)
            {
                last_3_prec = i;
                last_3_brace = braces_count;
            }
            break;
        case TOK_OB:
            braces_count++;
            break;
        case TOK_CB:
            braces_count--;
            break;
        default:
            break;
        }
    }

    ssize_t min_prec = last_1_prec;
    ssize_t min_brace = last_1_brace;

    if (last_2_brace <= min_brace)
    {
        min_prec = last_2_prec;
        min_brace = last_2_brace;
    }
    if (last_3_brace <= min_brace)
    {
        min_prec = last_3_prec;
        min_brace = last_3_brace;
    }

    return min_prec;
}

ExpressionTree *build_tree(Tokens *tokens)
{
    ExpressionTree *tree = malloc(sizeof(ExpressionTree));
    ssize_t root = find_root(tokens);

    if (root == -1)
    {
        size_t non_brace = 0;
        while (tokens->items[non_brace].type == TOK_OB || tokens->items[non_brace].type == TOK_CB)
        {
            non_brace++;
        }

        tree->type = NODE_LEAF;
        tree->as.leaf = tokens->items[non_brace];
    }
    else if (tokens->items[root].type == OP_NOT)
    {
        tree->type = NODE_UN_OP;
        tree->as.unary.operation = tokens->items[root];

        Tokens child_tokens = {0};
        for (size_t i = root + 1; i < tokens->count; i++)
        {
            da_append(child_tokens, tokens->items[i]);
        }

        tree->as.unary.operand = build_tree(&child_tokens);
        free(child_tokens.items);
    }
    else
    {
        tree->type = NODE_BIN_OP;
        tree->as.binary.operation = tokens->items[root];

        Tokens child_tokens = {0};
        for (ssize_t i = 0; i < root; i++)
        {
            da_append(child_tokens, tokens->items[i]);
        }

        tree->as.binary.left_operand = build_tree(&child_tokens);

        child_tokens.count = 0;
        for (size_t i = root + 1; i < tokens->count; i++)
        {
            da_append(child_tokens, tokens->items[i]);
        }
        tree->as.binary.right_operand = build_tree(&child_tokens);

        free(child_tokens.items);
    }

    return tree;
}

void print_indent(size_t depth)
{
    for (size_t i = 0; i < depth; i++)
    {
        printf("  ");
    }
}

void print_tree(ExpressionTree *root, size_t depth)
{
    switch (root->type)
    {
    case NODE_LEAF:
        print_indent(depth);
        print_token(root->as.leaf);
        printf("\n");
        break;
    case NODE_UN_OP:
        print_indent(depth);
        print_token(root->as.unary.operation);
        printf("\n");
        print_tree(root->as.unary.operand, depth + 1);
        break;
    case NODE_BIN_OP:
        print_tree(root->as.binary.left_operand, depth + 1);
        print_indent(depth);
        print_token(root->as.binary.operation);
        printf("\n");
        print_tree(root->as.binary.right_operand, depth + 1);
        break;
    }
}

int main()
{
    const char *data = "1&x1 | !( !x2 | x3&!0) | x3 & x2";
    Lexer lex = {.data = data, .pos = 0};

    Token tok;
    Tokens tokens = {0};
    while ((tok = next_token(&lex)).type != TOK_INVALID)
    {
        da_append(tokens, tok);
    }

    printf("Input:\n");
    for (size_t i = 0; i < tokens.count; i++)
    {
        print_token(tokens.items[i]);
        printf(" ");
    }
    printf("\n\n");

    printf("AST:\n");
    ExpressionTree *tree = build_tree(&tokens);
    print_tree(tree, 0);

    return 0;
}
