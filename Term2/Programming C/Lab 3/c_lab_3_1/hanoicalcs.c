#include "hanoicalcs.h"

unsigned long long calc_turn_count(int disc_count) {
    if(disc_count == 64) return ((unsigned long long)1 << 64) - 1;
    return ((unsigned long long)1 << disc_count) - 1;
}

unsigned long long calc_time(int disc_count) {
    unsigned long long turns_per_second = 309994085;
    return calc_turn_count(disc_count) / turns_per_second;
}