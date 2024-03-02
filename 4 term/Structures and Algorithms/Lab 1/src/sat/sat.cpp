#include "lexer.hpp"

#include "tree.hpp"
#include <iostream>
#include <variant>

void print_indent(size_t depth)
{
    for (size_t i = 0; i < depth; i++)
    {
        std::cout << "  ";
    }
}

void print_tree(const std::unique_ptr<Node> &root, size_t depth)
{
    if (auto *r = std::get_if<NodeLeaf>(root.get()))
    {
        print_indent(depth);
        std::cout << r->tok.str() << '\n';
    }
    else if (auto *r = std::get_if<NodeUnOp>(root.get()))
    {
        print_indent(depth);
        std::cout << r->operation.str() << '\n';
        print_tree(r->operand, depth + 1);
    }
    else if (auto *r = std::get_if<NodeBinOp>(root.get()))
    {
        print_tree(r->left_operand, depth + 1);
        print_indent(depth);
        std::cout << r->operation.str() << '\n';
        print_tree(r->right_operand, depth + 1);
    }
}

//
// void simplify(ExpressionTree *root)
// {
//     if (root->type == NODE_LEAF)
//         return;
//     if (root->type == NODE_UN_OP)
//         return;
//
//     if (root->as.binary.operation.type == OP_OR)
//     {
//         simplify(root->as.binary.left_operand);
//         simplify(root->as.binary.right_operand);
//         return;
//     }
// }
//
// void get_leafs(ExpressionTree *root, Tokens *output)
// {
//     if (root->type == NODE_LEAF)
//     {
//         da_append(*output, root->as.leaf);
//     }
//     else if (root->type == NODE_UN_OP)
//     {
//         get_leafs(root->as.unary.operand, output);
//     }
//     else
//     {
//         get_leafs(root->as.binary.right_operand, output);
//         get_leafs(root->as.binary.left_operand, output);
//     }
// }
//
// void multiply(ExpressionTree *left, ExpressionTree *right)
// {
//     simplify(left);
//     simplify(right);
//
//     Tokens left_term = {0};
//     Tokens right_term = {0};
// }

int main()
{
    const char *data = "1&x1 | !( !x2 | x3&!0) | x3 & x2";
    Lexer lex(data);

    auto tokens = std::get<std::vector<Token>>(lex.get_all_tokens());
    printf("Input:\n");
    for (size_t i = 0; i < tokens.size(); i++)
    {
        auto ts = tokens[i].str();
        printf("%s ", ts.c_str());
    }
    printf("\n\n");

    auto tree = Tree::build_tree(tokens);
    printf("AST:\n");
    print_tree(tree, 0);

    return 0;
}
