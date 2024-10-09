#pragma once

#include <memory>
#include <vector>

/**
 * \brief
 * Singly linked list for data
 * \tparam T the type of the data
 */
template <typename T>
class list
{
public:
    list() = default;

    list(const list& cpy)
    {
        auto tmp = cpy.m_head;
        while (tmp != nullptr)
        {
            push_back(tmp->data);
            tmp = tmp->next;
        }
    }

    ~list() = default;

    /**
     * \brief
     * Returns the count of elements currently in the list.
     */
    size_t size() const { return m_size; }

    /**
     * \brief
     * Checks whenever the list is empty or not.
     * \return True if the list is empty or false if the list is not empty.
     */
    bool is_empty() const { return m_size == 0; }

    /**
     * \brief
     * Get the data of the lists head.
     * \return The data of type T of the lists head.
     */
    T head() const;

    /**
     * \brief
     * Get the data of the lists tail.
     * \return The data of type T of the lists tail.
     */
    T tail() const;

    /**
      \brief
      Returns a data from the list at index.
      \param index the index of the element in order from head to tail.
      \return The data of type T at specified index.
     **/
    T& operator[](size_t index);

    /**
     * \brief
     * Converts the list to std::vector<T>.
     * \return std::vector<T>, containing all elements of
     * the list with the same template type T.
     */
    std::vector<T> to_vector();

    /**
     * \brief
     * Pushes the data at the end of the list.
     * \param data a data of the type T.
     */
    void push_back(T data);

    /**
     * \brief
     * Pushes the data at the start of the list.
     * \param data a data of the type T.
     */
    void push_front(T data);

    /**
     * \brief Inserts data in the list at specified index.
     * \details
     * If the index is less than 0 or greater or equal
     * to the lists size than exception will be thrown.
     * \param data a data of the type T.
     * \param index an index at which the new element will be in the list.
     */
    void insert(T data, size_t index);

    /**
     * \brief
     * Removes an elements at the end of the list and returns its value.
     * \return data of the type T.
     */
    T pop_back();

    /**
     * \brief
     * Removes an elements at the start of the list and returns its value.
     * \return data of the type T.
     */
    T pop_front();

    /**
     * \brief
     * Removes an element from the list at the specified index.
     * \param index the index of the element to remove.
     */
    void remove_at(size_t index);

    /**
     * \brief
     * Applies a function to all elements of the list.
     * \param func The function with one parameter of the type T
     * which returns value of the type T.
     */
    void transform(T (*func)(T arg));

    /**
     * \brief
     * Calls a function with each element of the list as a parameter.
    * \param func The function with one parameter of the type T.
     */
    void foreach(void (*func)(T arg));

    /**
     * \brief
     * Checks if the list contains the value.
     * \param val The value for check.
     * \return True if the value is found in the list, false otherwise.
     */
    bool contains(T val) const;

    /**
     * \brief
     * Finds an index of the first element of the list, equals to value.
     * \param val The value to find.
     * \return The index of the found element if the list
     * contains the value, -1 otherwise.
     */
    long long find(T val) const;

private:
    struct node
    {
        explicit node(T _data) : data(_data){}
        T data;
        std::shared_ptr<node> next;
    };
    
    std::shared_ptr<node> m_head = nullptr;
    std::shared_ptr<node> m_tail = nullptr;
    size_t m_size = 0;

    //Iteration over list
public:
    class iterator
    {
    public:
        explicit iterator(const std::shared_ptr<node>& current) : m_current(current){}
        iterator& operator++() { m_current = m_current->next; return *this; }
        T& operator*() const { return m_current->data; }
        T& operator*() { return m_current->data; }
        bool operator==(const iterator& other) const { return m_current == other.m_current; }
        bool operator!=(const iterator& other) const { return m_current != other.m_current; }
    private:
        std::shared_ptr<node> m_current;
    };
    
    iterator begin() { return iterator(m_head); }
    iterator begin() const { return iterator(m_head); }
    iterator end() { return iterator(nullptr); }
    iterator end() const { return iterator(nullptr); }
};


// ***********************
// *                     *
// *   Implementation.   *
// *                     *
// ***********************

