#pragma clang diagnostic push
#pragma ide diagnostic ignored "misc-no-recursion"
#include <string>
#include "sort.h"

#include "functional"

// TODO: change cmp type to std::function in all sorts

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
void selection_sort(T *begin, T *end, std::function<int(T&, T&)> cmp) {
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
void bubble_sort(T *begin, T *end, std::function<int(T&, T&)> cmp) {
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
void insert(T *from, T *to) {
    T elem = *from;
    while (from > to) {
        *from = *(from - 1);
        from--;
    }
    *to = elem;
}

template<typename T>
void insertion_sort(T *begin, T *end, std::function<int(T&, T&)> cmp) {
    T *arr_ptr = begin + 1;
    while (arr_ptr < end) {
        for (T *begin_ptr = begin; begin_ptr < arr_ptr; begin_ptr++) {
            if (cmp(*begin_ptr, *arr_ptr) > 0) {
                insert(arr_ptr, begin_ptr);
            }
        }
        arr_ptr++;
    }
}

template<typename T>
void arr_copy(T *begin_dest, T *begin_src, size_type count) {
    for (int i = 0; i < count; i++) {
        begin_dest[i] = begin_src[i];
    }
}

template<typename T>
void merge_middle(T *begin, T *end, std::function<int(T&, T&)> cmp) {
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
void merge_sort(T *begin, T *end, std::function<int(T&, T&)> cmp) {
    if (begin >= end - 1)
        return;

    int middle = (end - begin) / 2;
    merge_sort(begin, begin + middle, cmp);
    merge_sort(begin + middle, end, cmp);
    merge_middle(begin, end, cmp);
}

template<typename T>
void heapify(T* array, size_t size, size_t root, std::function<int(T&, T&)> cmp) {
    size_t largest = root;
    size_t left = 2 * root + 1;
    size_t right = 2 * root + 2;

    if (left < size && cmp(array[left], array[largest]) > 0) {
        largest = left;
    }

    if (right < size && cmp(array[right], array[largest]) > 0) {
        largest = right;
    }

    if (largest != root) {
        swap(array[root], array[largest]);
        heapify(array, size, largest, cmp);
    }
}

template<typename T>
void heap_sort(T *begin, T *end, std::function<int(T&, T&)> cmp) {
    int size = end - begin;
    for(int i = size / 2 - 1; i >= 0; i--) {
        heapify(begin, size, i, cmp);
    }

    for(int i = size - 1; i > 0; i--) {
        swap_def(begin[0], begin[i]);
        heapify(begin, i, 0, cmp);
    }
}

template<typename T>
void quick_sort(T *begin, T *end, std::function<int(T&, T&)> cmp) {
    if(begin >= end) return;

    T* pivot = end - 1;
    T* low_ptr = begin;
    T* high_ptr = begin;

    while(high_ptr < end - 1) {
        if(cmp(*high_ptr, *pivot) < 0) {
            swap_def(*low_ptr, *high_ptr);
            low_ptr++;
        }

        high_ptr++;
    }

    swap_def(*pivot, *(low_ptr));

    quick_sort(begin, low_ptr, cmp);
    quick_sort(low_ptr + 1, end, cmp);
}

// template function generation
template void selection_sort(std::vector<std::string>*, std::vector<std::string>*, std::function<int(std::vector<std::string>&, std::vector<std::string>&)>);
template void bubble_sort(std::vector<std::string>*, std::vector<std::string>*, std::function<int(std::vector<std::string>&, std::vector<std::string>&)>);
template void insertion_sort(std::vector<std::string>*, std::vector<std::string>*, std::function<int(std::vector<std::string>&, std::vector<std::string>&)>);
template void merge_sort(std::vector<std::string>*, std::vector<std::string>*, std::function<int(std::vector<std::string>&, std::vector<std::string>&)>);
template void heap_sort(std::vector<std::string>*, std::vector<std::string>*, std::function<int(std::vector<std::string>&, std::vector<std::string>&)>);
template void quick_sort(std::vector<std::string>*, std::vector<std::string>*, std::function<int(std::vector<std::string>&, std::vector<std::string>&)>);

#pragma clang diagnostic pop