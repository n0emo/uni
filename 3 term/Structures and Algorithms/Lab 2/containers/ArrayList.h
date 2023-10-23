#ifndef CONTAINERS_ARRAYLIST_H
#define CONTAINERS_ARRAYLIST_H

#include <bits/iterator_concepts.h>
#include <bits/ranges_base.h>

#include <cstddef>
#include <functional>
#include <iterator>
#include <memory>
#include <optional>

template <typename T>
class ArrayList {
public:
    class iterator {
    private:
        const std::unique_ptr<T[]>& m_array;
        size_t m_index;

    public:
        using value_type = T;
        using element_type = T;
        using iterator_category = std::random_access_iterator_tag;

        explicit iterator(const std::unique_ptr<T[]>& array)
            : m_array(array), m_index(0){};
        iterator(const std::unique_ptr<T[]>& array, size_t index)
            : m_array(array), m_index(index){};
        iterator(const iterator& iter)
            : m_array(iter.m_array), m_index(iter.m_index){};
        iterator() : m_array(std::move(nullptr)), m_index(0){};

        iterator& operator=(const iterator& other) {
            new (this) iterator(other);
            return *this;
        }

        T& operator*() const { return m_array[m_index]; }

        T& operator[](int index) const { return m_array[index]; }

        iterator& operator++() {
            m_index++;
            return *this;
        }

        iterator operator++(int) {
            auto return_value = iterator(m_array, m_index);
            ++(*this);
            return return_value;
        }

        iterator& operator--() {
            m_index--;
            return *this;
        }

        iterator operator--(int) {
            auto return_value = iterator(m_array, m_index);
            --(*this);
            return return_value;
        }

        iterator& operator+=(int value) {
            m_index += value;
            return *this;
        }

        iterator& operator-=(int value) {
            m_index -= value;
            return *this;
        }

        friend auto operator<=>(iterator a, iterator b) {
            return a.m_index <=> b.m_index;
        };

        friend int operator-(iterator a, iterator b) {
            return a.m_index - b.m_index;
        }

        friend iterator operator-(iterator a, int value) {
            return iterator(a.m_array, a.m_index - value);
        }

        friend iterator operator+(iterator iter, int value) {
            return iterator(iter.m_array, iter.m_index + value);
        }

        friend iterator operator+(int value, iterator iter) {
            return iter + value;
        }

        bool operator==(const iterator& other) const {
            return m_index == other.m_index;
        }
        bool operator!=(const iterator& other) const {
            return m_index != other.m_index;
        }
    };

    iterator begin();
    iterator end();

private:
    typedef std::function<bool(T)> Predicate;
    typedef std::function<int(T, T)> Comparer;

    const size_t INITIAL_CAPACITY = 2;

    std::unique_ptr<T[]> m_array;
    size_t m_count;
    size_t m_capacity;

    void expand();

    template <typename Obj>
    void throw_if_null(Obj& object, const char* name);
    void check_index(size_t index);
    void check_range(size_t start, size_t count);

public:
    // ok
    ArrayList()
        : m_array(std::make_unique<T[]>(INITIAL_CAPACITY)),
          m_capacity(INITIAL_CAPACITY),
          m_count(0) {}

    // ok
    size_t count();

    // ok
    size_t capacity();

    // ok
    void add(T element);

    template <typename Iter>
    void add_range(Iter begin, Iter end);
    // ok (untested)
    std::optional<size_t> binary_search(T element);
    std::optional<size_t> binary_search(T element, Comparer cmp);
    std::optional<size_t> binary_search(size_t start, size_t count, T element,
                                        Comparer cmp);
    // ok (untested)
    void clear();

    // ok (untested)
    bool contains(T element);

    // ok
    void ensure_capacity(size_t capacity);

    // ok (untested)
    bool exists(Predicate match);

    // ok (untested)
    std::optional<T> find(Predicate match);

    // ok (untested)
    ArrayList<T> find_all(Predicate match);

    // ok (untested)
    std::optional<size_t> find_index(size_t start, size_t count,
                                     Predicate match);
    std::optional<size_t> find_index(Predicate match);
    std::optional<size_t> find_index(size_t start, Predicate match);

    // ok (untested)
    std::optional<T> find_last(Predicate match);

    // ok (untested)
    std::optional<size_t> find_last_index(Predicate match);
    std::optional<size_t> find_last_index(size_t start, Predicate match);
    std::optional<size_t> find_last_index(size_t start, size_t count,
                                          Predicate match);

    // ok (untested)
    void for_each(std::function<void(T)> action);

    // ok (untested)
    ArrayList<T> get_range(size_t start, size_t count);

    // ok (untested)
    std::optional<size_t> index_of(T element, size_t start);
    std::optional<size_t> index_of(T element, size_t start, size_t count);
    std::optional<size_t> index_of(T element);

    // ok (untested)
    void insert(size_t index, T element);

    template <std::forward_iterator Iter, std::sentinel_for<Iter> Sen>
    void insert_range(size_t index, Iter begin, Sen end);

    // ok (untested)
    std::optional<size_t> last_index_of(T element);
    std::optional<size_t> last_index_of(T element, size_t start);
    std::optional<size_t> last_index_of(T element, size_t start, size_t count);

    // ok (untested)
    void remove(T element);

    // slow
    size_t remove_all(Predicate match);

    // ok (untested)
    void remove_at(size_t index);

    void remove_range(size_t start, size_t count);

    // ok (untested)
    void reverse();
    void reverse(size_t start, size_t count);

    // ok (untested)
    void sort(size_t start, size_t count);
    void sort(size_t start, size_t count, Comparer cmp);
    void sort();
    void sort(Comparer cmp);

    // ok
    void trim_excess();

    // ok (untested)
    bool true_for_all(Predicate match);

    T& operator[](size_t index);
};

#endif  // !CONTAINERS_ARRAYLIST_H
