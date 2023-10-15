#ifndef CONTAINERS_QUEUE_H
#define CONTAINERS_QUEUE_H

#include <cstddef>
#include <memory>

template <typename T>
class Queue {
private:
    const size_t INITIAL_SIZE = 8;

    std::unique_ptr<T> m_arr;

public:
    Queue();
};

#endif // CONTAINERS_QUEUE_H
