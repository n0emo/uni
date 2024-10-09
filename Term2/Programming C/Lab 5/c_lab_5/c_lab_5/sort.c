#include "sort.h"

void S_swap(void** a, void**b)
{
    void* tmp = *a;
    *a = *b;
    *b = tmp;
}

void bubble_iter(void** begin, void** end, int(* compare)(void*, void*))
{
    while(begin < end)
    {
        void** iter = begin;
        while(iter < end - 1)
        {
            if(compare(*iter, *(iter + 1)) == 1) S_swap(iter, iter + 1);
            iter++;
        }
        end--;
    }
}

void bubble_rec(void** begin, void** end, int(* compare)(void*, void*))
{
    if(begin >= end) return;
    void** iter = begin;
    while(iter < end - 1)
    {
        if(compare(*iter, *(iter + 1)) == 1) S_swap(iter, iter + 1);
        iter++;
    }
    bubble_rec(begin, end - 1, compare);
}

void insertion_iter(void** begin, void** end, int(* compare)(void*, void*))
{
    void** iter_1 = begin + 1;
    while(iter_1 < end)
    {
        void* key = *iter_1;
        void** iter_2 = iter_1 - 1;
        while (iter_2 >= begin && compare(*iter_2, key) == 1)
        {
            *(iter_2 + 1) = *iter_2;
            iter_2--;
        }
        *(iter_2 + 1) = key;
        iter_1++;
    }
}

void insertion_rec_impl(void** begin, void** end, void** iter_end, int(* compare)(void*, void*))
{
    if(end <= iter_end) return;
    void* key = *iter_end;
    void** iter_2 = iter_end - 1;
    while (iter_2 >= begin && compare(*iter_2, key) == 1)
    {
        *(iter_2 + 1) = *iter_2;
        iter_2--;
    }
    *(iter_2 + 1) = key;
    insertion_rec_impl(begin, end, iter_end + 1, compare);
}

void insertion_rec(void** begin, void** end, int(* compare)(void*, void*))
    { insertion_rec_impl(begin, end, begin + 1, compare); }

void** quicksort_partition(void** begin, void** end, int(* compare)(void*, void*))
{
    void* pivot = *end;
    void** pivot_ptr = begin;

    for(void** iter_i = begin; iter_i < end; iter_i++)
    {
        if(compare(*iter_i, pivot) == -1)
        {
            S_swap(pivot_ptr, iter_i);
            pivot_ptr++;
        }
    }

    S_swap(pivot_ptr, end);
    return pivot_ptr;
}

void quicksort_impl(void** begin, void** end, int(* compare)(void*, void*))
{
    if(begin >= end) return;
    
    void** pivot_ptr = quicksort_partition(begin, end, compare);
    quicksort_impl(begin, pivot_ptr - 1, compare);
    quicksort_impl(pivot_ptr + 1, end, compare);
}

void quicksort(void** begin, void** end, int(* compare)(void*, void*))
    { quicksort_impl(begin, end - 1, compare); }

void bubble_iter_info(void** begin, void** end, int(* compare)(void*, void*), int* swap_count, int* cmp_count)
{
    while(begin < end)
    {
        void** iter = begin;
        while(iter < end - 1)
        {
            (*cmp_count)++;
            if(compare(*iter, *(iter + 1)) == 1)
            {
                (*swap_count)++;
                S_swap(iter, iter + 1);
            }
            iter++;
        }
        end--;
    }
}

void bubble_rec_info(void** begin, void** end, int(* compare)(void*, void*), int* swap_count, int* cmp_count,
    int current_rec, int* max_rec)
{
    if(begin >= end)
    {
        if(current_rec > *max_rec) *max_rec = current_rec;
        return;
    }
    
    void** iter = begin;
    while(iter < end - 1)
    {
        (*cmp_count)++;
        if(compare(*iter, *(iter + 1)) == 1)
        {
            (*swap_count)+=1;
            S_swap(iter, iter + 1);
        }
        iter++;
    }
    bubble_rec_info(begin, end - 1, compare, swap_count, cmp_count, current_rec + 1, max_rec);
}

void insertion_iter_info(void** begin, void** end, int(* compare)(void*, void*), int* swap_count, int* cmp_count)
{
    void** iter_1 = begin + 1;
    while(iter_1 < end)
    {
        void* key = *iter_1;
        void** iter_2 = iter_1 - 1;
        while (iter_2 >= begin && ++(*cmp_count) && compare(*iter_2, key) == 1 )
        {
            *(iter_2 + 1) = *iter_2;
            iter_2--;
        }
        *(iter_2 + 1) = key;
        iter_1++;
    }
}

void insertion_rec_info_impl(void** begin, void** end, void** iter_end,  int(* compare)(void*, void*), int* swap_count, int* cmp_count,
    int current_rec, int* max_rec)
{
    if(end <= iter_end)
    {
        if(current_rec > *max_rec) *max_rec = current_rec;
        return;
    }
    void* key = *iter_end;
    void** iter_2 = iter_end - 1;
    while (iter_2 >= begin && ++(*cmp_count) && compare(*iter_2, key) == 1)
    {
        *(iter_2 + 1) = *iter_2;
        iter_2--;
    }
    *(iter_2 + 1) = key;
    insertion_rec_info_impl(begin, end, iter_end + 1, compare, swap_count, cmp_count, current_rec + 1, max_rec);
}

void insertion_rec_info(void** begin, void** end, int(* compare)(void*, void*), int* swap_count, int* cmp_count,
    int current_rec, int* max_rec)
{
    insertion_rec_info_impl(begin, end, begin + 1, compare, swap_count, cmp_count, current_rec, max_rec);
}

void** quicksort_info_partition(void** begin, void** end, int(* compare)(void*, void*), int* swap_count, int* cmp_count)
{
    void* pivot = *end;
    void** pivot_ptr = begin;

    for(void** iter_i = begin; iter_i < end; iter_i++)
    {
        (*cmp_count)++;
        if(compare(*iter_i, pivot) == -1)
        {
            (*swap_count)++;
            S_swap(pivot_ptr, iter_i);
            pivot_ptr++;
        }
    }
    (*swap_count)++;
    S_swap(pivot_ptr, end);
    return pivot_ptr;
}

void quicksort_info_impl(void** begin, void** end, int(* compare)(void*, void*), int* swap_count, int* cmp_count,
    int current_rec, int* max_rec)
{
    if(begin >= end)
    {
        if(current_rec > *max_rec) *max_rec = current_rec;
        return;
    }
    
    void** pivot_ptr = quicksort_info_partition(begin, end, compare, swap_count, cmp_count);
    quicksort_info_impl(begin, pivot_ptr - 1, compare, swap_count, cmp_count, current_rec + 1, max_rec);
    quicksort_info_impl(pivot_ptr + 1, end, compare, swap_count, cmp_count, current_rec + 1, max_rec);
}

void quicksort_info(void** begin, void** end, int(* compare)(void*, void*), int* swap_count, int* cmp_count,
    int current_rec, int* max_rec)
    { quicksort_info_impl(begin, end - 1, compare, swap_count, cmp_count, current_rec, max_rec); }
