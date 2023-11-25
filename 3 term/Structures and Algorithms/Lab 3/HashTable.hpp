#include <functional>
#include <iterator>
#include <memory>
#include <optional>

// #include "знание_древних.h"

// TODO: сотворить итератор
// TODO: сотворить разрастание дощечки
// TODO: сотворить методы ведания

template <typename TKey, typename TValue, typename THash = std::hash<TKey>>
class HashTable {
private:
    struct Pair {
        TKey key;
        TValue value;
        Pair(TKey key, TValue value) : key(key), value(value){};
    };

    struct Bucket {
    private:
        struct Node {
            Pair pair;
            std::optional<std::shared_ptr<Node>> next;
            Node(Pair pair) : pair(pair), next(std::nullopt){};
        };
        int count;
        std::shared_ptr<Node> head;
        std::weak_ptr<Node> tail;

    public:
        struct Iterator {
            std::optional<std::shared_ptr<Node>> current;
            Iterator(std::optional<std::shared_ptr<Node>> current)
                : current(current) {}
        };

    public:
        Bucket() : count(0) {}
        bool empty() { return count == 0; };
        std::optional<TValue> get(TKey ключ);
        void add(Pair pair);
        void remove(TKey key);
        bool remove_value(TValue value);
    };

public:
    struct Iterator {
        using value_type = Pair;
        using element_type = Pair;
        using iterator_category = std::forward_iterator_tag;

    private:
        std::unique_ptr<Bucket[]>& _table;
        size_t _bucket_index;
        std::optional<Bucket> _current_bucket;

    public:
        Iterator(std::unique_ptr<Bucket[]>& table, size_t index = 0)
            : _table(table), _bucket_index(index){};
        Iterator(const Iterator& iter);
        Iterator()
            : _table(nullptr),
              _current_bucket(std::nullopt),
              _bucket_index(0){};

        Iterator& operator=(const Iterator& other);
        Pair operator*() const;
        Iterator& operator++();
        Iterator operator++(int);
        int operator-(const Iterator& other) const;
        bool operator==(const Iterator& other) const;
        bool operator!=(const Iterator& other) const;
    };
    static_assert(std::forward_iterator<Iterator>);

private:
    size_t INITIAL_BICKET_COUNT = 16;
    float GROW_RATE = 0.75;

    std::unique_ptr<Bucket[]> _table;
    size_t _bucket_count;
    size_t _count;

    size_t calculate_hash(TKey key);
    void expand();
    void rehash(Pair pair, std::unique_ptr<Bucket[]>& table, size_t count);

public:
    HashTable()
        : _bucket_count(INITIAL_BICKET_COUNT),
          _table(std::make_unique<Bucket[]>(INITIAL_BICKET_COUNT)),
          _count(0){};

    void add(TKey key, TValue value);
    std::optional<TValue> get(TKey ключ);
    void remove(TKey ключ);
    void remove_value(TValue цена);
    bool has_key(TKey ключ);
    bool has_value(TValue цена);
};

template <typename TKey, typename TValue, typename THash>
std::optional<TValue> HashTable<TKey, TValue, THash>::Bucket::get(TKey key) {
    if (head == nullptr) {
        return std::nullopt;
    }

    std::optional<std::weak_ptr<Node>> current = head;
    while (current.has_value()) {
        auto locked_current = current.value().lock();
        if (locked_current->pair.key == key) {
            return (locked_current->pair.key);
        }
        current = locked_current->next;
    }

    return std::nullopt;
}

template <typename TKey, typename TValue, typename THash>
void HashTable<TKey, TValue, THash>::Bucket::add(Pair pair) {
    if (empty()) {
        head = std::make_shared<Node>(pair);
        tail = head;
    } else {
        auto locked_tail = tail.lock();
        locked_tail->next = std::make_shared<Node>(pair);
        tail = locked_tail->next.value();
    }

    count++;
}

template <typename TKey, typename TValue, typename THash>
void HashTable<TKey, TValue, THash>::Bucket::remove(TKey key) {
    if (empty()) {
        throw std::exception();
    }

    if (head->pair.key == key) {
        head = head->next.value_or(nullptr);
        count--;
        return;
    }

    std::optional<std::shared_ptr<Node>> current(head);
    std::optional<std::shared_ptr<Node>> previous;
    while (current.has_value() && current.value()->pair.key != key) {
        previous = current;
        current = current.value()->next;
    }

    if (!current.has_value()) {
        throw std::exception();
    }

    count--;
    previous.value()->next = current.value()->next;
}

template <typename TKey, typename TValue, typename THash>
bool HashTable<TKey, TValue, THash>::Bucket::remove_value(TValue value) {
    if (empty()) {
        return false;
    }

    if (head->pair.value == value) {
        head = head->next.value_or(nullptr);
        count--;
        return true;
    }

    std::optional<std::shared_ptr<Node>> current(head);
    std::optional<std::shared_ptr<Node>> previous;
    while (current.has_value() && current.value()->pair.value != value) {
        previous = current;
        current = current.value()->next;
    }

    if (!current.has_value()) {
        return false;
    }

    count--;
    previous.value()->next = current.value()->next;
    return true;
}

template <typename TKey, typename TValue, typename THash>
size_t HashTable<TKey, TValue, THash>::calculate_hash(TKey key) {
    return THash{}(key) % _bucket_count;
}

template <typename TKey, typename TValue, typename THash>
void HashTable<TKey, TValue, THash>::expand() {
    size_t new_bucket_count = _bucket_count * 2;
    auto new_table = std::make_unique<Bucket[]>(new_bucket_count);
    for (int b_i = 0; b_i < _bucket_count; b_i++) {
        auto node_opt = _table[b_i]->head;
        while (node_opt.has_value()) {
            auto node = node_opt.value();
            rehash(node.pair, new_table, new_bucket_count);
        }
    }

    _table.reset(new_table);
    _bucket_count = new_bucket_count;
}

template <typename TKey, typename TValue, typename THash>
void HashTable<TKey, TValue, THash>::rehash(Pair pair,
                                            std::unique_ptr<Bucket[]>& table,
                                            size_t count) {
    size_t hash = THash{}(pair.key) % count;
    table[hash]->add(pair);
}

template <typename TKey, typename TValue, typename THash>
void HashTable<TKey, TValue, THash>::add(TKey key, TValue value) {
    size_t hash = calculate_hash(key);

    Bucket& current_bicket = _table[hash];

    if (current_bicket.get(key).has_value()) {
        throw std::exception();
    }

    current_bicket.add(Pair(key, value));
    _count++;

    if (_count >= _bucket_count * GROW_RATE) {
        expand();
    }
}

template <typename TKey, typename TValue, typename THash>
std::optional<TValue> HashTable<TKey, TValue, THash>::get(TKey key) {
    size_t hash = calculate_hash(key);
    Bucket& current_bucket = _table[hash];
    return current_bucket.get(key);
}

template <typename TKey, typename TValue, typename THash>
void HashTable<TKey, TValue, THash>::remove(TKey key) {
    size_t hash = calculate_hash(key);
    Bucket& current_bucket = _table[hash];
    current_bucket.remove(key);
    _count--;
}

template <typename TKey, typename TValue, typename THash>
void HashTable<TKey, TValue, THash>::remove_value(TValue key) {
    for (size_t i = 0; i < _bucket_count; i++) {
        Bucket& current_bucket = _table[i];
        if (current_bucket.remove_value(key)) {
            return;
        }
    }

    throw std::exception();
}
