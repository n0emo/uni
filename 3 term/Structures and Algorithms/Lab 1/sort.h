#ifndef CPP_LAB_1_SORT_H
#define CPP_LAB_1_SORT_H

#include <functional>

template<typename T>
void selection_sort(T *begin, T *end, std::function<int(T&, T&)> cmp);

template<typename T>
void bubble_sort(T *begin, T *end, std::function<int(T&, T&)> cmp);

template<typename T>
void insertion_sort(T *begin, T *end, std::function<int(T&, T&)> cmp);

template<typename T>
void merge_sort(T *begin, T *end, std::function<int(T&, T&)> cmp);

template<typename T>
void heap_sort(T *begin, T *end, std::function<int(T&, T&)> cmp);

template<typename T>
void quick_sort(T *begin, T *end, std::function<int(T&, T&)> cmp);

#endif // CPP_LAB_1_SORT_H
