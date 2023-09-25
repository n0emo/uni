#include "num2.h"

#define INT_MIN (-2147483648)

void find_max_step(const int *start, const int *end, int (*cond)(int), int *max_elem) {
    if(start > end) return;
    if(*start > *max_elem && cond(*start))*max_elem = *start;
    find_max_step(++start, end, cond, max_elem);
}

int find_max(int *start, int *end, int (*cond)(int)) {
    int max_elem = INT_MIN;
    find_max_step(start, end, cond, &max_elem);
    return max_elem;
}

void sum_step(const int *start, const int *end, int(*cond)(int), int *sum) {
    if(start > end) return;
    if(cond(*start))*sum += *start;
    sum_step(start + 1, end, cond, sum);
}

int sum_func(int* start, int* end, int (*cond)(int)) {
    int sum = 0;
    sum_step(start, end, cond, &sum);
    return sum;
}

void product_step(int *start, int *end, int(*cond)(int), int *product) {
    if(start > end) return;
    if(cond(*start)) *product *= *start;
    product_step(start + 1, end, cond, product);
}

int product_func(int* start, int* end, int (*cond)(int)) {
    int product = 1;
    product_step(start, end, cond, &product);
    return product;
}
