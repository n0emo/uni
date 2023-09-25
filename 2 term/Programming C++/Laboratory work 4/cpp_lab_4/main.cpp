#include <iostream>
#include <fstream>

#include "matrix.h"

int main() {
    system("color F0");
    std::ifstream fin(R"(D:\University\2 term\Programming C++\Laboratory work 4\cpp_lab_4\matrix.txt)");
    int rows, cols;
    fin >> rows >> cols;
    vec2d vec;
    for(int i = 0; i < rows; i++) {
        std::vector<double> row;
        for(int j = 0; j < cols; j++) {
            int tmp;
            fin >> tmp;
            row.push_back(tmp);
        }
        vec.push_back(row);
    }

    Matrix m1(vec);
    Matrix m2 = m1 + m1;
    Matrix m3 = m1 * m2;

    std::cout << "Matrix m1:\n" << m1 << std::endl;
    std::cout << "Determinant of m1: " << m1.getDeterminant() << std::endl << std::endl;
    std::cout << "m2 = m1 + m1:\n" << std::endl;
    std::cout << "m3 = m1 * m2:\n" << m3 << std::endl;
    std::cout << "Element of m3 at 3 row and 4 column: " << m3[2][3] << std::endl << std::endl;

    system("pause");
    return 0;
}
