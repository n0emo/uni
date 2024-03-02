#ifndef TREE_HPP
#define TREE_HPP

#include "token.hpp"
#include <memory>
#include <optional>
#include <variant>
#include <vector>

struct NodeLeaf;
struct NodeUnOp;
struct NodeBinOp;
typedef std::variant<NodeLeaf, NodeUnOp, NodeBinOp> Node;

struct NodeLeaf
{
    Token tok;
    NodeLeaf(Token tok) : tok(tok)
    {
    }
};

struct NodeUnOp
{
    Token operation;
    std::unique_ptr<Node> operand;
    NodeUnOp(Token operation, std::unique_ptr<Node> operand) : operation(operation), operand(std::move(operand))
    {
    }
};

struct NodeBinOp
{
    Token operation;
    std::unique_ptr<Node> left_operand;
    std::unique_ptr<Node> right_operand;
    NodeBinOp(Token operation, std::unique_ptr<Node> left_operand, std::unique_ptr<Node> right_operand)
        : operation(operation), left_operand(std::move(left_operand)), right_operand(std::move(right_operand))
    {
    }
};

struct Tree
{
    std::unique_ptr<Node> root;

    static std::unique_ptr<Node> build_tree(const std::vector<Token> &tokens);
    static std::optional<size_t> find_root(const std::vector<Token> &tokens);
};

#endif // TREE_HPP
