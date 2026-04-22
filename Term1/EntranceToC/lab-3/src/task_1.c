#include <math.h>
#include <stdio.h>

int main()
{
    double m = 10;
    double x = 0.15;
    double dF = 0.15;
    double Fk = 3.2;

    for (double F = 1.85; F < Fk + dF * 0.5; F += dF)
    {
        double T = 2 * M_PI * sqrt(m * x / F);
        printf("F = %lf, T = %lf\n", F, T);
    }

    return 0;
}
