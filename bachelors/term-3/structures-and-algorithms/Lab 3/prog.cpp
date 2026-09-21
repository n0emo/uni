#include <iostream>
#include <memory>
#include <vector>

#include "include/HashTable.hpp"

int main() {
    auto table = std::make_unique<HashTable<std::string, std::string>>();
    return 0;
}
