#ifndef COMMON_HPP
#define COMMON_HPP

#include <cstddef>
#include <cstdint>
#include <functional>
#include <vector>

namespace solver
{
typedef std::vector<char> Bits;

template <typename Item>
using get_key_t = std::function<intmax_t(const std::vector<Item> &)>;

template <typename Item>
using get_chosen_t = std::function<std::vector<Item>(Bits bits)>;

template <typename Item>
using eval_t = std::function<std::vector<Item>(const std::vector<Item> &)>;

template <typename Item>
constexpr get_chosen_t<Item> make_get_chosen(const std::vector<Item> &items)
{
    return [&](Bits bits) constexpr {
        std::vector<Item> result;
        for (size_t i = 0; i < bits.size(); i++)
        {
            if (bits[i])
                result.emplace_back(items[i]);
        }

        return result;
    };
}
} // namespace solver

#endif // COMMON_HPP
