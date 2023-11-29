#include <iostream>
#include <vector>

#include "HashTable.hpp"

struct PolynomialHash {
    struct Powers {
        static const size_t INITIAL_SIZE = 1;
        static const size_t PRIME = 31;

        Powers() {
            _vec[0] = 1;
            for (size_t i = 1; i < INITIAL_SIZE; i++) {
                _vec[i] = _vec[i - 1] * PRIME;
            }
        }

        size_t operator[](size_t index) {
            if (index >= _size) {
                expand();
            }
            return _vec[index];
        }

    private:
        std::vector<size_t> _vec = std::vector<size_t>(INITIAL_SIZE);
        size_t _size = INITIAL_SIZE;

        void expand() {
            size_t new_size = _size * 2;
            _vec.resize(new_size);
            for (size_t i = 0; i < new_size - _size; i++) {
                _vec[_size + i] = _vec[_size + i - 1] * PRIME;
            }
            _size = new_size;
        }
    };

    inline static Powers powers = Powers();

    size_t operator()(const std::string& s) const {
        size_t hash = 0;
        for (size_t i = 0; i < s.size(); i++) {
            hash = (hash + s[i]) * powers[i];
        }
        // std::cout << "Hash for \"" << s << "\": " << hash << std::endl;
        return hash;
    }
};

int main() {
    HashTable<std::string, int> table;
    for (int i = 1; i < 100; i++) {
        auto s = "- [] " + std::to_string(i);
        table.add(s, i * 5);
    }

    // table.show_buckets();
    std::cout << "Collisions: " << table.count_collisions() << std::endl;

    // for (auto pair : table) {
    //     std::cout << pair.key << " " << pair.value << std::endl;
    // }

    std::cout << table.get("- [] 10").value() << std::endl;

    table.show_buckets();
    // std::cout << table.get("- [] 2").value() << std::endl;
    // std::cout << table.get("- [] 3").value() << std::endl;
    // std::cout << table.get("- [] 4").value() << std::endl;
    // std::cout << table.get("- [] 5").value() << std::endl;
    // std::cout << table.get("- [] 6").value() << std::endl;
    // std::cout << table.get("- [] 7").value() << std::endl;
    // std::cout << table.get("- [] 8").value() << std::endl;
    // std::cout << table.get("- [] 9").value() << std::endl;
    // std::cout << table.get("- [] 10").value() << std::endl;
    // std::cout << table.get("- [] 11").value() << std::endl;
    // std::cout << table.get("- [] 12").value() << std::endl;
    return 0;
}
