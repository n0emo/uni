#include "determinant.h"

#define size_t unsigned long long int

double **sub_matrix(double **matrix, size_t size, size_t deletedRow, size_t deletedCol);

double eval_determinant(double **matrix, unsigned long long int size) {
    if(size == 1) return matrix[0][0];
    if(size == 2) return matrix[0][0] * matrix[1][1] - matrix[0][1] * matrix[1][0];

    double det = 0;
    for(size_t i = 0; i < size; i++) {
        double** subMatrix = sub_matrix(matrix, size, 0, i);
        det += eval_determinant(subMatrix, size - 1) * matrix[0][i] * (i & 1 ? -1 : 1);
        for(size_t j = 0; j < size - 1; j++) delete[] subMatrix[j];
    }

    return det;
}

double **sub_matrix(double **matrix, size_t size, size_t deletedRow, size_t deletedCol) {
    size -= 1;
    double** newmatrix = new double*[size];
    for(size_t i = 0; i < size; i++) {
        newmatrix[i] = new double[size];
    }

    for(size_t row = 0, newRow = 0; row <= size; row++) {
        if(row != deletedRow) {
            for (size_t col = 0, newCol = 0; col <= size; col++) {
                if (col != deletedCol) {
                    newmatrix[newRow][newCol] = matrix[row][col] ;
                    newCol++;
                }
            }
            newRow++;
        }
    }

    return newmatrix;
}


