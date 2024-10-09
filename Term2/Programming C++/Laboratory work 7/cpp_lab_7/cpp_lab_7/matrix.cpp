#include "matrix.h"

#include <cmath>
#include "determinant.h"

#define DETERMINANT_NOT_CALCULATED "1"

matrix::matrix()
{
    m_matrix = std::make_unique<vec2d>();
    m_determinant = std::nan(DETERMINANT_NOT_CALCULATED);
}

matrix::matrix(const vec2d& vec)
{
    if (!check_vec(vec))throw -1;
    m_matrix = std::make_unique<vec2d>(vec);
    m_determinant = std::nan(DETERMINANT_NOT_CALCULATED);
}

matrix::matrix(const matrix& matrix)
{
    m_matrix = std::make_unique<vec2d>();
    for (size_t i = 0; i < matrix.get_rows(); i++)
    {
        std::vector<double> row;
        for (size_t j = 0; j < matrix.get_cols(); j++)
        {
            row.push_back((*matrix.m_matrix)[i][j]);
        }
        m_matrix->push_back(row);
    }

    m_determinant = matrix.m_determinant;
}

matrix::~matrix() = default;

std::ostream& operator<<(std::ostream& os, const matrix& matrix)
{
    for (size_t i = 0; i < matrix.get_rows(); i++)
    {
        for (size_t j = 0; j < matrix.get_cols(); j++)
        {
            os << (*matrix.m_matrix)[i][j] << " ";
        }
        os << '\n';
    }
    return os;
}

std::istream& operator>>(std::istream& is, matrix& m)
{
    m.m_matrix = std::make_unique<std::vector<std::vector<double>>>();
    size_t rows, cols;
    is >> rows >> cols;
    for(size_t i = 0; i < rows; i++)
    {
        std::vector<double> row_vec;
        for(size_t j = 0; j < cols; j++)
        {
            double tmp;
            is >> tmp;
            row_vec.push_back(tmp);
        }
        m.m_matrix->push_back(row_vec);
    }
    
    return is;
    
}

bool matrix::check_vec(const vec2d& vec)
{
    if (vec.empty()) return false;
    const size_t rowSize = vec[0].size();
    for (const auto& row : vec)
    {
        if (row.size() != rowSize) return false;
    }

    return true;
}

matrix::Row matrix::operator[](size_t index) const
{
    if (index >= get_rows() || index < 0) throw -1;
    return Row((*m_matrix)[index]);
}

double matrix::Row::operator[](size_t index) const
{
    if (index >= m_vec.size() || index < 0) throw -1;
    return m_vec[index];
}

bool operator==(const matrix& matrix_a, const matrix& matrix_b)
{
    if (matrix_a.get_rows() != matrix_b.get_rows() || matrix_a.get_cols() != matrix_b.get_cols()) return false;

    for (size_t i = 0; i < matrix_a.get_rows(); i++)
    {
        for (size_t j = 0; j < matrix_a.get_cols(); j++)
        {
            if ((*matrix_a.m_matrix)[i][j] != (*matrix_b.m_matrix)[i][j]) return false;
        }
    }

    return true;
}

matrix operator+(const matrix& matrix_a, const matrix& matrix_b)
{
    if (matrix_a.get_rows() != matrix_b.get_rows() || matrix_a.get_cols() != matrix_b.get_cols())
        throw -1;

    vec2d newVec;
    for (size_t i = 0; i < matrix_a.get_rows(); i++)
    {
        std::vector<double> row;
        for (size_t j = 0; j < matrix_a.get_cols(); j++)
        {
            row.push_back((*matrix_a.m_matrix)[i][j] + (*matrix_b.m_matrix)[i][j]);
        }
        newVec.push_back(row);
    }

    return newVec;
}

matrix operator-(const matrix& matrix_a, const matrix& matrix_b)
{
    if (matrix_a.get_rows() != matrix_b.get_rows() || matrix_a.get_cols() != matrix_b.get_cols())
        throw -1;

    vec2d newVec;
    for (size_t i = 0; i < matrix_a.get_rows(); i++)
    {
        std::vector<double> row;
        for (size_t j = 0; j < matrix_a.get_cols(); j++)
        {
            row.push_back((*matrix_a.m_matrix)[i][j] - (*matrix_b.m_matrix)[i][j]);
        }
        newVec.push_back(row);
    }

    return newVec;
}

matrix operator*(const matrix& matrix_a, double num)
{
    vec2d newVec;
    for (size_t i = 0; i < matrix_a.get_rows(); i++)
    {
        std::vector<double> row;
        for (size_t j = 0; j < matrix_a.get_cols(); j++)
        {
            row.push_back((*matrix_a.m_matrix)[i][j] * num);
        }
        newVec.push_back(row);
    }

    return newVec;
}

matrix operator*(const matrix& matrix_a, const matrix& matrix_b)
{
    if (matrix_a.get_rows() != matrix_b.get_cols()) throw -1;

    vec2d newVec;
    for (size_t i = 0; i < matrix_a.get_rows(); i++)
    {
        std::vector<double> row;
        for (size_t j = 0; j < matrix_b.get_rows(); j++)
        {
            row.push_back(matrix::get_prod_elem(*matrix_a.m_matrix, *matrix_b.m_matrix, i, j));
        }
        newVec.push_back(row);
    }
    
    return newVec;
}

double matrix::get_prod_elem(const vec2d& vec_a, const vec2d& vec_b, const size_t row, const size_t col)
{
    double element = 0;
    for (size_t i = 0; i < vec_b.size(); i++)
    {
        element += vec_a[row][i] * vec_b[i][col];
    }

    return element;
}

double matrix::get_determinant()
{
    if (std::isnan(m_determinant))
    {
        if (get_rows() != get_cols()) throw -1;
        m_determinant = eval_determ();
    }
    return m_determinant;
}

double matrix::eval_determ() const
{
    const auto matrix_array = new double*[get_rows()];
    for (size_t i = 0; i < get_rows(); i++)
    {
        matrix_array[i] = new double[get_rows()];
        for (size_t j = 0; j < get_rows(); j++)
        {
            matrix_array[i][j] = (*m_matrix)[i][j];
        }
    }

    const double det = eval_determinant(matrix_array, get_rows());

    for (size_t i = 0; i < get_rows(); i++)
    {
        delete matrix_array[i];
    }
    delete[] matrix_array;

    return det;
}
