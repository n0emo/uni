#include "common.hpp"
#include "genetic.hpp"
#include "naive.hpp"

#include <iostream>
#include <vector>

using namespace ks;

int main()
{
    std::vector<Item> items;
    items.emplace_back(Item(5, 50));
    items.emplace_back(Item(13, 20));
    items.emplace_back(Item(9, 19));
    items.emplace_back(Item(2, 1));
    items.emplace_back(Item(52, 50));
    items.emplace_back(Item(2, 2));
    items.emplace_back(Item(5, 191));
    items.emplace_back(Item(9, 153));
    items.emplace_back(Item(10, 10));
    items.emplace_back(Item(24, 10));
    items.emplace_back(Item(27, 10));
    items.emplace_back(Item(41, 12));
    items.emplace_back(Item(6, 30));
    items.emplace_back(Item(60, 25));
    items.emplace_back(Item(2, 10));
    items.emplace_back(Item(4, 123));

    auto result = naive::eval_max(items, 100);
    std::cout << result.value() << " " << result.weight() << std::endl;
    result = genetic::eval_max(items, 100);
    std::cout << result.value() << " " << result.weight() << std::endl;
    return 0;
}
