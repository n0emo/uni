#include "testing.h"

#include <stdio.h>
#include <stdlib.h>

void print_books(book** books, int count)
{
    for(int i = 0; i < count; i++)
    {
        printf("%s %s %d %d\n",
            books[i]->surname,
            books[i]->theme,
            books[i]->year,
            books[i]->page_count
        );
    }
}

void copy_ptr_arr(void** to, int count, void** from)
{
    void** end_ptr = to + count;
    while(to < end_ptr)*(to++) = *(from++);
}

void test_sort(book** books,
    int count,
    void (*sorting_func)(void**, void**, int(*)(void*, void*)),
    int(*compare_func)(void*, void*),
    char* msg)
{
    book** arr_for_sorting = malloc(sizeof(book*) * count);
    copy_ptr_arr(arr_for_sorting, count, books);
    printf(msg);
    sorting_func(arr_for_sorting, arr_for_sorting + count, compare_func);
    printf("\nSorted array:\n\n");
    print_books(arr_for_sorting, count);
    free(arr_for_sorting);
}

void test_info_sort(book** books,
    int count,
    void (*sorting_func)(void**, void**, int(*)(void*, void*), int*, int*),
    int(*compare_func)(void*, void*),
    char* msg)
{
    book** arr_for_sorting = malloc(sizeof(book*) * count);
    copy_ptr_arr(arr_for_sorting, count, books);
    printf(msg);
    int swap_count = 0;
    int cmp_count = 0;
    sorting_func(arr_for_sorting, arr_for_sorting + count, compare_func, &swap_count, &cmp_count);
    printf("%d swaps, %d compares\n\nSorted array:\n\n", swap_count, cmp_count);
    print_books(arr_for_sorting, count);
}

void test_info_sort_rec(book** books,
    int count,
    void (*sorting_func)(void**, void**, int(*)(void*, void*), int*, int*, int, int*),
    int(*compare_func)(void*, void*),
    char* msg)
{
    book** arr_for_sorting = malloc(sizeof(book*) * count);
    copy_ptr_arr(arr_for_sorting, count, books);
    printf(msg);
    int swap_count = 0;
    int cmp_count = 0;
    int max_rec = 0;
    sorting_func(arr_for_sorting, arr_for_sorting + count, compare_func, &swap_count, &cmp_count, 0, &max_rec);
    printf("%d swaps, %d compares, %d max rec\n\nSorted array:\n\n", swap_count, cmp_count, max_rec);
    print_books(arr_for_sorting, count);
}
