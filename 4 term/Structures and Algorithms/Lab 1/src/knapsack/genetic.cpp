#include "genetic.hpp"
#include <algorithm>
#include <chrono>
#include <cstdlib>
#include <ctime>
#include <iostream>
#include <sstream>

namespace ks::genetic
{
Knapsack eval_max(const std::vector<Item> &items, size_t max_weight)
{
    std::srand(std::time(nullptr));
    auto population = generate_population(items, items.size() * items.size(), max_weight);
    for (size_t i = 0; i < population.size(); i++)
    {
        // auto begin = std::chrono::high_resolution_clock::now();
        next_generation(items, population, max_weight);
        // auto end = std::chrono::high_resolution_clock::now();
        // std::cout << (end - begin).count() << ' ' << population.size() << '\n';
    }

    Sample max = population[0];
    for (size_t i = 0; i < population.size(); i++)
    {
        if (population[i].weight <= max_weight && max.value <= population[i].value)
        {
            max = population[i];
        }
    }
    std::cout << max.value << " " << max.weight << std::endl;

    return Knapsack(items, max.bits);
}

std::vector<Sample> generate_population(
    const std::vector<Item> &items, size_t count, size_t max_weight)
{
    std::vector<Sample> population(count);
    for (size_t i = 0; i < count; i++)
    {
        Bits bits = random_bits(items.size());
        Knapsack ks(items, bits);
        size_t weight = ks.weight();
        size_t value = weight > max_weight ? 0 : ks.value();
        population[i] = {.bits = bits, .weight = weight, .value = value};
    }

    return population;
}

void next_generation(
    const std::vector<Item> &items, std::vector<Sample> &population, size_t max_weight)
{
    std::sort(population.begin(), population.end(),
              [](auto a, auto b) { return a.value > b.value; });

    size_t size = population.size();
    size_t half = population.size() * 0.75;
    population.resize(half);

    for (size_t distance = 2;; distance++)
    {
        for (size_t i = 0; i <= half - distance; i += distance)
        {
            if (population.size() == size)
                return;

            auto mother = population[i];
            auto father = population[i + distance - 1];
            bool mother_first = rand_bool();
            auto &first = mother_first ? mother.bits : father.bits;
            auto &second = mother_first ? father.bits : mother.bits;
            size_t half_len = first.size() / 2;

            Bits child_bits(mother.bits.size());
            for (size_t j = 0; j < half_len; j++)
            {
                child_bits[j] = first[j];
                child_bits[j + half_len] = second[j];
            }
            mutate(child_bits, 0.01);

            auto child_ks = Knapsack(items, child_bits);
            population.emplace_back(Sample{
                .bits = child_bits,
                .weight = child_ks.weight(),
                .value = child_ks.weight() > max_weight ? 0 : child_ks.value()});
        }
    }
}

bool rand_bool()
{
    return std::rand() < RAND_MAX / 2;
}

Bits random_bits(size_t count)
{
    Bits result(count);
    for (size_t i = 0; i < count; i++)
    {
        result[i] = rand_bool();
    }

    return result;
}

bool mutate(Bits &bits, float rate)
{
    bool mutated = false;
    for (size_t i = 0; i < bits.size(); i++)
    {
        if (std::rand() < RAND_MAX * rate)
        {
            mutated = true;
            bits[i] = !bits[i];
        }
    }
    return mutated;
}

std::string bits_str(const Bits &bits)
{
    std::stringstream ss;
    for (size_t i = 0; i < bits.size(); i++)
    {
        ss << bits[i];
    }
    return ss.str();
}
} // namespace ks::genetic
