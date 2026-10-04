#include "matrix.h"

#include <cmath>
#include "determinant.h"

#define DETERMINANT_NOT_CALCULATED "1"

Matrix::Matrix(const vec2d& vec) {
    if(!check_vec(vec)) {
        exit(-1);
    }
    m_matrix = (vec);

    m_determinant = std::nan(DETERMINANT_NOT_CALCULATED);
}

Matrix::Matrix(Matrix &matrix) {
    for(int i = 0; i < matrix.getRows(); i++) {
        std::vector<double> row;
        for(int j = 0; j < matrix.getCols(); j++) {
            row.push_back(matrix.m_matrix[i][j]);
        }
        m_matrix.push_back(row);
    }

    m_determinant = matrix.m_determinant;
}

Matrix::~Matrix() = default;

std::ostream &operator<<(std::ostream &os, const Matrix &matrix) {
    for(int i = 0; i < matrix.getRows(); i++) {
        for(int j = 0; j < matrix.getCols(); j++) {
            os << matrix.m_matrix[i][j] << " ";
        }
        os << '\n';
    }
    return os;
}

bool Matrix::check_vec(const vec2d& vec) {
    if (vec.empty()) return false;
    size_t rowSize = vec[0].size();
    for(const auto& row : vec) {
        if(row.size() != rowSize) return false;
    }

    return true;
}

Matrix::Row Matrix::operator[](int index) {
    if(index >= getRows() || index < 0) exit(-1);
    return Row(m_matrix[index]);
}

double Matrix::Row::operator[](int index) {
    if(index >= m_vec.size() || index < 0) exit(-1);
    return m_vec[index];
}

bool operator==(const Matrix &matrix_a, const Matrix &matrix_b) {
    if(matrix_a.getRows() != matrix_b.getRows() || matrix_a.getCols() != matrix_b.getCols()) return false;

    for(int i = 0; i < matrix_a.getRows(); i++) {
        for(int j = 0; j < matrix_a.getCols(); j++) {
            if(matrix_a.m_matrix[i][j] != matrix_b.m_matrix[i][j]) return false;
        }
    }

    return true;
}

Matrix operator+(const Matrix &matrix_a, const Matrix &matrix_b) {
    if(matrix_a.getRows() != matrix_b.getRows() || matrix_a.getCols() != matrix_b.getCols())
        exit(-1);

    vec2d newVec;
    for(int i = 0; i < matrix_a.getRows(); i++) {
        std::vector<double> row;
        for(int j = 0; j < matrix_a.getCols(); j++) {
            row.push_back(matrix_a.m_matrix[i][j] + matrix_b.m_matrix[i][j]);
        }
        newVec.push_back(row);
    }

    return Matrix(newVec);
}

Matrix operator-(const Matrix &matrix_a, const Matrix &matrix_b) {
    if(matrix_a.getRows() != matrix_b.getRows() || matrix_a.getCols() != matrix_b.getCols())
        exit(-1);

    vec2d newVec;
    for(int i = 0; i < matrix_a.getRows(); i++) {
        std::vector<double> row;
        for(int j = 0; j < matrix_a.getCols(); j++) {
            row.push_back(matrix_a.m_matrix[i][j] - matrix_b.m_matrix[i][j]);
        }
        newVec.push_back(row);
    }

    return Matrix(newVec);
}

Matrix operator*(const Matrix &matrix, double num) {
    vec2d newVec;
    for(int i = 0; i < matrix.getRows(); i++) {
        std::vector<double> row;
        for(int j = 0; j < matrix.getCols(); j++) {
            row.push_back(matrix.m_matrix[i][j] * num);
        }
        newVec.push_back(row);
    }

    return Matrix(newVec);
}

Matrix operator*(const Matrix &matrix_a, const Matrix &matrix_b) {
    if(matrix_a.getRows() != matrix_b.getCols()) exit(-1);

    vec2d newVec;
    for(int i = 0; i < matrix_a.getRows(); i++) {
        std::vector<double> row;
        for(int j = 0; j < matrix_b.getRows(); j++) {
            row.push_back(Matrix::getProductElement(matrix_a.m_matrix, matrix_b.m_matrix, i, j));
        }
        newVec.push_back(row);
    }

    return Matrix(newVec);
}

double Matrix::getProductElement(vec2d vec_a, vec2d vec_b, int row, int col) {
    double element = 0;
    for(int i = 0; i < vec_b.size(); i++) {
        element += vec_a[row][i] * vec_b[i][col];
    }

    return element;
}

double Matrix::getDeterminant() {
    if(std::isnan(m_determinant)) {
        if(getRows() != getCols()) exit(-1);
        m_determinant = evaluate_determinant();
    };
    return m_determinant;
}

double Matrix::evaluate_determinant() const {
    double** matrix_array = new double*[getRows()];
    for(int i = 0; i < getRows(); i++) {
        matrix_array[i] = new double[getRows()];
        for(int j = 0; j < getRows(); j++) {
            matrix_array[i][j] = m_matrix[i][j];
        }
    }

    double det = eval_determinant(matrix_array, getRows());

    for(int i = 0; i < getRows(); i++) {
        delete matrix_array[i];
    }
    delete[] matrix_array;

    return det;
}
