#include <functional>
#include <memory>
#include <optional>

// #include "знание_древних.h"

// TODO: сотворить итератор
// TODO: сотворить разрастание дощечки
// TODO: сотворить методы ведания

// clang-format off
template<typename TKey, typename TValue> 
class HashTable {
private:
    struct Pair {
        TKey key;
        TValue value;
        Pair(TKey key, TValue value) : key(key), value(value) {};
    };

    struct Bucket {
    private:
        struct Node {
            Pair pair;
            std::optional<std::shared_ptr<Node>> next;
            Node(Pair pair) : pair(pair), next(std::nullopt) {};
        };
        int count;
        std::shared_ptr<Node> head;
        std::weak_ptr<Node> tail;

    public:
        struct Iterator {
            std::optional<std::shared_ptr<Node>> current;
            Iterator(std::optional<std::shared_ptr<Node>> current) : current(current){} 
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
        size_t bucket_index;
        Bucket& current_bucket;
    };

private:
    size_t INITIAL_BICKET_COUNT = 16;
    float GROW_RATE = 0.75;

    std::unique_ptr<Bucket[]> _table;
    size_t _bucket_count;
    size_t _count;

    size_t calculate_hash(TKey key);
public:
    HashTable() : 
        _bucket_count(INITIAL_BICKET_COUNT), 
        _table(std::make_unique<Bucket[]>(INITIAL_BICKET_COUNT)),
        _count(0) {};

    void add(TKey key, TValue value);
    std::optional<TValue> get(TKey ключ);
    void remove(TKey ключ);
    void remove_value(TValue цена);
    bool has_key(TKey ключ);
    bool has_value(TValue цена);
};

template <typename TKey, typename TValue>
std::optional<TValue> HashTable<TKey, TValue>::Bucket::get(TKey key) {
    if(head == nullptr) {
        return std::nullopt;
    }

    std::optional<std::weak_ptr<Node>> current = head;
    while (current.has_value()) {
        auto locked_current = current.value().lock();
        if(locked_current->pair.key == key) {
            return(locked_current->pair.key);
        }
        current = locked_current->next;
    }

    return std::nullopt;
}

template <typename TKey, typename TValue>
void HashTable<TKey, TValue>::Bucket::add(Pair pair) {
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

template <typename TKey, typename TValue>
void HashTable<TKey, TValue>::Bucket::remove(TKey key) {
    if(empty()) {
        throw std::exception();
    }

    if(head->pair.key == key) {
        head = head->next.value_or(nullptr);
        count--;
        return;
    }             

    std::optional<std::shared_ptr<Node>> current(head);
    std::optional<std::shared_ptr<Node>> previous;
    while(current.has_value() && current.value()->pair.key != key) {
        previous = current;
        current = current.value()->next;
    }

    if(!current.has_value()) {
        throw std::exception();
    }

    count--;
    previous.value()->next = current.value()->next;
}


template <typename TKey, typename TValue>
bool HashTable<TKey, TValue>::Bucket::remove_value(TValue value){
    if(empty()) {
        return false;
    }

    if(head->pair.value == value) {
        head = head->next.value_or(nullptr);
        count--;
        return true;
    }             

    std::optional<std::shared_ptr<Node>> current(head);
    std::optional<std::shared_ptr<Node>> previous;
    while(current.has_value() && current.value()->pair.value != value) {
        previous = current;
        current = current.value()->next;
    }

    if(!current.has_value()) {
        return false;
    }

    count--;
    previous.value()->next = current.value()->next;
    return true;
}

template <typename TKey, typename TValue>
size_t HashTable<TKey, TValue>::calculate_hash(TKey key) {
    return std::hash<TKey>{}(key) % _bucket_count;
}

template <typename TKey, typename TValue>
void HashTable<TKey, TValue>::add(TKey key, TValue value) {
    size_t hash = calculate_hash(key);

    Bucket& current_bicket = _table[hash];

    if(current_bicket.get(key).has_value()) {
        throw std::exception();
    }

    current_bicket.add(Pair(key, value));
    _count++;
}

template <typename TKey, typename TValue>
std::optional<TValue> HashTable<TKey, TValue>::get(TKey key) {
    size_t hash = calculate_hash(key);
    Bucket& current_bucket = _table[hash];
    return current_bucket.get(key);
}

template <typename TKey, typename TValue>
void HashTable<TKey, TValue>::remove(TKey key) {
    size_t hash = calculate_hash(key);
    Bucket& current_bucket = _table[hash];
    current_bucket.remove(key);
    _count--;
}

template <typename TKey, typename TValue>
void HashTable<TKey, TValue>::remove_value(TValue key) {
    for(size_t i = 0; i < _bucket_count; i++) {
        Bucket& current_bucket = _table[i];
        if(current_bucket.remove_value(key)) {
            return;
        }
    }

    throw std::exception();
}

// clang-format on
