#include <math.h>
#include <stdio.h>

int main()
{
    double L, a, b, V;

    printf("Enter L vaule:\n");
    scanf("%lf", &L);
    printf("Enter a vaule:\n");
    scanf("%lf", &a);
    printf("Enter b vaule:\n");
    scanf("%lf", &b);

    a = a * M_PI / 180;
    b = b * M_PI / 180;

    V = (L * L * L * sin(2 * a) * sin(b) * cos(a)) / (4 * sqrt(cos(a + b) * cos(a - b)));

    printf("\nV = %lf\n", V);

    return 0;
}
