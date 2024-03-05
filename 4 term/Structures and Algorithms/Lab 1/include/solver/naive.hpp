#ifndef NAIVE_HPP
#define NAIVE_HPP

#include "common.hpp"
#include <cstdint>

namespace solver::naive
{
constexpr static inline Bits bits_from_number(uint64_t n, size_t size)
{
    Bits bits(size);
    for (size_t i = 0; i < size; i++)
    {
        bits[i] = (bool)(n & (1ul << i));
    }
    return bits;
}

template <typename Item>
constexpr std::vector<Item> eval_max(
    const std::vector<Item> &items,
    compare<Item> compare)
{
    const get_chosen_t<Item> get_chosen = make_get_chosen(items);
    std::vector<Item> max;

    for (uint64_t selected = 0; selected < (1ul << items.size()); selected++)
    {
        Bits bits = bits_from_number(selected, items.size());
        std::vector<Item> sol = get_chosen(bits);
        if (compare(sol, max))
            max = sol;
    }

    return max;
}

template <typename Item>
constexpr eval_t<Item> make_eval(compare<Item> compare)
{
    return [=](const std::vector<Item> &items) constexpr {
        return eval_max(items, compare);
    };
}
} // namespace solver::naive

#endif // NAIVE_HPP
