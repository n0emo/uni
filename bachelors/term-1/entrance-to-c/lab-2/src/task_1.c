#include <math.h>
#include <stdio.h>

double f(double a, double c, double x);

int main()
{
    double a = 0.0;
    double c = 0.0;
    double x = 0.0;
    printf("Enter a, c, x vaules:\n");
    scanf("%lf %lf %lf", &a, &c, &x);

    double y = f(a, c, x);
    printf("y = %lf\n", y);

    return 0;
}

double f(double a, double c, double x)
{
    if (x <= 0.0)
    {
        return sqrt(a + fabs(x));
    }
    else
    {
        return (1.0 + 3.0 * x) / (2.0 * c + cbrt(1.0 + x));
    }
}
