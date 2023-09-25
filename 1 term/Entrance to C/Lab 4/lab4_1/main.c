#include <stdio.h>

#define n 5 // Количество элементов массива

int main() {
    int R, arr[n];

    printf_s("Enter array %i elements:\n", n);
    for (int i = 0; i < n; i++) {
        scanf_s("%i", &arr[i]);
    }

    printf_s("\nEnter R value: ");
    scanf_s("%i", &R);

    printf_s("\nArray elements:\n");
    for (int i = 0; i < n; i++) {
        printf_s("%i; ", arr[i] -= R);
    }

    return 0;
}
