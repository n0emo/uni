#include <math.h>
#include <stdio.h>

int main()
{
    double a, c, x, y;

    printf("Enter a, c, x vaules:\n");
    scanf("%lf %lf %lf", &a, &c, &x);

    if (x <= 0)
    {
        y = sqrt(a + fabs(x));
    }
    else
    {
        y = (1 + 3 * x) / (2 * c + cbrt(1 + x));
    }

    printf("y = %lf\n", y);

    return 0;
}
