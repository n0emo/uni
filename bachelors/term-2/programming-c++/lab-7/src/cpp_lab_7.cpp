#include <iostream>
#include <memory>
#include <fstream>

#include "list.h"
#include "matrix.h"
#include "set.h"

int main(int argc, char* argv[])
{
    system("color F0");
    std::ifstream fin("matrices.txt");
    std::unique_ptr<list<matrix>> matrix_list = std::make_unique<list<matrix>>();
    std::unique_ptr<set<matrix>> matrix_set = std::make_unique<set<matrix>>();
    matrix tmp;
    while(!fin.eof())
    {
        fin >> tmp;
        matrix_list->push_back(tmp);
        matrix_set->try_add(tmp);
    }

    std::cout << "List of matrices:\n";
    std::cout << "count: " << matrix_list->size() << '\n';
    for(auto& m : *matrix_list)
    {
        std::cout << m << "\n";
    }

    std::cout << '\n' << "Set of matrices:\n" << "count: " << matrix_set->size() << '\n';
    std::cout << *matrix_set << std::endl;
    
    system("pause");
}
