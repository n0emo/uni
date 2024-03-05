#include "common.hpp"
#include "genetic.hpp"
#include "naive.hpp"

#include <chrono>
#include <functional>
#include <iostream>
#include <vector>

using namespace solver;

struct Item
{
    size_t weight;
    size_t value;
    Item(size_t weight, size_t value)
        : weight(weight), value(value)
    {
    }
};

size_t weight(const std::vector<Item> &items)
{
    size_t weight = 0;
    for (const auto &item : items)
    {
        weight += item.weight;
    }
    return weight;
}

size_t value(const std::vector<Item> &items, size_t max_weight)
{
    size_t value = 0;
    size_t weight = 0;
    for (const auto &item : items)
    {
        value += item.value;
        weight += item.weight;
    }
    return weight <= max_weight ? value : 0;
}

compare<Item> make_compare(size_t max_weight)
{
    return [=](const std::vector<Item> &a, const std::vector<Item> &b) {
        return value(a, max_weight) > value(b, max_weight);
    };
}

std::vector<Item> eval_max_naive(const std::vector<Item> &items, size_t max_weight)
{
    auto eval_max = naive::make_eval(make_compare(max_weight));
    return eval_max(items);
}

std::vector<Item> eval_genetic(const std::vector<Item> &items, size_t max_weight)
{
    auto eval = genetic::make_eval(make_compare(max_weight), 0.1, 0.6, 0.15);
    return eval(items);
}

void bench(
    const std::vector<Item> &items,
    const std::string &name,
    std::function<std::vector<Item>(const std::vector<Item> &, size_t)> eval_max)
{
    namespace ch = std::chrono;

    size_t max_weight = 20;

    auto begin = std::chrono::high_resolution_clock::now();
    auto result = eval_max(items, max_weight);
    auto end = ch::high_resolution_clock::now();
    ch::duration<double, std::milli> time = end - begin;
    std::cout << name << ":\n"
              << "  value: " << value(result, max_weight) << '\n'
              << "  weight: " << weight(result) << '\n'
              << "  time: " << time << "\n"
              << std::endl;
}

int main()
{
    std::vector<Item> items{
        Item(5, 50),
        Item(13, 20),
        Item(9, 19),
        Item(2, 1),
        Item(52, 50),
        Item(2, 2),
        Item(5, 191),
        Item(9, 153),
        Item(10, 10),
        Item(24, 10),
        Item(27, 10),
        Item(41, 12),
        Item(6, 30),
        Item(60, 255),
        Item(2, 1),
        Item(4, 13),
        Item(5, 56),
        Item(12, 20),
        Item(32, 19),
        Item(22, 12),
        Item(1, 19),
        Item(2, 1),
        Item(10, 190),
        Item(20, 10),
        Item(13, 19),
        Item(12, 1),
        Item(30, 190),
        Item(22, 10),
        Item(5, 50),
        Item(13, 20),
        Item(9, 19),
        Item(2, 1),
        Item(52, 50),
        Item(2, 2),
        Item(5, 191),
        Item(9, 153),
        Item(10, 10),
        Item(24, 10),
        Item(27, 10),
        Item(41, 12),
        Item(6, 30),
        Item(60, 255),
        Item(2, 1),
        Item(4, 13),
        Item(5, 56),
        Item(12, 20),
        Item(32, 19),
        Item(22, 12),
        Item(1, 19),
        Item(2, 1),
        Item(10, 190),
        Item(20, 10),
        Item(13, 19),
        Item(12, 1),
        Item(30, 190),
        Item(22, 10),
    };

    // bench(items, "Naive", eval_max_naive);
    bench(items, "Genetic", eval_genetic);

    return 0;
}
