#include <math.h>
#include <stdio.h>

double f(double a, double b, double L);
double into_radians(double degrees);

int main()
{
    double L = 0.0;
    printf("Enter L vaule:\n");
    scanf("%lf", &L);

    double a = 0.0;
    printf("Enter a vaule:\n");
    scanf("%lf", &a);

    double b = 0.0;
    printf("Enter b vaule:\n");
    scanf("%lf", &b);

    a = into_radians(a);
    b = into_radians(b);
    double V = f(a, b, L);

    printf("\nV = %lf\n", V);

    return 0;
}

double f(double a, double b, double L)
{
    return (pow(L, 3.0) * sin(2.0 * a) * sin(b) * cos(a)) / (4.0 * sqrt(cos(a + b) * cos(a - b)));
}

double into_radians(double degrees)
{
    return degrees * M_PI / 180.0;
}
