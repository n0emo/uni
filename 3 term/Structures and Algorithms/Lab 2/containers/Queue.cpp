#include "Queue.h"

#include <memory>

template <typename T>
Queue<T>::Queue() {
    m_arr = std::make_unique<T>(INITIAL_SIZE);
}

template class Queue<int>;
