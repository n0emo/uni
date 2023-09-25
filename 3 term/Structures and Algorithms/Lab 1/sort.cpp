#include "sort.h"

typedef unsigned long size_type;

template<typename T>
T *middle(T *_begin, T *_end) {
    long length = _end - _begin;
    return _begin + length / 2;
}

template<typename SwapT>
void swap_def(SwapT &a, SwapT &b) {
    SwapT tmp = a;
    a = b;
    b = tmp;
}

template<typename T>
void bubble_sort(T *begin, T *end, int (*cmp)(T a, T b)) {
    for (; end >= begin; end--) {
        bool swapped = false;
        for (T *begin_ptr = begin; begin_ptr < end - 1; begin_ptr++) {
            if (cmp(*begin_ptr, *(begin_ptr + 1)) > 0) {
                swap_def(*begin_ptr, *(begin_ptr + 1));
                swapped = true;
            }
        }
        if (!swapped)
            break;
    }
}

template<typename T>
void selection_sort(T *begin, T *end, int (*cmp)(T a, T b)) {
    while (begin < end) {
        T *min = begin;
        for (T *begin_iter = begin; begin_iter < end; begin_iter++) {
            if (cmp(*min, *begin_iter) > 0) {
                min = begin_iter;
            }
        }
        swap_def(*min, *begin);
        begin++;
    }
}

template<typename T>
void insert(T *from, T *to) {
    T elem = *from;
    while (from >= to) {
        *from = *(from - 1);
        from--;
    }
    *to = elem;
}

template<typename T>
void insertion_sort(T *begin, T *end, int (*cmp)(T a, T b)) {
    T *arr_ptr = begin + 1;
    while (arr_ptr < end) {
        for (T *begin_ptr = begin; begin_ptr < arr_ptr; begin_ptr++) {
            if (cmp(*begin_ptr, *arr_ptr) > 0) {
                insert(arr_ptr, begin_ptr);
            }
        }
    }
}

// TODO: fix quick sort
template<typename T>
void quick_sort(T *begin, T *end, int (*cmp)(T a, T b)) {
    if(begin >= end - 1) return;

    T* pivot = end - 1;
    T* begin_i = begin - 1;
    T* begin_j = begin;

    while(begin_j < end) {
        if(cmp(*begin_j, *pivot) < 0) {
            begin_i++;
            swap_def(*begin_i, *begin_j);
        }

        begin_j++;
    }

    swap_def(*pivot, *(begin_i + 1));
    pivot = begin_i;

    quick_sort(begin, pivot, cmp);
    quick_sort(pivot + 1, end, cmp);
}

template<typename T>
void arr_copy(T *begin_dest, T *begin_src, size_type count) {
    for (int i = 0; i < count; i++) {
        begin_dest[i] = begin_src[i];
    }
}

template<typename T>
void merge_middle(T *begin, T *end, int (*cmp)(T a, T b)) {
    int middle = (end - begin) / 2;

    size_type a_size = middle;
    T *tmp_arr_a = new T[a_size];
    arr_copy(tmp_arr_a, begin, a_size);

    size_type b_size = end - begin - middle;
    T *tmp_arr_b = new T[b_size];
    arr_copy(tmp_arr_b, begin + middle, b_size);

    T *a_ptr = tmp_arr_a;
    T *b_ptr = tmp_arr_b;

    while (a_ptr < tmp_arr_a + a_size && b_ptr < tmp_arr_b + b_size) {
        if (cmp(*a_ptr, *b_ptr) > 0) {
            *begin = *b_ptr;
            b_ptr++;
        } else {
            *begin = *a_ptr;
            a_ptr++;
        }
        begin++;
    }

    arr_copy(begin, a_ptr, tmp_arr_a + a_size - a_ptr);
    arr_copy(begin, b_ptr, tmp_arr_b + b_size - b_ptr);

    delete[] tmp_arr_a;
    delete[] tmp_arr_b;
}

template<typename T>
void merge_sort(T *begin, T *end, int (*cmp)(T a, T b)) {
    if (begin >= end - 1)
        return;

    int middle = (end - begin) / 2;
    merge_sort(begin, begin + middle, cmp);
    merge_sort(begin + middle, end, cmp);
    merge_middle(begin, end, cmp);
}

// template function generation
template void bubble_sort<int>(int *begin, int *end, int (*cmp)(int a, int b));
template void selection_sort<int>(int *begin, int *end, int (*cmp)(int a, int b));
template void merge_middle(int *begin, int *end, int (*cmp)(int a, int b));
template void merge_sort(int *begin, int *end, int (*cmp)(int a, int b));
template void insertion_sort(int *begin, int *end, int (*cmp)(int a, int b));
template void quick_sort(int *begin, int* end, int (*cmp)(int a, int b));
