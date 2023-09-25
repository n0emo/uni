#pragma once

#include "book.h"

void print_books(book** books, int count);

void copy_ptr_arr(void** to, int count, void** from);

void test_sort(book** books, int count,
    void (*sorting_func)(void**, void**, int(*)(void*, void*)),
    int(*compare_func)(void*, void*),
    char* msg);

void test_info_sort(book** books,
    int count,
    void (*sorting_func)(void**, void**, int(*)(void*, void*), int*, int*),
    int(*compare_func)(void*, void*),
    char* msg);

void test_info_sort_rec(book** books,
    int count,
    void (*sorting_func)(void**, void**, int(*)(void*, void*), int*, int*, int, int*),
    int(*compare_func)(void*, void*),
    char* msg);
