#include <iostream>
#include <vector>

#include "HashTable.hpp"

int main() {
    HashTable<std::string, int> table;
    for (int i = 1; i < 13; i++) {
        auto s = "- [] " + std::to_string(i);
        table.add(s, i * 5);
    }

    table.show_buckets();

    for (auto pair : table) {
        std::cout << pair.key << " " << pair.value << std::endl;
    }

    std::cout << table.get("- [] 1").value() << std::endl;
    std::cout << table.get("- [] 2").value() << std::endl;
    std::cout << table.get("- [] 3").value() << std::endl;
    std::cout << table.get("- [] 4").value() << std::endl;
    std::cout << table.get("- [] 5").value() << std::endl;
    std::cout << table.get("- [] 6").value() << std::endl;
    std::cout << table.get("- [] 7").value() << std::endl;
    std::cout << table.get("- [] 8").value() << std::endl;
    std::cout << table.get("- [] 9").value() << std::endl;
    std::cout << table.get("- [] 10").value() << std::endl;
    std::cout << table.get("- [] 11").value() << std::endl;
    std::cout << table.get("- [] 12").value() << std::endl;
    return 0;
}
