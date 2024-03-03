#ifndef NAIVE_HPP
#define NAIVE_HPP

#include "common.hpp"

namespace ks::naive
{
Knapsack eval_max(const std::vector<Item> &items, size_t max_size);
} // namespace ks::naive

#endif // NAIVE_HPP
