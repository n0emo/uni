#include "num4.h"

#include <math.h>

double func_rs_recursive(double x) {
    if(x < 0.01) {
        return x;
    }

    double r = func_rs_recursive(x / 2);
    return 2 * r * sqrt(1 - r * r);
}

double func_rs_iterative(double x) {
    int depth = 0;
    double ans = x;

    while(ans >= 0.01) {
        depth++;
        ans /= 2;
    }

    for(int i = 0; i < depth; i++) {
        ans = 2 * ans * sqrt(1 - ans * ans);
    }

    return ans;
}
