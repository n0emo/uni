#include "num3.h"

#include <math.h>

double func_1(double x) {
    return x * x - sin(x);
}

double func_2(double x) {
    return x * x * x - 1.728;
}

double find_root(double start_x, double (*func) (double x), double delta) {
    if(round(func(start_x) * 100) == 0) {
        return start_x;
    }

    double f1 = round(func(start_x - delta) * 100);
    double f2 = round(func(start_x + delta) * 100);

    if(fabs(f1) <= fabs(f2)) {
        return find_root(start_x - delta, func, delta);
    }
    return find_root(start_x + delta, func, delta);
}
