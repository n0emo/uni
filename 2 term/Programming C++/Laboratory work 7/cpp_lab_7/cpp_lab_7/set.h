#pragma once

#include <iostream>
#include <memory>

#include "list.h"

template <typename T>
class set
{
public:
    set() : m_list(std::make_unique<list<T>>()) {}
    set(const set& _set) : m_list(std::make_unique<list<T>>(_set.m_list)) {}

    // поиск объекта в массиве по ключ
    long long find(T val) const { return m_list->find(val); }

    // Добавление объедка в массив
    bool try_add(T data)
    {
        if(m_list->contains(data)) return false;
        m_list->push_back(data);
        return false;
    }

    // Удаление объедка из массива
    bool try_delete(T data)
    {
        auto index = m_list->find(data);
        if(index == -1) return false;
        m_list->remove_at(index);
        return true;
    }

    // просмотр состояния массива объектов.
    friend std::ostream& operator<<(std::ostream& os, const set& set)
    {
        for(auto x: *set.m_list) os << x << "\n";
        os << '\n';
        return os;
    }

    size_t size() {return m_list->size(); }

private:
    std::unique_ptr<list<T>> m_list;
};
