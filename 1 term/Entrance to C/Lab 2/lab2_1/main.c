#include <stdio.h>
#include <math.h>

int main() {
    double a, c, x, y;

    printf_s("Enter a, c, x vaules:\n");
    scanf_s("%lf %lf %lf", &a, &c, &x);
    if (x <= 0) {
        y = sqrt(a + fabs(x));
    } else {
        y = (1 + 3 * x) / (2 * c + cbrt(1 + x));
    }

    printf_s("y = %lf", y);

    return 0;
}
