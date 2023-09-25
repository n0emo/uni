#ifndef CPP_LAB_4_MATRIX_H
#define CPP_LAB_4_MATRIX_H


#include <ostream>
#include <utility>
#include <vector>

typedef std::vector<std::vector<double>> vec2d;

class Matrix {
public:
    explicit Matrix(const vec2d& vec);

    Matrix(Matrix& matrix);

    ~Matrix();

    friend std::ostream& operator <<(std::ostream& os, const Matrix& matrix);

    friend bool operator ==(const Matrix& matrix_a, const Matrix& matrix_b);
    friend bool operator !=(const Matrix& matrix_a, const Matrix& matrix_b) { return !(matrix_a == matrix_b); }
    friend Matrix operator +(const Matrix& matrix_a, const Matrix& matrix_b);
    friend Matrix operator -(const Matrix& matrix_a, const Matrix& matrix_b);
    friend Matrix operator *(const Matrix& matrix, double num);
    friend Matrix operator *(double num, const Matrix& matrix) { return matrix * num; }
    friend Matrix operator *(const Matrix& matrix_a, const Matrix& matrix_b);

    size_t getRows() const { return m_matrix.size(); }
    size_t getCols() const { return m_matrix[0].size(); }
    double getDeterminant();

    class Row {
    public:
        explicit Row(std::vector<double>& vec) : m_vec(vec) {}
        double operator[](int index);
    private:
        std::vector<double> m_vec;
    };

    Row operator[](int index);

private:
    vec2d m_matrix;
    double m_determinant;

    static bool check_vec(const vec2d& vec);

    static double getProductElement(vec2d vec_a, vec2d vec_b, int row, int col);

    double evaluate_determinant() const;
};

#endif //CPP_LAB_4_MATRIX_H
