#include <cstddef>
#include <cstdint>
#include <iostream>
#include <vector>

struct Item
{
    size_t weight;
    size_t value;
    Item(size_t weight, size_t value) : weight(weight), value(value)
    {
    }
};

size_t ks_eval_weight(const std::vector<Item> &ks)
{
    size_t sum = 0;
    for (size_t i = 0; i < ks.size(); i++)
    {
        sum += ks[i].weight;
    }
    return sum;
}

size_t ks_eval_value(const std::vector<Item> &ks)
{
    size_t sum = 0;
    for (size_t i = 0; i < ks.size(); i++)
    {
        sum += ks[i].value;
    }
    return sum;
}

std::vector<Item> ks_eval_max(const std::vector<Item> &items, size_t max_size)
{
    std::vector<Item> max_items;
    size_t max_value = 0;

    std::vector<Item> temp_items;

    for (uint64_t selected = 1; selected < 1ul << items.size(); selected++)
    {
        temp_items.clear();
        for (size_t i = 0; i < items.size(); i++)
        {
            if (selected & (1ul << i))
                temp_items.emplace_back(items[i]);
        }

        size_t temp_size = ks_eval_weight(temp_items);
        if (temp_size <= max_size)
        {
            size_t temp_value = ks_eval_value(temp_items);
            if (temp_value > max_value)
            {
                max_items = std::vector(temp_items);
                max_value = temp_value;
            }
        }
    }

    return max_items;
}

int main()
{
    std::vector<Item> items;
    items.emplace_back(Item(5, 50));
    items.emplace_back(Item(13, 20));
    items.emplace_back(Item(9, 19));
    items.emplace_back(Item(2, 1));

    auto result = ks_eval_max(items, 15);
    std::cout << ks_eval_value(result) << std::endl;
    return 0;
}
