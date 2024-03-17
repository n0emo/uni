#include "tree.hpp"
#include <cassert>
#include <iostream>

void Tree::print(const std::unique_ptr<Node> &root, size_t depth) const
{
    const std::unique_ptr<Node> &node = root ? root : this->root;

    if (auto *r = std::get_if<NodeLeaf>(node.get()))
    {
        print_indent(depth);
        if (auto var = std::get_if<Var>(r))
            std::cout << (var->inverse ? "!" : "") << "x" << var->num << '\n';
        else if (auto con = std::get_if<Const>(r))
            std::cout << *con << '\n';
    }
    else if (auto *r = std::get_if<NodeUnOp>(node.get()))
    {
        print_indent(depth);
        std::cout << r->operation.str() << '\n';
        print(r->operand, depth + 1);
    }
    else if (auto *r = std::get_if<NodeBinOp>(node.get()))
    {
        print(r->left_operand, depth + 1);
        print_indent(depth);
        std::cout << r->operation.str() << '\n';
        print(r->right_operand, depth + 1);
    }
    else if (auto *r = std::get_if<NodeOp>(node.get()))
    {
        print_indent(depth);
        std::cout << r->operation.str() << '\n';
        for (const auto &operand : r->operands)
        {
            print(operand, depth + 1);
        }
    }
}

void Tree::normalize()
{
    normilize_node(root);
}

void Tree::simplify()
{
    normalize();
}

Tree Tree::build_tree(const std::vector<Token> &tokens)
{
    return Tree{build_tree_node(tokens)};
}

void print_indent(size_t depth)
{
    for (size_t i = 0; i < depth; i++)
    {
        std::cout << "  ";
    }
}

std::optional<size_t> find_root(const std::vector<Token> &tokens)
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

std::unique_ptr<Node> build_tree_node(const std::vector<Token> &tokens)
{
    auto root = find_root(tokens);

    if (!root.has_value())
    {
        size_t non_brace = 0;
        while (tokens[non_brace].type == TOK_OB || tokens[non_brace].type == TOK_CB)
        {
            non_brace++;
        }

        Token tok = tokens[non_brace];
        switch (tok.type)
        {
        case TOK_X:
            return std::make_unique<Node>(Var(tok.x_num, false));
        case TOK_1:
            return std::make_unique<Node>(Const(true));
        case TOK_0:
            return std::make_unique<Node>(Const(false));
        default:
            assert(0 && "Bad leaf type");
        }
    }
    else if (tokens[*root].type == OP_NOT)
    {
        std::vector<Token> child_tokens;
        for (size_t i = *root + 1; i < tokens.size(); i++)
        {
            child_tokens.emplace_back(tokens[i]);
        }
        return std::make_unique<Node>(NodeUnOp(tokens[*root], build_tree_node(child_tokens)));
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

        return std::make_unique<Node>(NodeBinOp(tokens[*root], build_tree_node(left), build_tree_node(right)));
    }
}

void normilize_node(std::unique_ptr<Node> &node)
{
    if (std::get_if<NodeLeaf>(node.get()))
        return;

    if (auto op = std::get_if<NodeUnOp>(node.get()))
    {
        assert(op->operation.type == OP_NOT);
        if (auto leaf = std::get_if<NodeLeaf>(op->operand.get()))
        {
            if (auto var = std::get_if<Var>(leaf))
                var->inverse = !var->inverse;
            else if (auto con = std::get_if<Const>(leaf))
                *con = !(*con);

            node = std::move(op->operand);
        }
        else
        {
            normilize_node(op->operand);
        }
    }

    if (auto op = std::get_if<NodeBinOp>(node.get()))
    {
        // There is no implication, so all binary operations
        // are any term number operations.
        auto new_node = std::make_unique<Node>(NodeOp(
            op->operation,
            std::move(op->left_operand),
            std::move(op->right_operand)));
        node = std::move(new_node);
    }

    if (auto op = std::get_if<NodeOp>(node.get()))
    {
        std::vector<std::unique_ptr<Node>> new_operands;
        for (auto &o : op->operands)
        {
            normilize_node(o);

            auto o1 = std::get_if<NodeOp>(o.get());
            if (o1 && o1->operation.type == op->operation.type)
            {
                for (auto &o2 : o1->operands)
                {
                    new_operands.emplace_back(std::move(o2));
                }
            }
            else
            {
                new_operands.emplace_back(std::move(o));
            }
        }

        op->operands = std::move(new_operands);
    }
}

void simplify_normilized(std::unique_ptr<Node> &node)
{
    auto o = std::get_if<NodeOp>(node.get());
    if (!o)
        return;

    if (o->operation.type == OP_OR || o->operation.type == OP_AND)
    {
        for (auto &o1 : o->operands)
        {
            simplify_normilized(o1);
        }
    }

    if (o->operation.type == OP_AND)
    {
    }
}

// std::unique_ptr<Node> and_open_parentheses_2(
//     const std::unique_ptr<Node> &a,
//     const std::unique_ptr<Node> &b)
//
// {
//     NodeOp result(OP_AND);
//
//     auto a1 = std::get_if<NodeOp>(a.get());
//     auto b1 = std::get_if<NodeOp>(b.get());
//
//     return std::make_unique<Node>(std::move(result));
// }
