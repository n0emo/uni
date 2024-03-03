#include "naive.hpp"

#include <cstdint>
namespace ks::naive
{
Knapsack eval_max(const std::vector<Item> &items, size_t max_weight)
{
    Knapsack max_ks;
    size_t max_value = 0;

    Knapsack temp;

    for (uint64_t selected = 1; selected < 1ul << items.size(); selected++)
    {
        temp.clear();
        Bits bits;
        for (size_t i = 0; i < items.size(); i++)
        {
            if (selected & (1ul << i))
                temp.add(items[i]);
        }

        size_t temp_weight = temp.weight();
        if (temp_weight <= max_weight)
        {
            size_t temp_value = temp.value();
            if (temp_value > max_value)
            {
                max_ks = Knapsack(temp);
                max_value = temp_value;
            }
        }
    }

    return max_ks;
}
} // namespace ks::naive
