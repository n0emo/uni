#pragma once

void bubble_iter(void** begin, void** end, int(*compare)(void*, void*));

void bubble_rec(void** begin, void** end, int(*compare)(void*, void*));

void insertion_iter(void** begin, void** end, int(*compare)(void*, void*));

void insertion_rec(void** begin, void** end, int(*compare)(void*, void*));

void quicksort(void** begin, void** end, int(*compare)(void*, void*));

void bubble_iter_info(void** begin, void** end, int(*compare)(void*, void*),
    int* swap_count, int* cmp_count
    );

void bubble_rec_info(void** begin, void** end, int(*compare)(void*, void*),
    int* swap_count, int* cmp_count, int current_rec, int* max_rec
    );

void insertion_iter_info(void** begin, void** end, int(*compare)(void*, void*),
    int* swap_count, int* cmp_count
    );

void insertion_rec_info(void** begin, void** end, int(* compare)(void*, void*),
    int* swap_count, int* cmp_count, int current_rec, int* max_rec);

void quicksort_info(void** begin, void** end, int(*compare)(void*, void*),
    int* swap_count, int* cmp_count, int current_rec, int* max_rec
    );
