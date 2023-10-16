#include "ArrayList.h"
#include <algorithm>
#include <cstddef>
#include <memory>
#include <optional>
#include <stdexcept>

template <typename T>
size_t ArrayList<T>::count() {
    return m_count;
}

template <typename T>
size_t ArrayList<T>::capacity() {
    return m_capacity;
}

template <typename T>
void ArrayList<T>::expand() {
    auto new_capacity = m_capacity * 2;
    auto new_array = std::make_unique<T[]>(new_capacity);
    for (int i = 0; i < m_capacity; i++) {
	new_array[i] = m_array[i];
    }
    m_array.swap(new_array);
    m_capacity = new_capacity;
}

template <typename T>
void ArrayList<T>::add(T element) {
    if (m_count == m_capacity) {
	expand();
    }

    m_array[m_count] = element;
    m_count++;
}

template <typename T>
std::optional<size_t> ArrayList<T>::binary_search(T element) {
    return binary_search(0, m_count, element);
}

template <typename T>
std::optional<size_t> ArrayList<T>::binary_search(size_t start, size_t count,
                                                  T element) {
    if (count == 1) {
	return m_array[start] == element ? std::optional(start) : std::nullopt;
    }

    auto new_count = count / 2 + 1;
    auto mid_index = start + new_count;
    return element > m_array[mid_index]
               ? binary_search(0, new_count, element)
               : binary_search(mid_index, new_count, element);
}

template <typename T>
T& ArrayList<T>::operator[](size_t index) {
    if (index < 0 || index >= m_count) {
	throw std::out_of_range("The index was out of range.");
    }
    return m_array[index];
}

// template class ArrayList<int>;
