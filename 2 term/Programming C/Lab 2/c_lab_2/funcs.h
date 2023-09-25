#ifndef C_LAB_2_FUNCS_H
#define C_LAB_2_FUNCS_H

double calc_area(double (*f)(double), double a, double b, double dx);

double func(double x,
        double (*f1)(double),
        double (*f2)(double),
        double(*f3)(double),
        double x1,
        double x2);

double func_1(double x);

double func_2(double x);

double func_3(double x);

#endif
