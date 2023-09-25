#include <stdio.h>
#include <math.h>

int main() {
    double x, y;

    printf_s("Enter x value:\n");
    scanf_s("%lf", &x);

    int condition = (x >= 0) + (x >= 1);
    switch (condition) {
        case 0:
            y = sin(x);
            break;
        case 1:
            y = 0;
            break;
        case 2:
            y = cos(x) + 1;
            break;
    }
    printf_s("y = %lf\n", y);

    return 0;
}
