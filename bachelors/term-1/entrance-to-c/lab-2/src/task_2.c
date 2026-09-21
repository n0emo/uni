#include <math.h>
#include <stdio.h>
#include <stdlib.h>

double f(double x);

int main()
{
    double x = 0.0;
    printf("Enter x value:\n");
    scanf("%lf", &x);

    double y = f(x);
    printf("y = %lf\n", y);

    return 0;
}

double f(double x)
{
    // Это очень "хитрый" способ сделать цепочку ифов в виде свитча. Я нахожу
    // этот код отвратительным, но это очень хотел увидеть Носонов.
    int condition = (x >= 0.0) + (x >= 1.0);
    switch (condition)
    {
    case 0:
        return sin(x);
    case 1:
        return 0.0;
    case 2:
        return cos(x) + 1.0;
    default:
        fprintf(stderr, "Memory corruption");
        abort();
    }
}
