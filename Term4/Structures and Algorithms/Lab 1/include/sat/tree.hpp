#ifndef TREE_HPP
#define TREE_HPP

#include "token.hpp"
#include <memory>
#include <optional>
#include <variant>
#include <vector>

struct Tree;

struct Var;
typedef bool Const;

typedef std::variant<Var, Const> NodeLeaf;
struct NodeUnOp;
struct NodeBinOp;
struct NodeOp;
typedef std::variant<NodeLeaf, NodeUnOp, NodeBinOp, NodeOp> Node;

void print_indent(size_t depth);
std::optional<size_t> find_root(const std::vector<Token> &tokens);
std::unique_ptr<Node> build_tree_node(const std::vector<Token> &tokens);
void normilize_node(std::unique_ptr<Node> &node);
void simplify_normilized(std::unique_ptr<Node> &node);
std::unique_ptr<Node> and_open_parentheses_2(
    const std::unique_ptr<Node> &a,
    const std::unique_ptr<Node> &b);

struct Tree
{
    std::unique_ptr<Node> root;

    void print(const std::unique_ptr<Node> &root = nullptr, size_t depth = 0) const;
    void normalize();
    void simplify();

    static Tree build_tree(const std::vector<Token> &tokens);
};

struct Var
{
    int num;
    bool inverse;
};

struct NodeUnOp
{
    Token operation;
    std::unique_ptr<Node> operand;
};

struct NodeBinOp
{
    Token operation;
    std::unique_ptr<Node> left_operand;
    std::unique_ptr<Node> right_operand;
};

struct NodeOp
{
    Token operation;
    std::vector<std::unique_ptr<Node>> operands;

    NodeOp(Token operation)
        : operation(operation)
    {
    }

    NodeOp(Token operation, std::vector<std::unique_ptr<Node>> operands)
        : operation(operation), operands(std::move(operands))
    {
    }

    NodeOp(Token operation, std::unique_ptr<Node> a, std::unique_ptr<Node> b)
        : operation(operation)
    {
        this->operands = std::vector<std::unique_ptr<Node>>();
        this->operands.emplace_back(std::move(a));
        this->operands.emplace_back(std::move(b));
    }
};

#endif // TREE_HPP
