#ifndef C_LAB_3_1_HANOISOLVE_H
#define C_LAB_3_1_HANOISOLVE_H

typedef unsigned int uint;

typedef struct Rod {
    uint *array;
    uint count;
    uint size;
} Rod;

void solve_hanoi(unsigned int disc_count, unsigned int dest);

#endif //C_LAB_3_1_HANOISOLVE_H
