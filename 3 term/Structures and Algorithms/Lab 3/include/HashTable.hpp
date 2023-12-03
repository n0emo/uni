#include <functional>
#include <iostream>
#include <iterator>
#include <memory>
#include <optional>

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
        struct Node {
            Pair pair;
            std::optional<std::shared_ptr<Node>> next;
            Node(Pair pair) : pair(pair), next(std::nullopt){};
        };
        int count;
        std::shared_ptr<Node> head;
        std::weak_ptr<Node> tail;

        Bucket() : count(0) {}
        bool empty() { return count == 0; };
        std::optional<TValue> get(TKey key);
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
        const std::unique_ptr<Bucket[]>& _table;
        size_t _bucket_count = 0;
        size_t _bucket_index = 0;
        std::optional<std::shared_ptr<typename Bucket::Node>> _current_node =
            std::nullopt;

    public:
        Iterator(std::unique_ptr<Bucket[]>& table, size_t count,
                 size_t index = 0)
            : _table(table) {
            _bucket_index = index;
            _bucket_count = count;
            _current_node = std::nullopt;

            _current_node = table[0].head;
            while (_current_node.value() == nullptr &&
                   _bucket_index < _bucket_count) {
                _bucket_index++;
                _current_node = table[_bucket_index].head;
            }
        };
        Iterator(const Iterator& iter)
            : _table(iter._table),
              _bucket_count(iter._bucket_count),
              _bucket_index(iter._bucket_index),
              _current_node(iter._current_node){};
        Iterator() : _table(std::move(nullptr)){};

        Iterator& operator=(const Iterator& other);
        Pair operator*() const;
        Iterator& operator++();
        Iterator operator++(int);
        int operator-(const Iterator& other) const;
        bool operator==(const Iterator& other) const;
        bool operator!=(const Iterator& other) const;
    };
    static_assert(std::forward_iterator<Iterator>);

    Iterator begin();
    Iterator end();

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
    std::optional<TValue> get(TKey key);
    void remove(TKey key);
    void remove_value(TValue value);
    bool has_key(TKey key);
    bool has_value(TValue value);

    void show_buckets() {
        for (int i = 0; i < _bucket_count; i++) {
            if (_table[i].count == 0) {
                continue;
            }
            std::cout << i << ": {";

            std::optional<std::shared_ptr<typename Bucket::Node>> node =
                _table[i].head;
            while (node.has_value()) {
                std::cout << node.value()->pair.key << ": "
                          << node.value()->pair.value << ",";
                node = node.value()->next;
            }
            std::cout << "}\n";
        }
    }
    size_t count_collisions() const {
        size_t count = 0;
        for (size_t i = 0; i < _bucket_count; i++) {
            if (_table[i].count > 1) {
                count += _table[i].count - 1;
            }
        }
        return count;
    }
};

template <typename TKey, typename TValue, typename THash>
HashTable<TKey, TValue, THash>::Iterator&
HashTable<TKey, TValue, THash>::Iterator::operator=(
    const HashTable<TKey, TValue, THash>::Iterator& other) {
    new (this) Iterator(other);
    return *this;
}

template <typename TKey, typename TValue, typename THash>
HashTable<TKey, TValue, THash>::Pair
HashTable<TKey, TValue, THash>::Iterator::operator*() const {
    return _current_node.value()->pair;
}

template <typename TKey, typename TValue, typename THash>
HashTable<TKey, TValue, THash>::Iterator&
HashTable<TKey, TValue, THash>::Iterator::operator++() {
    _current_node = _current_node.value()->next;

    if (!_current_node.has_value()) {
        _bucket_index++;
        auto current = _table[_bucket_index].head;
        while (current == nullptr) {
            _bucket_index++;
            if (_bucket_index == _bucket_count) {
                break;
            }
            current = _table[_bucket_index].head;
        }
        _current_node = current;
    }
    return *this;
}

template <typename TKey, typename TValue, typename THash>
HashTable<TKey, TValue, THash>::Iterator
HashTable<TKey, TValue, THash>::Iterator::operator++(int) {
    auto return_value = Iterator(*this);
    ++(*this);
    return return_value;
}

template <typename TKey, typename TValue, typename THash>
int HashTable<TKey, TValue, THash>::Iterator::operator-(
    const HashTable<TKey, TValue, THash>::Iterator& other) const {
    return _bucket_index - other._bucket_index;
}

template <typename TKey, typename TValue, typename THash>
bool HashTable<TKey, TValue, THash>::Iterator::operator==(
    const HashTable<TKey, TValue, THash>::Iterator& other) const {
    if (_bucket_index == _bucket_count && other._bucket_count == 0) {
        return true;
    }

    if (!_current_node.has_value() || !other._current_node.has_value()) {
        return false;
    }

    return _current_node.value()->pair.key ==
           other._current_node.value()->pair.key;
}

template <typename TKey, typename TValue, typename THash>
bool HashTable<TKey, TValue, THash>::Iterator::operator!=(
    const HashTable<TKey, TValue, THash>::Iterator& other) const {
    return !(*this == other);
}

template <typename TKey, typename TValue, typename THash>
HashTable<TKey, TValue, THash>::Iterator
HashTable<TKey, TValue, THash>::begin() {
    return Iterator(_table, _bucket_count);
}

template <typename TKey, typename TValue, typename THash>
HashTable<TKey, TValue, THash>::Iterator HashTable<TKey, TValue, THash>::end() {
    return Iterator();
}

template <typename TKey, typename TValue, typename THash>
std::optional<TValue> HashTable<TKey, TValue, THash>::Bucket::get(TKey key) {
    if (head == nullptr) {
        return std::nullopt;
    }

    std::optional<std::weak_ptr<Node>> current = head;
    while (current.has_value()) {
        auto locked_current = current.value().lock();
        if (locked_current->pair.key == key) {
            return (locked_current->pair.value);
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
        auto node = _table[b_i].head;
        if (node == nullptr) {
            continue;
        }

        auto node_opt = std::optional(node);
        while (node_opt.has_value()) {
            rehash(node_opt.value()->pair, new_table, new_bucket_count);
            node_opt = node_opt.value()->next;
        }
    }

    _table.swap(new_table);
    _bucket_count = new_bucket_count;
}

template <typename TKey, typename TValue, typename THash>
void HashTable<TKey, TValue, THash>::rehash(Pair pair,
                                            std::unique_ptr<Bucket[]>& table,
                                            size_t count) {
    size_t hash = THash{}(pair.key) % count;
    table[hash].add(pair);
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
