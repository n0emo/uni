#include "funcs.h"
#include "math.h"

double calc_area(double (*f)(double), double a, double b, double dx) {
    double sum = 0;
    while(a < b + (dx / 2)) {
        sum += dx * f(a);
        a += dx;
    }

    return sum;
}

double func(double x,
        double (*f1)(double),
        double (*f2)(double),
        double(*f3)(double),
        double x1,
        double x2) {
    if(x < x1) return f1(x);
    if(x < x2) return f2(x);
    return f3(x);
}

double func_1(double x) {
    return 2 * sin(x);
}

double func_2(double x) {
    return x;
}

double func_3(double x) {
    return log(++x);
}
