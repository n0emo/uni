#include "lexer.hpp"

#include "tree.hpp"

int main()
{
    const char *data = "!!!1 & x1 | !(!x2 | x3 & !0) | x3 & x2";
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
    tree.print();

    tree.normalize();
    printf("\nNormilized:\n");
    tree.print();

    tree.simplify();
    printf("\nSimpified:\n");
    tree.print();

    return 0;
}
