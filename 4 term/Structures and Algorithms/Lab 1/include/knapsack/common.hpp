#ifndef COMMON_HPP
#define COMMON_HPP

#include <cassert>
#include <cstddef>
#include <vector>

namespace ks
{
typedef std::vector<char> Bits;

struct Item
{
    size_t weight;
    size_t value;
    Item(size_t weight, size_t value)
        : weight(weight), value(value)
    {
    }
};

struct Knapsack
{
    std::vector<Item> items;

    Knapsack() = default;

    Knapsack(std::vector<Item> items, Bits choice)
    {
        assert(items.size() == choice.size());
        for (size_t i = 0; i < choice.size(); i++)
        {
            if (choice[i])
                this->items.emplace_back(items[i]);
        }
    }

    Knapsack(std::vector<Item> items)
        : items(items)
    {
    }

    void add(const Item &item)
    {
        items.emplace_back(item);
    }

    void clear()
    {
        items.clear();
    }

    size_t weight()
    {
        size_t sum = 0;
        for (size_t i = 0; i < items.size(); i++)
        {
            sum += items[i].weight;
        }
        return sum;
    }

    size_t value()
    {
        size_t sum = 0;
        for (size_t i = 0; i < items.size(); i++)
        {
            sum += items[i].value;
        }
        return sum;
    }
};
} // namespace ks

#endif // COMMON_HPP
