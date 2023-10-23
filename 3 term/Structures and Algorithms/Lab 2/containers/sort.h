#ifndef CONTAINERS_SORT_H
#define CONTAINERS_SORT_H

#include <cstddef>
#include <functional>
#include <memory>

template <typename T>
void heapify_cmp(std::unique_ptr<T[]>& array, size_t start, size_t count,
                 size_t root, std::function<int(T, T)>& cmp) {
    size_t largest = root;
    size_t left = 2 * root + 1;
    size_t right = 2 * root + 2;

    if (left < count && cmp(array[start + left], array[start + largest]) > 0) {
        largest = left;
    }

    if (right < count &&
        cmp(array[start + right], array[start + largest]) > 0) {
        largest = right;
    }

    if (largest != root) {
        std::swap(array[start + root], array[start + largest]);

        heapify_cmp(array, start, count, largest, cmp);
    }
}

template <typename T>
void heap_sort_cmp(std::unique_ptr<T[]>& array, size_t start, size_t count,
                   std::function<int(T, T)>& cmp) {
    for (int i = count / 2 - 1; i >= 0; i--) {
        heapify_cmp(array, start, count, i, cmp);
    }

    for (int i = count - 1; i > 0; i--) {
        std::swap(array[start], array[start + i]);
        heapify_cmp(array, start, i, 0, cmp);
    }
}

template <typename T>
void heapify_nocmp(std::unique_ptr<T[]>& array, size_t start, size_t count,
                   size_t root) {
    size_t largest = root;
    size_t left = 2 * root + 1;
    size_t right = 2 * root + 2;

    if (left < count && array[start + left] > array[start + largest]) {
        largest = left;
    }

    if (right < count && array[start + right] > array[start + largest]) {
        largest = right;
    }

    if (largest != root) {
        std::swap(array[start + root], array[start + largest]);
        heapify_nocmp(array, count, largest, start);
    }
}

template <typename T>
void heap_sort_nocmp(std::unique_ptr<T[]>& array, size_t start, size_t count) {
    for (int i = count / 2 - 1; i >= 0; i--) {
        heapify_nocmp(array, start, count, i);
    }

    for (int i = count - 1; i > 0; i--) {
        std::swap(array[start], array[start + i]);
        heapify_nocmp(array, start, i, 0);
    }
}

#endif  // !CONTAINERS_SORT_H
