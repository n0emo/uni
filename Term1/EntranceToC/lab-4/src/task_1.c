#include <stdio.h>

#define n 5 // Количество элементов массива

int main()

{
    int R, arr[n];

    printf("Enter array (%i elemnts):\n", n);
    for (int i = 0; i < n; i++)
    {
        scanf("%i", &arr[i]);
    }

    printf("Enter R value: ");
    scanf("%i", &R);

    for (int i = 0; i < n; i++)
    {
        printf("%i; ", arr[i] -= R);
    }
    printf("\n");

    return 0;
}
