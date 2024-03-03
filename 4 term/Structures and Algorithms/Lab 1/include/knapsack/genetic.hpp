#ifndef GENETIC_HPP
#define GENETIC_HPP

#include "common.hpp"
#include <string>

namespace ks::genetic
{
struct Sample
{
    Bits bits;
    size_t weight;
    size_t value;
};

Knapsack eval_max(const std::vector<Item> &items, size_t max_weight);
std::vector<Sample> generate_population(
    const std::vector<Item> &items, size_t count, size_t max_weight);
void next_generation(
    const std::vector<Item> &items, std::vector<Sample> &population, size_t max_weight);
bool rand_bool();
Bits random_bits(size_t count);
bool mutate(Bits &bits, float rate);
std::string bits_str(const Bits &bits);
} // namespace ks::genetic

#endif // GENETIC_HPP
