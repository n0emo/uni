#include <stdio.h>

#define m 20
#define n 50

int main() {
    int arr[m][n];

    for (int i = 0; i < m; i++, printf("\n")) {
        for (int j = 0; j < n; j++) {
            printf("%2i", arr[i][j] = (i % 2 == j % 2) ? 0 : 1);
        }
    }

    return 0;
}
