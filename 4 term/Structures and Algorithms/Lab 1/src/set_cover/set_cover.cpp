#include "genetic.hpp"
#include "naive.hpp"
#include <chrono>
#include <iostream>
#include <set>

using namespace solver;

using Set = std::set<int>;

struct Item
{
    size_t cost;
    Set set;
    Item(size_t cost, const Set &set)
        : cost(cost), set(set)
    {
    }
};

void print_set(auto set, size_t indent)
{
    for (size_t i = 0; i < indent; i++)
    {
        std::cout << " ";
    }
    for (const auto &item : set)
    {
        std::cout << item << " ";
    }
}

bool is_satisfies(const std::vector<Item> &items, const Set &set)
{
    Set accumulator;
    for (const auto &item : items)
    {
        accumulator.insert(item.set.begin(), item.set.end());
    }

    return std::includes(
        accumulator.begin(), accumulator.end(),
 
		set.begin(), set.end());
}

intmax_t total_cost(const std::vector<Item> &items)
{
    intmax_t cost = 0;
    for (const auto &item : items)
    {
        cost += item.cost;
    }
    return cost;
}

get_key_t<Item> make_get_key(const Set &set)
{
    return [=](const std::vector<Item> &items) {
        return is_satisfies(items, set) ? -total_cost(items) : INTMAX_MIN;
    };
}

std::vector<Item> eval_max_naive(const std::vector<Item> &items, const Set &set)
{
    auto eval_max = naive::make_eval(make_get_key(set));
    return eval_max(items);
}

std::vector<Item> eval_genetic(const std::vector<Item> &items, const Set &set)
{
    auto eval = genetic::make_eval(make_get_key(set), 0.1, 0.6, 0.15);
    return eval(items);
}

void bench(
    const std::vector<Item> &items,
    const Set &set,
    const std::string &name,
    std::function<std::vector<Item>(const std::vector<Item> &, const Set &)> eval_max)
{
    namespace ch = std::chrono;

    auto begin = std::chrono::high_resolution_clock::now();
    auto result = eval_max(items, set);
    auto end = ch::high_resolution_clock::now();
    ch::duration<double, std::milli> time = end - begin;

    std::cout << "Set:\n";
    print_set(set, 0);
    std::cout << "Total cost: " << total_cost(result) << '\n';
    std::cout << "Subsets:\n";
    for (const auto &item : result)
    {
        std::cout << "Cost: " << item.cost << ", items: ";
        print_set(item.set, 3);
        std::cout << '\n';
    }

    std::cout << name << ":\n"
              << "  time: " << time << "\n"
              << std::endl;
}

int main()
{
    const Set set{1, 4, 7, 9, 13, 16, 21, 34, 35, 47, 54, 59, 60};

    const std::vector<Item> items{
        Item(200, {1, 7, 8}),
        Item(300, {4, 7, 13, 14}),
        Item(500, {13, 16, 21}),
        Item(100, {3, 13}),
        Item(300, {1, 3, 9, 16, 21}),
        Item(350, {34}),
        Item(50, {1, 60}),
        Item(25, {47, 59}),
        Item(40, {21, 34, 60}),
        Item(60, {35, 54})};

    bench(items, set, "Naive", eval_max_naive);
    bench(items, set, "Genetic", eval_genetic);
    return 0;
}
