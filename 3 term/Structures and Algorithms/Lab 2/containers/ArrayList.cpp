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
    ensure_capacity(m_capacity * 2);
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
    if (m_count == 0) {
	return std::nullopt;
    }

    if (count == 1) {
	return m_array[start] == element ? std::optional(start) : std::nullopt;
    }

    auto right = start + count;
    auto mid = (start + right) / 2;
    if (element == m_array[mid])
	return std::optional(mid);

    return element < m_array[mid] ? binary_search(start, count / 2, element)
                                  : binary_search(mid, count / 2, element);
}

template <typename T>
void ArrayList<T>::clear() {
    m_count = 0;
}

template <typename T>
bool ArrayList<T>::contains(T element) {
    for (int i = 0; i < m_count; i++) {
	if (m_array[i] == element) {
	    return true;
	}
    }
    return false;
}

template <typename T>
void ArrayList<T>::ensure_capacity(size_t capacity) {
    if (m_capacity >= capacity) {
	return;
    }

    auto new_array = std::make_unique<T[]>(capacity);

    for (int i = 0; i < m_capacity; i++) {
	new_array[i] = m_array[i];
    }

    m_array.swap(new_array);
    m_capacity = capacity;
}

template <typename T>
bool ArrayList<T>::exists(Predicate match) {
    for (int i = 0; i < m_count; i++) {
	if (match(m_array[i])) {
	    return true;
	}
    }
    return false;
}

template <typename T>
std::optional<T> ArrayList<T>::find(Predicate match) {
    for (int i = 0; i < m_count; i++) {
	if (match(m_array[i])) {
	    return std::optional(m_array[i]);
	}
    }
    return std::nullopt;
}

template <typename T>
ArrayList<T> ArrayList<T>::find_all(Predicate match) {
    ArrayList<T> found;
    found.ensure_capacity(m_count);
    for (int i = 0; i < m_count; i++) {
	if (match(m_array[i])) {
	    found.add(m_array[i]);
	}
    }
    return found;
}

template <typename T>
std::optional<size_t> ArrayList<T>::find_index(size_t start, size_t count,
                                               Predicate match) {
    for (int i = start; i < start + count; i++) {
	if (match(m_array[i])) {
	    return std::optional(i);
	}
    }
    return std::nullopt;
}

template <typename T>
std::optional<T> ArrayList<T>::find_last(Predicate match) {
    for (int i = m_count - 1; i >= 0; i--) {
	if (match(m_array[i])) {
	    return std::optional(m_array[i]);
	}
    }
    return std::nullopt;
}

template <typename T>
std::optional<size_t> ArrayList<T>::find_last_index(size_t start, size_t count,
                                                    Predicate match) {
    for (int i = start; i > start - count; i--) {
	if (match(m_array[i])) {
	    return std::optional(i);
	}
    }
    return std::nullopt;
}

template <typename T>
void ArrayList<T>::for_each(std::function<void(T)> action) {
    for (int i = 0; i < m_count; i++) {
	action(m_array[i]);
    }
}

template <typename T>
ArrayList<T> ArrayList<T>::get_range(size_t start, size_t count) {
    ArrayList<T> result;
    result.ensure_capacity(count);
    for (int i = start; i < start + count; i++) {
	result.add(m_array[i]);
    }
    return result;
}

template <typename T>
std::optional<size_t> ArrayList<T>::index_of(T element) {
    for (int i = 0; i < m_count; i++) {
	if (m_array[i] == element) {
	    return std::optional(i);
	}
    }
    return std::nullopt;
}

template <typename T>
void ArrayList<T>::insert(size_t index, T element) {
    if (m_count == m_capacity) {
	expand();
    }

    for (int i = m_count; i > index; i--) {
	m_array[i] = m_array[i - 1];
    }
    m_array[index] = element;
}

template <typename T>
std::optional<size_t> ArrayList<T>::last_index_of(T element) {
    for (int i = m_count - 1; i >= 0; i--) {
	if (m_array[i] == element) {
	    return std::optional(i);
	}
    }
    return std::nullopt;
}

template <typename T>
void ArrayList<T>::remove(T element) {
    int index = 0;
    for (; index < m_count; index++) {
	if (m_array[index] == element) {
	    break;
	}
    }

    if (index == m_count) {
	return;
    }

    for (int i = index; i < m_count - 1; i++) {
	m_array[i] = m_array[i + 1];
    }

    m_count--;
}

template <typename T>
size_t ArrayList<T>::remove_all(Predicate match) {
    auto new_array = std::make_unique<int[]>(m_capacity);
    size_t new_count = 0;

    for (int i = 0; i < m_count; i++) {
	if (!match(m_array[i])) {
	    new_array[new_count] = m_array[i];
	    new_count++;
	}
    }

    m_array.swap(new_array);
    std::swap(m_count, new_count);
    return m_count - new_count;
}

template <typename T>
T& ArrayList<T>::operator[](size_t index) {
    if (index < 0 || index >= m_count) {
	throw std::out_of_range("The index was out of range.");
    }
    return m_array[index];
}

// template class ArrayList<int>;
