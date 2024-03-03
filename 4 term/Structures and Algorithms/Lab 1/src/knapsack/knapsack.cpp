#include "common.hpp"
#include "genetic.hpp"
#include "naive.hpp"

#include <chrono>
#include <functional>
#include <iostream>
#include <vector>

using namespace ks;

void bench(
    const std::vector<Item> &items,
    const std::string &name,
    std::function<Knapsack(const std::vector<Item> &, size_t)> eval_max)
{
    namespace ch = std::chrono;

    auto begin = std::chrono::high_resolution_clock::now();
    auto result = eval_max(items, 100);
    auto end = ch::high_resolution_clock::now();
    ch::duration<double, std::milli> time = end - begin;
    std::cout << name << ":\n"
              << "  value: " << result.value() << '\n'
              << "  weight: " << result.weight() << '\n'
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
    };

    bench(items, "Naive", naive::eval_max);
    bench(items, "Genetic", genetic::eval_max);

    return 0;
}
