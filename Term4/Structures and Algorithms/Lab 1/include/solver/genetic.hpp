#ifndef GENETIC_HPP
#define GENETIC_HPP

#include "common.hpp"
#include "ctime"
#include <cmath>
#include <sstream>
#include <string>

namespace solver::genetic
{
static inline bool rand_bool(float prob)
{
    return std::rand() < RAND_MAX * prob;
}

static inline Bits random_bits(size_t count, float prob)
{
    Bits result(count);
    for (size_t i = 0; i < count; i++)
    {
        result[i] = rand_bool(prob);
    }

    return result;
}

static inline std::vector<Bits> generate_population(size_t size, size_t count, float prob)
{
    std::vector<Bits> population(count);
    for (size_t i = 0; i < count; i++)
    {
        population[i] = random_bits(size, prob);
    }

    return population;
}

static inline void mutate(Bits &bits, float rate)
{
    for (size_t i = 0; i < bits.size(); i++)
    {
        if (std::rand() < RAND_MAX * rate)
            bits[i] = !bits[i];
    }
}

template <typename Item>
std::vector<Bits> next_generation(
    const std::vector<Bits> &population,
    get_key_t<Item> get_key,
    get_chosen_t<Item> get_chosen,
    float survival_rate,
    float mutation_rate)
{
    using pair = std::pair<std::vector<Bits>::const_iterator, intmax_t>;

    size_t size = population.size();
    std::vector<pair> solutions;
    solutions.reserve(population.size());
    for (std::vector<Bits>::const_iterator iter = population.cbegin(); iter != population.cend(); ++iter)
    {
        solutions.emplace_back(pair({iter, get_key(get_chosen(*iter))}));
    }

    std::sort(solutions.begin(), solutions.end(),
              [=](auto a, auto b) { return std::get<1>(a) > std::get<1>(b); });

    size_t survived = population.size() * survival_rate;

    std::vector<Bits> new_population;
    new_population.reserve(size);

    for (size_t i = 0; i < survived; i++)
    {
        new_population.emplace_back(*std::get<0>(solutions[i]));
    }

    for (size_t distance = 2;; distance++)
    {
        for (size_t i = 0; i <= survived - distance; i += distance)
        {
            if (new_population.size() == size)
                return new_population;

            auto mother = new_population[i];
            auto father = new_population[i + distance - 1];
            bool mother_first = rand_bool(0.5);
            auto &first = mother_first ? mother : father;
            auto &second = mother_first ? father : mother;
            size_t half_len = first.size() / 2;

            Bits child(mother.size());
            for (size_t j = 0; j < half_len; j++)
            {
                child[j] = first[j];
                child[j + half_len] = second[j];
            }
            mutate(child, mutation_rate);

            new_population.emplace_back(child);
        }
    }
}

template <typename Item>
std::vector<Item> eval_max(
    const std::vector<Item> &items,
    get_key_t<Item> get_key,
    float initial_prob,
    float survival_rate,
    float mutation_rate)
{
    std::srand(std::time(nullptr));
    const get_chosen_t<Item> get_chosen = make_get_chosen(items);
    size_t size = items.size();
    size_t pop_size = size * std::log2(size) * 2;
    size_t gen_count = size * std::log2(size) * 16;
    auto population = generate_population(size, pop_size, initial_prob);

    for (size_t i = 0; i < gen_count; i++)
    {
        population = next_generation(population, get_key, get_chosen, survival_rate, mutation_rate);
    }

    std::vector<Item> max = get_chosen(population[0]);
    intmax_t max_key = get_key(max);
    for (size_t i = 1; i < population.size(); i++)
    {
        auto sol = get_chosen(population[i]);
        if (get_key(sol) > max_key)
        {
            max = sol;
            max_key = get_key(sol);
        }
    }

    return max;
}

template <typename Item>
constexpr eval_t<Item> make_eval(
    get_key_t<Item> get_key,
    float initial_prob,
    float survival_rate,
    float mutation_rate)
{
    return [=](const std::vector<Item> &items) {
        return eval_max(items, get_key, initial_prob, survival_rate, mutation_rate);
    };
}

static inline std::string bits_str(const Bits &bits)
{
    std::stringstream ss;
    for (size_t i = 0; i < bits.size(); i++)
    {
        ss << bits[i];
    }
    return ss.str();
}
} // namespace solver::genetic

#endif // GENETIC_HPP
