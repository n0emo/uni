#pragma once


#include <iostream>
#include <vector>

typedef std::unique_ptr<std::vector<std::vector<double>>> vec2d_ptr;
typedef std::vector<std::vector<double>> vec2d;

class matrix {
public:
    matrix();
    
    matrix(const vec2d& vec);

    matrix(const matrix& matrix);

    ~matrix();

    friend bool operator ==(const matrix& matrix_a, const matrix& matrix_b);
    friend bool operator !=(const matrix& matrix_a, const matrix& matrix_b) { return !(matrix_a == matrix_b); }
    friend matrix operator +(const matrix& matrix_a, const matrix& matrix_b);
    friend matrix operator -(const matrix& matrix_a, const matrix& matrix_b);
    friend matrix operator *(const matrix& matrix_a, double num);
    friend matrix operator *(double num, const matrix& matrix) { return matrix * num; }
    friend matrix operator *(const matrix& matrix_a, const matrix& matrix_b);

    friend std::ostream& operator<<(std::ostream& os, const matrix& m);
    friend std::istream& operator>>(std::istream& is, matrix& m);

    size_t get_rows() const { return m_matrix->size(); }
    size_t get_cols() const { return (*m_matrix)[0].size(); }
    double get_determinant();

    class Row {
    public:
        explicit Row(std::vector<double>& vec) : m_vec(vec) {}
        double operator[](size_t index) const;
    private:
        std::vector<double>& m_vec;
    };

    Row operator[](size_t index) const;

private:
    vec2d_ptr m_matrix;
    double m_determinant;

    static bool check_vec(const vec2d& vec);

    static double get_prod_elem(const vec2d& vec_a, const vec2d& vec_b, size_t row, size_t col);

    double eval_determ() const;
};

