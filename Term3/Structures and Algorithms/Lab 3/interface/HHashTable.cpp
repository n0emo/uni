#include <cstddef>
#include <unordered_map>

#include "../include/HashTable.hpp"

extern "C" {
#include "../include/HHashTable.h"
}

void ht_s_create_(void** ht) {
    using namespace std;
    try {
        *ht = reinterpret_cast<void*>(
            new HashTable<string, string, hash<string>>());
    } catch (exception) {
        *ht = NULL;
    }
}

void ht_s_destroy_(void** ht) {
    using namespace std;
    auto ptr_to_del =
        reinterpret_cast<HashTable<string, string, hash<string>>**>(ht);
    delete *ptr_to_del;
}

void ht_s_add_(void** ht, const char* key, const char* value) {
    using namespace std;
    auto table =
        reinterpret_cast<HashTable<string, string, hash<string>>*>(*ht);
    table->add(key, value);
}

// TODO: look how to use c str in fortran
void ht_s_get_(void** ht, const char* key, const char* result) {
    using namespace std;
    auto table =
        reinterpret_cast<HashTable<string, string, hash<string>>*>(*ht);
    auto result_str = table->get(key).value_or("NULL");
    std::cout << result_str << std::endl;
    result = result_str.c_str();
}

void ht_s_count_collisions_(void** ht, int* result) {
    using namespace std;
    auto table =
        reinterpret_cast<HashTable<string, string, hash<string>>*>(*ht);
    *result = table->count_collisions();
}

void ht_p_create_(void** ht) {
    using namespace std;
    try {
        *ht = reinterpret_cast<void*>(
            new HashTable<string, string, PolynomialHash>());
    } catch (exception) {
        *ht = NULL;
    }
}

void ht_p_destroy_(void** ht) {
    using namespace std;
    auto ptr_to_del =
        reinterpret_cast<HashTable<string, string, PolynomialHash>**>(ht);
    delete *ptr_to_del;
}

void ht_p_add_(void** ht, const char* key, const char* value) {
    using namespace std;
    auto table =
        reinterpret_cast<HashTable<string, string, PolynomialHash>*>(*ht);
    table->add(key, value);
}

void ht_p_get_(void** ht, const char* key, const char* result) {
    using namespace std;
    auto table =
        reinterpret_cast<HashTable<string, string, PolynomialHash>*>(*ht);
    auto result_str = table->get(key).value_or("NULL");
    std::cout << result_str << std::endl;
    result = result_str.c_str();
}

void ht_p_count_collisions_(void** ht, int* result) {
    using namespace std;
    auto table =
        reinterpret_cast<HashTable<string, string, PolynomialHash>*>(*ht);
    *result = table->count_collisions();
}

void map_create_(void** map) {
    using namespace std;
    try {
        *map = reinterpret_cast<void*>(new unordered_map<string, string>());
    } catch (exception) {
        *map = NULL;
    }
}

void map_destroy_(void** map) {
    using namespace std;
    auto mp = reinterpret_cast<unordered_map<string, string>*>(*map);
    delete mp;
}

void map_add_(void** map, const char* key, const char* value) {
    using namespace std;
    auto mp = reinterpret_cast<unordered_map<string, string>*>(*map);
    mp->insert(pair(key, value));
}
