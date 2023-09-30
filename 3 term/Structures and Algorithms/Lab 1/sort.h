#ifndef CPP_LAB_1_SORT_H
#define CPP_LAB_1_SORT_H

template<typename T>
void selection_sort(T *begin, T *end, int (*cmp)(T a, T b));

template<typename T>
void bubble_sort(T *begin, T *end, int (*cmp)(T a, T b));

template<typename T>
T *merge_new_mem(T *begin_a, T *end_a, T *begin_b, T *end_b, int (*cmp)(T a, T b));

template<typename T>
void merge_middle(T *begin, T *end, int (*cmp)(T a, T b));

template<typename T>
void insertion_sort(T *begin, T *end, int (*cmp)(T a, T b));

template<typename T>
void quick_sort(T *begin, T *end, int (*cmp)(T a, T b));

template<typename T>
void merge_sort(T *begin, T *end, int (*cmp)(T a, T b));

template<typename T>
void heap_sort(T *begin, T *end, int (*cmp)(T a, T b));

#endif // CPP_LAB_1_SORT_H
