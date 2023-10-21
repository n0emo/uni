#ifndef CONTAINERS_ARRAYLIST_H
#define CONTAINERS_ARRAYLIST_H

#include <cstddef>
#include <functional>
#include <memory>
#include <optional>

template <typename T>
class ArrayList {
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

    // void add_range();

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

    // get enumerator

    // ok (untested)
    ArrayList<T> get_range(size_t start, size_t count);

    // ok (untested)
    std::optional<size_t> index_of(T element, size_t start);
    std::optional<size_t> index_of(T element, size_t start, size_t count);
    std::optional<size_t> index_of(T element);

    // ok (untested)
    void insert(size_t index, T element);

    // void insert_range()

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

    void sort(size_t start, size_t count);
    void sort(size_t start, size_t count, Comparer cmp);
    void sort();
    void sort(Comparer cmp);

    void trim_excess();

    bool true_for_all(Predicate match);

    T& operator[](size_t index);
};

#endif  // !CONTAINERS_ARRAYLIST_H
