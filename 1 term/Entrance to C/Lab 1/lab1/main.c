#include <stdio.h>
#include <math.h>

int main() {
    double L, a, b, V;

    printf_s("Enter L vaule:\n");
    scanf_s("%lf", &L);
    printf_s("Enter a vaule:\n");
    scanf_s("%lf", &a);
    printf_s("Enter b vaule:\n");
    scanf_s("%lf", &b);

    a = a * M_PI / 180;
    b = b * M_PI / 180;

    V = (L * L * L * sin(2 * a) * sin(b) * cos(a)) / (4 * sqrt(cos(a + b) * cos(a - b)));

    printf_s("\nV = %lf\n", V);

    return 0;
}
