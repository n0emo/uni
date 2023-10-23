#include "ArrayList.h"

#include <algorithm>
#include <cstddef>
#include <memory>
#include <optional>
#include <sstream>
#include <stdexcept>

#include "sort.h"

template <typename T>
size_t ArrayList<T>::count() {
    return m_count;
}

template <typename T>
size_t ArrayList<T>::capacity() {
    return m_capacity;
}

template <typename T>
typename ArrayList<T>::iterator ArrayList<T>::begin() {
    return iterator(m_array);
}

template <typename T>
typename ArrayList<T>::iterator ArrayList<T>::end() {
    return iterator(m_array, m_count);
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
template <typename Iter>
void ArrayList<T>::add_range(Iter begin, Iter end) {
    auto diff = end - begin;
    ensure_capacity(m_count + diff);
    for (size_t i = 0; i < diff; i++) {
        m_array[m_count + i] = *begin;
        begin++;
    }
    m_count += diff;
}

template <typename T>
std::optional<size_t> ArrayList<T>::binary_search(T element) {
    size_t start = 0;
    size_t end = m_count - 1;

    while (start < end) {
        auto mid = (start + end) / 2;
        if (m_array[mid] == element) {
            return std::optional(mid);
        } else if (m_array[mid] > element) {
            end = mid;
        } else if (m_array[mid] < element) {
            start = mid;
        }
    }

    return m_array[start] == element ? std::optional(start) : std::nullopt;
}

template <typename T>
std::optional<size_t> ArrayList<T>::binary_search(T element, Comparer cmp) {
    return binary_search(0, m_count, element, cmp);
}
template <typename T>
std::optional<size_t> ArrayList<T>::binary_search(size_t start, size_t count,
                                                  T element, Comparer cmp) {
    throw_if_null(cmp, "cmp");
    check_range(start, count);

    if (cmp == nullptr) {
        throw std::invalid_argument("cmp was null");
    }

    size_t end = start + count - 1;

    while (start < end) {
        auto mid = (start + end) / 2;
        if (cmp(m_array[mid], element) > 0) {
            end = mid;
        } else if (cmp(element, m_array[mid]) > 0) {
            start = mid;
        } else {
            return std::optional(mid);
        }
    }

    return cmp(m_array[start], element) == cmp(element, m_array[start])
               ? std::optional(start)
               : std::nullopt;
}

template <typename T>
void ArrayList<T>::clear() {
    m_count = 0;
}

template <typename T>
bool ArrayList<T>::contains(T element) {
    for (size_t i = 0; i < m_count; i++) {
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

    for (size_t i = 0; i < m_capacity; i++) {
        new_array[i] = m_array[i];
    }

    m_array.swap(new_array);
    m_capacity = capacity;
}

template <typename T>
bool ArrayList<T>::exists(Predicate match) {
    throw_if_null(match, "match");

    for (size_t i = 0; i < m_count; i++) {
        if (match(m_array[i])) {
            return true;
        }
    }
    return false;
}

template <typename T>
std::optional<T> ArrayList<T>::find(Predicate match) {
    throw_if_null(match, "match");

    for (size_t i = 0; i < m_count; i++) {
        if (match(m_array[i])) {
            return std::optional(m_array[i]);
        }
    }
    return std::nullopt;
}

template <typename T>
ArrayList<T> ArrayList<T>::find_all(Predicate match) {
    throw_if_null(match, "match");

    ArrayList<T> found;
    found.ensure_capacity(m_count);
    for (size_t i = 0; i < m_count; i++) {
        if (match(m_array[i])) {
            found.add(m_array[i]);
        }
    }
    return found;
}

template <typename T>
std::optional<size_t> ArrayList<T>::find_index(size_t start, size_t count,
                                               Predicate match) {
    throw_if_null(match, "match");
    check_range(start, count);

    for (size_t i = start; i < start + count; i++) {
        if (match(m_array[i])) {
            return std::optional(i);
        }
    }
    return std::nullopt;
}

template <typename T>
std::optional<size_t> ArrayList<T>::find_index(Predicate match) {
    throw_if_null(match, "match");

    for (size_t index = 0; index < m_count; index++) {
        if (match(m_array[index])) {
            return std::optional(index);
        }
    }

    return std::nullopt;
}

template <typename T>
std::optional<size_t> ArrayList<T>::find_index(size_t start, Predicate match) {
    throw_if_null(match, "match");
    check_index(start);

    for (size_t index = start; index < m_count; index++) {
        if (match(m_array[index])) {
            return std::optional(index);
        }
    }

    return std::nullopt;
}

template <typename T>
std::optional<T> ArrayList<T>::find_last(Predicate match) {
    throw_if_null(match, "match");

    for (long long i = m_count - 1; i >= 0; i--) {
        if (match(m_array[i])) {
            return std::optional(m_array[i]);
        }
    }
    return std::nullopt;
}

template <typename T>
std::optional<size_t> ArrayList<T>::find_last_index(Predicate match) {
    throw_if_null(match, "match");
    if (m_count == 0) {
        return std::nullopt;
    }

    for (long long index = m_count - 1; index >= 0; index--) {
        if (match(m_array[index])) {
            return std::optional(index);
        }
    }

    return std::nullopt;
}

template <typename T>
std::optional<size_t> ArrayList<T>::find_last_index(size_t start,
                                                    Predicate match) {
    check_index(start);

    for (long long index = start; index >= 0; index--) {
        if (match(m_array[index])) {
            return std::optional(index);
        }
    }

    return std::nullopt;
}

template <typename T>
std::optional<size_t> ArrayList<T>::find_last_index(size_t start, size_t count,
                                                    Predicate match) {
    throw_if_null(match, "match");
    check_range(start, count);

    for (long long index = start; index > start - count; index--) {
        if (match(m_array[index])) {
            return std::optional(index);
        }
    }
    return std::nullopt;
}

template <typename T>
void ArrayList<T>::for_each(std::function<void(T)> action) {
    throw_if_null(action, "action");

    for (size_t i = 0; i < m_count; i++) {
        action(m_array[i]);
    }
}

template <typename T>
ArrayList<T> ArrayList<T>::get_range(size_t start, size_t count) {
    check_range(start, count);

    ArrayList<T> result;
    result.ensure_capacity(count);
    for (size_t index = start; index < start + count; index++) {
        result.add(m_array[index]);
    }
    return result;
}

template <typename T>
std::optional<size_t> ArrayList<T>::index_of(T element, size_t start) {
    check_index(start);

    for (size_t index = start; index < m_count; index++) {
        if (m_array[index] == element) {
            return std::optional(index);
        }
    }

    return std::nullopt;
}

template <typename T>
std::optional<size_t> ArrayList<T>::index_of(T element, size_t start,
                                             size_t count) {
    check_range(start, count);

    for (size_t index = start; index < start + count; index++) {
        if (m_array[index] == element) {
            return std::optional(index);
        }
    }

    return std::nullopt;
}

template <typename T>
std::optional<size_t> ArrayList<T>::index_of(T element) {
    for (size_t index = 0; index < m_count; index++) {
        if (m_array[index] == element) {
            return std::optional(index);
        }
    }
    return std::nullopt;
}

template <typename T>
void ArrayList<T>::insert(size_t index, T element) {
    check_index(index);

    if (m_count == m_capacity) {
        expand();
    }

    for (long long i = m_count; i > index; i--) {
        m_array[i] = m_array[i - 1];
    }
    m_array[index] = element;
}

template <typename T>
std::optional<size_t> ArrayList<T>::last_index_of(T element) {
    for (long long i = m_count - 1; i >= 0; i--) {
        if (m_array[i] == element) {
            return std::optional(i);
        }
    }
    return std::nullopt;
}

template <typename T>
std::optional<size_t> ArrayList<T>::last_index_of(T element, size_t start) {
    check_index(start);

    for (long long index = start; index >= 0; index--) {
        if (m_array[index] == element) {
            return std::optional(index);
        }
    }

    return std::nullopt;
}

template <typename T>
std::optional<size_t> ArrayList<T>::last_index_of(T element, size_t start,
                                                  size_t count) {
    check_range(start, count);

    for (long long index = start; index >= start - count; index--) {
        if (m_array[index] == element) {
            return std::optional(index);
        }
    }

    return std::nullopt;
}

template <typename T>
void ArrayList<T>::remove(T element) {
    size_t index = 0;
    for (; index < m_count; index++) {
        if (m_array[index] == element) {
            break;
        }
    }

    if (index == m_count) {
        // maybe throw not found exception
        return;
    }

    for (size_t i = index; i < m_count - 1; i++) {
        m_array[i] = m_array[i + 1];
        continue;
    }

    m_count--;
}

template <typename T>
size_t ArrayList<T>::remove_all(Predicate match) {
    throw_if_null(match, "match");
    auto new_array = std::make_unique<int[]>(m_capacity);
    size_t new_count = 0;

    for (size_t i = 0; i < m_count; i++) {
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
void ArrayList<T>::remove_at(size_t index) {
    check_index(index);

    for (size_t i = index; i < m_count - 1; i++) {
        m_array[i] = m_array[i + 1];
    }
    m_count--;
}

template <typename T>
void ArrayList<T>::reverse() {
    if (m_count <= 1) {
        return;
    }

    for (size_t index = 0; index < m_count / 2; index++) {
        std::swap(m_array[index], m_array[m_count - index - 1]);
    }
}

template <typename T>
void ArrayList<T>::reverse(size_t start, size_t count) {
    check_range(start, count);
    if (count - start <= 1) {
        return;
    }

    for (size_t i = 0; i < count / 2; i++) {
        std::swap(m_array[i + start], m_array[m_count - i - 1 + start]);
    }
}

template <typename T>
void ArrayList<T>::sort(size_t start, size_t count) {
    check_range(start, count);
    heap_sort_nocmp(m_array, start, count);
}

template <typename T>
void ArrayList<T>::sort(size_t start, size_t count, Comparer cmp) {
    throw_if_null(cmp, "cmp");
    check_range(start, count);
    heap_sort_cmp(m_array, start, count, cmp);
}

template <typename T>
void ArrayList<T>::sort() {
    heap_sort_nocmp(m_array, 0, m_count);
}

template <typename T>
void ArrayList<T>::sort(Comparer cmp) {
    throw_if_null(cmp, "cmp");
    heap_sort_cmp(m_array, 0, m_count, cmp);
}

template <typename T>
void ArrayList<T>::trim_excess() {
    if (m_count == m_capacity) {
        return;
    }

    auto new_array = std::make_unique<T[]>(m_count);
    for (size_t i = 0; i < m_count; i++) {
        new_array[i] = m_array[i];
    }

    m_capacity = m_count;
    m_array.swap(new_array);
}

template <typename T>
bool ArrayList<T>::true_for_all(Predicate match) {
    throw_if_null(match, "match");

    for (size_t index = 0; index < m_count; index++) {
        if (!match(m_array[index])) {
            return false;
        }
    }

    return true;
}

template <typename T>
template <typename Obj>
void ArrayList<T>::throw_if_null(Obj& object, const char* name) {
    if (object == nullptr) {
        std::string what(name);
        what += " was null.";
        throw std::invalid_argument(what);
    }
}

template <typename T>
void ArrayList<T>::check_index(size_t index) {
    if (index >= m_count) {
        throw std::invalid_argument("index was out of range");
    }
}

template <typename T>
void ArrayList<T>::check_range(size_t start, size_t count) {
    if (count + start > m_count) {
        std::stringstream stream;
        stream << "out of range: "
               << "start=" << start << ", "
               << "count=" << count << ", "
               << "m_count=" << m_count << ".";
        throw std::invalid_argument(stream.str());
    }
}

template <typename T>
T& ArrayList<T>::operator[](size_t index) {
    if (index < 0 || index >= m_count) {
        throw std::out_of_range("The index was out of range.");
    }
    return m_array[index];
}
