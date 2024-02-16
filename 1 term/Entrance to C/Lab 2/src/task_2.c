#include <math.h>
#include <stdio.h>

int main()
{
    double x, y;

    printf("Enter x value:\n");
    scanf("%lf", &x);

    int condition = (x >= 0) + (x >= 1);
    switch (condition)
    {
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

    printf("y = %lf\n", y);

    return 0;
}
