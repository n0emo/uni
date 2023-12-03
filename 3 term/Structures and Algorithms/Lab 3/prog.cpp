#include <iostream>
#include <memory>
#include <vector>

#include "include/HashTable.hpp"

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
    auto table = std::make_unique<HashTable<std::string, std::string>>();
    return 0;
}
