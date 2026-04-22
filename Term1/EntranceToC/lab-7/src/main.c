#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

void usage(const char *program_name);

typedef struct Matrix
{
    int *elements;
    size_t rows;
    size_t columns;
} Matrix;

Matrix matrix_make(size_t rows, size_t columns);
void matrix_free(Matrix *m);
void matrix_read(Matrix *m, FILE *f);
void matrix_fill_random(Matrix *m);
void matrix_write(Matrix m, FILE *f);
int *matrix_get(Matrix m, size_t row, size_t column);

typedef struct Point
{
    int row;
    int col;
} Point;

void matrix_find_positive_elements(Matrix m, Point *elements, size_t *count);

int main(int argc, char **argv)
{
    srand(time(NULL));

    if (argc > 1 && (strcmp(argv[1], "--help") == 0 || strcmp(argv[1], "-h") == 0))
    {
        usage(argv[0]);
        return 0;
    }

    bool random = false;
    if (argc > 1 && (strcmp(argv[1], "--random") == 0 || strcmp(argv[1], "-r") == 0))
    {
        random = true;
    }

    uint32_t rows = 0;
    uint32_t columns = 0;
    printf("Enter rows and columns count:\n");
    scanf("%u %u", &rows, &columns);

    Matrix m = matrix_make(rows, columns);

    if (random)
    {
        printf("Generated matrix:\n");
        matrix_fill_random(&m);
        matrix_write(m, stdout);
    }
    else
    {
        printf("Enter matrix with %u rows and %u columns:\n", rows, columns);
        matrix_read(&m, stdin);
    }

    Point *elements = calloc(sizeof(Point), rows * columns);
    size_t count = 0;

    matrix_find_positive_elements(m, elements, &count);

    printf("\nPositive elements:\n");
    for (int i = 0; i < count; i++)
    {
        Point p = elements[i];
        printf("matrix[%d, %d] = % 3d\n", p.row, p.col, *matrix_get(m, p.row, p.col));
    }

    free(elements);
    matrix_free(&m);

    return 0;
}

void usage(const char *program_name)
{
    printf("Find positive elements above main diagonal in matrix.\n"
           "By default reads matrix from STDIN\n"
           "\n"
           "Usage:\n"
           "%s [OPTIONS]\n"
           "\n"
           "Options:\n"
           "  -h, --help   - print this page\n"
           "  -r, --random - do not read matrix and generate random one instead\n",
           program_name);
}

Matrix matrix_make(size_t rows, size_t columns)
{
    return (Matrix){
        .elements = calloc(sizeof(int) * columns, rows),
        .rows = rows,
        .columns = columns,
    };
}

void matrix_free(Matrix *m)
{
    free(m->elements);
    *m = (Matrix){0};
}

void matrix_read(Matrix *m, FILE *f)
{
    for (size_t row = 0; row < m->rows; row++)
    {
        for (size_t column = 0; column < m->columns; column++)
        {
            scanf("%d", matrix_get(*m, row, column));
        }
    }
}

void matrix_fill_random(Matrix *m)
{
    for (size_t row = 0; row < m->rows; row++)
    {
        for (size_t column = 0; column < m->columns; column++)
        {
            *matrix_get(*m, row, column) = rand() % 101 - 50;
        }
    }
}

void matrix_write(Matrix m, FILE *f)
{
    for (size_t row = 0; row < m.rows; row++)
    {
        for (size_t column = 0; column < m.columns; column++)
        {
            printf("% 3d ", *matrix_get(m, row, column));
        }
        printf("\n");
    }
}

int *matrix_get(Matrix m, size_t row, size_t column)
{
    return &m.elements[row * m.columns + column];
}

void matrix_find_positive_elements(Matrix m, Point *elements, size_t *count)
{
    for (size_t row = 0; row < m.rows; row++)
    {
        for (size_t column = 0; column < m.columns; column++)
        {
            int elem = *matrix_get(m, row, column);
            if (column > row && elem > 0)
            {
                elements[*count] = (Point){.row = row, .col = column};
                (*count)++;
            }
        }
    }
}
