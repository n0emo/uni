#include "tree.hpp"
#include <climits>
#include <cstddef>
#include <memory>

std::unique_ptr<Node> Tree::build_tree(const std::vector<Token> &tokens)
{
    auto root = find_root(tokens);

    if (!root.has_value())
    {
        size_t non_brace = 0;
        while (tokens[non_brace].type == TOK_OB || tokens[non_brace].type == TOK_CB)
        {
            non_brace++;
        }

        return std::make_unique<Node>(NodeLeaf(tokens[non_brace]));
    }
    else if (tokens[*root].type == OP_NOT)
    {
        std::vector<Token> child_tokens;
        for (size_t i = *root + 1; i < tokens.size(); i++)
        {
            child_tokens.emplace_back(tokens[i]);
        }
        return std::make_unique<Node>(NodeUnOp(tokens[*root], build_tree(child_tokens)));
    }
    else
    {
        std::vector<Token> left;
        for (size_t i = 0; i < *root; i++)
        {
            left.emplace_back(tokens[i]);
        }

        std::vector<Token> right;
        for (size_t i = *root + 1; i < tokens.size(); i++)
        {
            right.emplace_back(tokens[i]);
        }

        return std::make_unique<Node>(NodeBinOp(tokens[*root], build_tree(left), build_tree(right)));
    }
}

std::optional<size_t> Tree::find_root(const std::vector<Token> &tokens)
{
    ssize_t last_1_prec = -1; // !
    ssize_t last_1_brace = SSIZE_MAX;

    ssize_t last_2_prec = -1; // &
    ssize_t last_2_brace = SSIZE_MAX;

    ssize_t last_3_prec = -1; // |
    ssize_t last_3_brace = SSIZE_MAX;

    ssize_t braces_count = 0;

    for (size_t i = 0; i < tokens.size(); i++)
    {
        switch (tokens[i].type)
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

    if (last_1_prec == -1 && last_2_prec == -1 && last_3_prec == -1)
        return std::nullopt;

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
