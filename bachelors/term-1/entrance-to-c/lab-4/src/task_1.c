#include <stdio.h>

// Количество элементов массива
#define N 5

int main()

{
    int arr[N];

    printf("Enter array (%i elemnts):\n", N);
    for (int i = 0; i < N; i++)
    {
        scanf("%i", &arr[i]);
    }

    int R = 0;
    printf("Enter R value: ");
    scanf("%i", &R);

    for (int i = 0; i < N; i++)
    {
        printf("%i; ", arr[i] -= R);
    }
    printf("\n");

    return 0;
}
