#include <stdio.h>
#include <malloc.h>

#include "num2.h"
#include "num3.h"
#include "num4.h"

int condition(int x);

int main() {
    // Number 1
    printf("Number 2.\n\n");
    int arr[18] = {2, 7, 5, 2, 67,
                   3, 45, 23, 5, 56,
                   23, 45, 566, 4, 5,
                   2, 54, 67};
    for(int i = 0; i < 18; i++) {
        printf("%d ", arr[i]);
    }
    printf("\nMax: %d, sum: %d, product: %d.\n\n",
           find_max(arr, arr + 18, condition),
           sum_func(arr, arr + 18, condition),
           product_func(arr, arr + 18, condition));

    // Number 2
    printf("Number 3.\n\n");
    printf("Root for func 1: %lf.\n", find_root(1, func_1, 0.01));
    printf("Root for func 2: %lf.\n\n", find_root(1, func_2, 0.01));

    // Number 3
    printf("Number 3.\n\n");

    double integ = 0;
    for(double x = -1.2; x <= 3; x += 0.0001)
        integ += func_rs_iterative(x);
    integ *= 0.0001;
    printf("Integral from, -1.2 to 3 of rS: %lf\n", integ);
    printf("rS recursive: %lf\n", find_root(3,func_rs_recursive, 0.01));
    printf("rS iterative: %lf\n\n", find_root(3,func_rs_iterative, 0.01));

    system("pause");
    return 0;
}

int condition(int x) {
    static int *cache = NULL;
    if(cache == NULL) {
        cache = (int *) calloc(__INT16_MAX__, 4);
    }
    if(x <= __INT16_MAX__ ) {
        if(cache[x] == 0) {
            cache[x] = (x % 2 == 1 && x > 5 && x % 3 != 2) + 1;
        }
        return cache[x] - 1;
    }
    return (x % 2 == 1 && x > 5 && x % 3 != 2);
}
