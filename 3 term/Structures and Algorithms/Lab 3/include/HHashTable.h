#ifndef HHASHTABLE_H
#define HHASHTABLE_H

struct HHashTable;
typedef struct HHashTable HHashTable;

void ht_s_create_(void** ht);
void ht_s_destroy_(void** ht);

void ht_s_add_(void** ht, const char* key, const char* value);
void ht_s_get_(void** ht, const char* key, const char* result);

void ht_s_count_collisions_(void** ht, int* result);

#endif  // HHASHTABLE_H
