#ifndef CONTAINERS_ARRAYLIST_H
#define CONTAINERS_ARRAYLIST_H

#include <cstddef>
#include <functional>
#include <memory>
#include <optional>

template <typename T>
class ArrayList {
private:
    typedef std::function<bool()> Predicate;

    const size_t INITIAL_CAPACITY = 2;

    std::unique_ptr<T[]> m_array;
    size_t m_count;
    size_t m_capacity;

    void expand();

public:
    ArrayList()
	: m_array(std::make_unique<T[]>(INITIAL_CAPACITY)),
	  m_capacity(INITIAL_CAPACITY), m_count(0) {}

    size_t count();

    size_t capacity();

    void add(T element);

    void add_range();

    std::optional<size_t> binary_search(T element);
    std::optional<size_t> binary_search(size_t start, size_t count, T element);

    void clear();

    bool contains(T element);

    void ensure_capacity(size_t capacity);

    bool exists(Predicate match);

    std::optional<T> find(Predicate match);

    ArrayList<T> find_all(Predicate match);

    std::optional<size_t> find_index(size_t start, size_t count,
                                     Predicate match);

    std::optional<T> find_last(Predicate match);

    std::optional<size_t> find_last_index(size_t start, size_t count,
                                          Predicate match);

    void for_each(std::function<void(T)> action);

    // get enumerator

    ArrayList<T> get_range(size_t start, size_t count);

    std::optional<size_t> index_of(T element);

    void insert(size_t index, T element);

    // void insert_range()

    std::optional<size_t> last_index_of(T element);

    void remove(T element);

    size_t remove_all(Predicate match);

    void remove_at(size_t index);

    void remove_range(size_t start, size_t count);

    void reverse();

    void sort();

    void trim_excess();

    bool true_for_all(Predicate match);

    T& operator[](size_t index);
};

#endif // !CONTAINERS_ARRAYLIST_H
