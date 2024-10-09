#include <stdio.h>
#include <stdlib.h>
#include <time.h>

// Если Вы хотите, чтобы элементы матрицы генерировались случайным образом,
// примите эту константой равной 1.
// Если хотите ввести их с консоли - 0.
#define random_matrix 0

struct point
{
    int row;
    int col;
};

void get_matrix(int ***matrix, int rows, int cols);
void find_elements(int **matrix, int rows, int cols, int *count_ptr, struct point *vector);
void free_matrix(int **matrix, int rows);

int main()
{
    int rows, cols, **matrix_S;

    printf("Enter rows and columns count:\n");
    scanf("%i %i", &rows, &cols);

    printf("Enter matrix with %i rows and %i columns:\n", rows, cols);
    get_matrix(&matrix_S, rows, cols);

    struct point vector_P[rows * cols];
    int count = 0;

    find_elements(matrix_S, rows, cols, &count, vector_P);

    printf("\nresult:\n");
    for (int i = 0; i < count; i++)
    {
        printf("matrix_S[%d][%d], value=%d\n", vector_P[i].row, vector_P[i].col,
               matrix_S[vector_P[i].row][vector_P[i].col]);
    }

    free_matrix(matrix_S, rows);

    return 0;
}

void get_matrix(int ***matrix, int rows, int cols)
{
    srand(time(NULL));

    *matrix = (int **)malloc(rows * sizeof(int *));

    for (int i = 0; i < rows; i++)
    {
        (*matrix)[i] = (int *)malloc(cols * sizeof(int));

        for (int j = 0; j < cols; j++)
        {
            if (random_matrix)
            {
                (*matrix)[i][j] = rand() % 101 - 50;
                printf("%3i ", (*matrix)[i][j]);
            }
            else
            {
                scanf("%i", &(*matrix)[i][j]);
            }
        }
        if (random_matrix)
        {
            printf("\n");
        }
    }
}

void find_elements(int **matrix, int rows, int cols, int *count_ptr, struct point *vector)
{
    struct point tmp;

    for (int i = 0; i < rows; i++)
    {
        for (int j = i + 1; j < cols; j++)
        {
            if (matrix[i][j] > 0)
            {
                tmp.row = i;
                tmp.col = j;
                vector[*count_ptr] = tmp;
                (*count_ptr)++;
            }
        }
    }
}

void free_matrix(int **matrix, int rows)
{
    for (int i = 0; i < rows; i++)
    {
        free(matrix[i]);
    }
    free(matrix);
}
