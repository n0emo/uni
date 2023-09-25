#include <stdio.h>
#include <errno.h>

#define m 4
#define n 3

int task_1();
int task_2();
double w_function(double const array[], int length);
double even_rows_product(double matrix[][n], int *count_ptr);

int main() {
    int question_number;

    printf_s("Select question number (1 or 2):\n");
    scanf_s("%i", &question_number);

    switch (question_number) {
        case 1:
            return task_1();
        case 2:
            return task_2();
        default:
            return EAGAIN; // try again
    }
}

int task_1() {
    int length;

    printf("Enter array elements count:\n");
    scanf_s("%i", &length);

    double array[length];
    printf_s("Enter array numbers:\n");
    for (int i = 0; i < length; ++i) {
        scanf_s("%lf", &array[i]);
    }

    printf("Answer: W = %lf", w_function(array, length));

    return 0;
}

int task_2() {
    double matrix[m][n];

    printf("Enter matrix with %i rows and %i columns:\n", m, n);
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n; j++) {
            scanf_s("%lf", &matrix[i][j]);
        }
    }

    double product;
    int count;
    product = even_rows_product(matrix, &count);
    printf_s("Answer: product = %lf, count = %d", product, count);

    return 0;
}

double w_function(double const array[], int length) {
    double answer = 0;

    for (int i = 0; i < length; ++i) {
        answer += array[i] * array[i] / 2;
    }

    return answer;
}

double even_rows_product(double matrix[][n], int *count_ptr) {
    *count_ptr = 0;
    double product = 1;

    for (int i = 1; i < m; i += 2) {
        for (int j = 0; j < n; j++) {
            product *= matrix[i][j];
            (*count_ptr)++;
        }
    }

    return product;
}

