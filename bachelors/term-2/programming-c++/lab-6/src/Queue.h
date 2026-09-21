#ifndef CPP_LAB_6_QUEUE_H
#define CPP_LAB_6_QUEUE_H


#define size_t unsigned long long int

template <class T = void*>
class Queue {
private: struct Node {
        T data;
        Node* next = nullptr;
    };

public:
    Queue() = default;
    ~Queue() { clear(); }
    size_t size();
    T* toArray();
    void enqueue(T data);
    T dequeue();
    T peek();
    void clear();
private:
    Node* m_first = nullptr;
    size_t m_size = 0;
    Node *getLast();
};

template<class T>
size_t Queue<T>::size() { return m_size; }

template<class T>
T *Queue<T>::toArray() {
    T* array = new T[m_size];
    Node* current = m_first;
    int index = 0;
    while (current != nullptr) {
        array[index] = current->data;
        index++;
        current = current->next;
    }

    return array;
}

template<class T>
void Queue<T>::enqueue(T data) {
    Node* enqueued = new Node;
    enqueued->data = data;
    Node* last = getLast();
    (last == nullptr ? m_first : last->next) = enqueued;
    m_size++;
}

template<class T>
T Queue<T>::dequeue() {
    Node* next = m_first->next;
    T data = m_first->data;
    delete m_first;
    m_first = next;
    m_size--;
    return data;
}

template<class T>
T Queue<T>::peek() {
    return m_first->data;
}

template<class T>
void Queue<T>::clear() {
    Node* current = m_first;
    while (current != nullptr) {
        Node* tmp = current->next;
        delete current;
        current = tmp;
    }

    m_first = nullptr;
    m_size = 0;
}

template<class T>
Queue<T>::Node *Queue<T>::getLast() {
    Node* current = m_first;
    if(m_first == nullptr) return nullptr;
    while (current->next != nullptr) {
        current = current->next;
    }

    return current;
}


#endif //CPP_LAB_6_QUEUE_H
