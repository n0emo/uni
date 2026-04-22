#include <errno.h>
#include <stdio.h>

#define n1 10
#define n2 4
#define m2 4
#define k2 10

int task1();
int task2();
void get_indices(int *array, int *indices_array, int q, int k, int *count_ptr, int n);
void max(int *array, int *max_element_ptr, int n);
void get_elements(int *array, int *indices_array, int *count, int array_length, int element);

int main()
{
    int question_number;

    printf("Enter question number (1 or 2):\n");
    scanf("%i", &question_number);

    switch (question_number)
    {
    case 1:
        return task1();
    case 2:
        return task2();
    default:
        return EAGAIN;
    }
}

int task1()
{
    int k = 4, q = 5, count, vectorB[n1] = {1, 5, 3, 4, 7, 4, 2, 2, 6, 8}, indicesArray[n1];

    get_indices(vectorB, indicesArray, q, k, &count, n1);

    for (int i = 0; i < count; i++)
    {
        printf("%i ", *(indicesArray + i));
    }
    printf("\n");

    return 0;
}

int task2()
{
    int matrixA[n2][m2] = {{1, 4, 3, 4}, {2, 6, 4, 5}, {5, 3, 4, 5}, {3, 4, 2, 4}};
    int maxElement;

    max((int *)matrixA, &maxElement, n2 * m2);

    int vectorB[k2] = {1, 4, 8, 3, 5, 6, 2, 4, 6, 3};
    int count = 0;
    int indicesArray[k2];

    get_elements(vectorB, indicesArray, &count, k2, maxElement);

    for (int i = 0; i < count; i++)
    {
        printf("%i ", *(indicesArray + i));
    }
    printf("\n");

    return 0;
}

void get_indices(int *array, int *indices_array, int q, int k, int *count, int n)
{
    *count = 0;
    for (int i = n - 1; i >= n - k; i--)
    {
        if (*(array + i) < q)
        {
            *(indices_array + (*count)++) = i;
        }
    }
}

void max(int *array, int *max_element_ptr, int n)
{
    *max_element_ptr = *array;

    for (int i = 1; i < n; i++)
    {
        *max_element_ptr = *max_element_ptr < *(array + i) ? *(array + i) : *max_element_ptr;
    }
}

void get_elements(int *array, int *indices_array, int *count, int array_length, int element)
{
    for (int i = 0; i < array_length; i++)
    {
        if (*(array + i) == element)
        {
            *(indices_array + (*count)++) = i;
        }
    }
}
