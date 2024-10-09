#include <stdio.h>
#include "funcs.h"

double func_default(double x);

double x1;
double x2;
double c1;
double c2;
double c3;
double c4;
double a, b, dx;

int main() {
    x1 = -2;
    x2 = 1;
    a = -5.67;
    b = 9.5;
    dx = 0.0000005;

    printf_s("\nResults for:\nx1 = %lf, x2 = %lf\na = %lf, b = %lf\ndx = %lf\n", x1, x2, a, b, dx);
    c1 = calc_area(func_1, a, x1, dx);
    c2 = calc_area(func_2, x1, x2, dx);
    c3 = calc_area(func_3, x2, b, dx);
    c4 = calc_area(func_default, a, b, dx);

    printf_s("func 1 area between a and x1: %lf\n", c1);
    printf_s("func 2 area between x1 and x2: %lf\n", c2);
    printf_s("func 3 area between x2 and b: %lf\n", c3);
    printf_s("function area between a and b: %lf\n", c4);
    return 0;
}

double func_default(double x) {
    return func(x,func_1,func_2,func_3,x1,x2);
}
