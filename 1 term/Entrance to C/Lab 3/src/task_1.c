#include <math.h>
#include <stdio.h>

int main()
{
    double m, x, F, T, dF, Fk;

    m  = 10;
    x  = 0.15;
    dF = 0.15;
    Fk = 3.2;

    for (F = 1.85; F < Fk + dF * 0.5; F += dF)
    {
        T = 2 * M_PI * sqrt(m * x / F);
        printf("F = %lf, T = %lf\n", F, T);
    }

    return 0;
}