template <typename T>
T list<T>::head() const
{
    if(m_size == 0) throw -1;
    return m_head->data;
}

template <typename T>
T list<T>::tail() const
{
    if(m_size == 0) throw -1;
    return m_tail->data;
}

template <typename T>
T& list<T>::operator[](const size_t index)
{
    if(index >= m_size || index < 0) throw -1;

    std::shared_ptr<node> tmp = m_head;
    for(size_t i = 0; i < index; i++)
    {
        tmp = tmp->next;
        if(tmp == nullptr) throw -1;
    }

    return tmp->data;
}

template <typename T>
std::vector<T> list<T>::to_vector()
{
    std::vector<T> vec;    

    std::shared_ptr<node> tmp = m_head;
    for(size_t i = 0; i < m_size; i++)
    {
        vec.push_back(tmp->data);
        tmp = tmp->next;
    }

    return vec;
}

template <typename T>
void list<T>::push_back(T data)
{
    std::shared_ptr<node> new_node = std::make_shared<node>(data);
    if(m_size == 0) m_head = new_node;
    else m_tail->next = new_node;
    m_tail = new_node;
    m_size++;
}

template <typename T>
void list<T>::push_front(T data)
{
    if(m_size == 0)
    {
        push_back(data);
        return;
    }
    
    auto new_node = std::make_shared<node>(data);
    new_node->next = m_head;
    m_head = new_node;
    if(m_size == 1) m_tail = m_head->next;
    
    m_size++;
}

template <typename T>
void list<T>::insert(T data, const size_t index)
{
    if(index > m_size || index < 0) throw -1;
    if(index == m_size)
    {
        push_back(data);
        return;
    }
    if(index == 0)
    {
        push_front(data);
        return;
    }

    auto tmp = m_head;
    auto new_node = std::make_shared<node>(data);
    
    for(size_t i = 0; i < index - 1; i++)
    {
        tmp = tmp->next;
    }
    
    new_node->next = tmp->next;
    tmp->next = new_node;
    m_size++;
}

template <typename T>
T list<T>::pop_back()
{
    if(m_size== 0) throw -1;
    
    T return_data = m_tail->data;

    if(m_size == 1)
    {
        m_tail = nullptr;
        m_head = nullptr;
        m_size--;
        return return_data;
    }

    auto tmp = m_head;
    for(size_t i = 0; i < m_size - 2; i++)
    {
        tmp = tmp->next;
    }
    
    m_tail = tmp;
    m_size--;
    
    return return_data;
}

template <typename T>
T list<T>::pop_front()
{
    if(m_size == 0) throw -1;
    if(m_size == 1) return pop_back();
    
    T data = m_head->data;
    m_head = m_head->next;
    m_size--;
    
    return data;
}

template <typename T>
void list<T>::remove_at(size_t index)
{
    if(m_size == 0 || index < 0) throw -1;
    if(index == 0)
    {
        pop_front();
        return;
    }
    if(index == m_size - 1)
    {
        pop_back();
        return;
    }

    if(m_size == 1)
    {
        m_head = nullptr;
        m_tail = nullptr;
        return;
    }

    auto tmp = m_head;
    for(size_t i = 0; i < index - 1; i++)
    {
        tmp = tmp->next;
    }
    
    tmp->next = tmp->next->next;
    m_size--;
}

template <typename T>
void list<T>::transform(T(* func)(T arg))
{
    auto tmp = m_head;
    for(size_t i = 0; i < m_size; i++)
    {
        tmp->data = func(tmp->data);
        tmp = tmp->next;
    }
}

template <typename T>
void list<T>::foreach(void(* func)(T arg))
{
    auto tmp = m_head;
    for(size_t i = 0; i < m_size; i++)
    {
        func(tmp->data);
        tmp = tmp->next;
    }
}

template <typename T>
bool list<T>::contains(T val) const
{
    for(const auto el : *this)
    {
        if(el == val) return true;
    }
    return false;
}

template <typename T>
long long list<T>::find(T val) const
{
    int index = 0;
    for(const auto el : *this)
    {
        if(el == val) return index;
        index++;
    }
    return -1;
}
