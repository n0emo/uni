#include "hanoisolve.h"
#include "malloc.h"
#include "stdio.h"
#include "showhanoi.h"
#include "windows.h"

#define CLEAR 1
#define WAIT_TIME 0


void init_rods(Rod* rods, uint disc_count);
void find_legal_move(Rod* rods_state, int* current_move);
uint check_move(Rod* a, Rod* b);
uint is_empty(Rod* rod);
uint is_full(Rod* rod);
void make_move(Rod* rods, const int* move);
uint check_for_solved(Rod* rod);

void wait() {
#if WAIT_TIME
    Sleep(WAIT_TIME);
#else
    system("pause");
#endif
#if CLEAR
    system("cls");
#endif
}

void solve_hanoi(uint disc_count, uint dest) {
    system("cls");
    char* aliases = "ABC";
    Rod rods[3];
    init_rods(rods, disc_count);

    int current_move[2];
    current_move[0] = -1;
    current_move[1] = -1;

    show_rods(rods, aliases);
    do {
        wait();
        find_legal_move(rods, current_move);
        make_move(rods, current_move);
        show_rods(rods, aliases);
        show_move(aliases[current_move[0]], aliases[current_move[1]], disc_count);
    } while (!check_for_solved(&rods[dest]));
}

void init_rods(Rod* rods, uint disc_count) {
    rods[0].size = disc_count;
    rods[0].count = disc_count;
    rods[0].array = (uint *)malloc(disc_count * sizeof (uint));
    for(int i = 0; i < disc_count; i++) {
        rods[0].array[i] = disc_count - i;
    }
    rods[1].size = rods[2].size = disc_count;
    rods[1].count = rods[2].count = 0;
    rods[1].array = (uint *)malloc(disc_count * sizeof (uint));
    rods[2].array = (uint *)malloc(disc_count * sizeof (uint));
    for(int i = 0; i < disc_count; i++) {
        rods[1].array[i] = rods[2].array[i] = 0;
    }
}

uint check_for_solved(Rod* rod) {
    for(int i = 0; i < rod -> size; i++) {
        if(rod->array[i] != rod -> size - i) return 0;
    }
    return 1;
}

uint check_move_and_change_if_legal(Rod* rods, int *current_move, int from, int to) {
    if((current_move[0] != to || current_move[1] != from) && check_move(&rods[from], &rods[to])) {
        current_move[0] = from;
        current_move[1] = to;
        return 1;
    }
    return  0;
}

void find_legal_move(Rod* rods, int *current_move) {
    if(check_move_and_change_if_legal(rods, current_move, 0, 1)) return;
    if(check_move_and_change_if_legal(rods, current_move, 1, 0)) return;
    if(check_move_and_change_if_legal(rods, current_move, 1, 2)) return;
    if(check_move_and_change_if_legal(rods, current_move, 2, 1)) return;
}

uint check_move(Rod* a, Rod* b) {
    if(is_empty(a)) return 0;
    if(is_full(b)) return 0;
    if(is_empty(b)) return 1;
    return a->array[a->count - 1] < b->array[b->count - 1];
}

uint is_empty(Rod* rod) { return rod->count == 0; }

uint is_full(Rod* rod) { return rod->count == rod->size; }

void make_move(Rod* rods, const int* move) {
    Rod* a = &rods[move[0]];
    Rod* b = &rods[move[1]];
    b->array[b->count++] = a->array[--a->count];
    a->array[a->count] = 0;
}
