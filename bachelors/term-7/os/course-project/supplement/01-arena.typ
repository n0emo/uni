== Листинг src/core/allocators/arena.c

```c
#include <mew/core/allocators/arena.h>
#include <stdlib.h>
#include <string.h>

void *arena_alloc(void *data, size_t bytes) {
    Arena *arena = (Arena *)data;
    size_t size = (bytes + sizeof(uintptr_t) - 1) / sizeof(uintptr_t);

    if (arena->begin == NULL) {
        assert(arena->end == NULL);
        size_t capacity = REGION_DEFAULT_CAPACITY;
        if (capacity < size)
            capacity = size;
        arena->begin = new_region(capacity);
        arena->end = arena->begin;
    }

    while (arena->end->count + size > arena->end->capacity && arena->end->next != NULL) {
        arena->end = arena->end->next;
    }

    if (arena->end->count + size > arena->end->capacity) {
        assert(arena->end->next == NULL);
        size_t capacity = REGION_DEFAULT_CAPACITY;
        if (capacity < size)
            capacity = size;
        arena->end->next = new_region(capacity);
        arena->end = arena->end->next;
    }

    void *result = &arena->end->data[arena->end->count];
    arena->end->count += size;
    return result;
}

void arena_free(void *data, void *ptr) {
    (void)data;
    (void)ptr;
}

void *arena_calloc(void *data, size_t count, size_t size) {
    void *new = arena_alloc(data, count * size);
    if (new) {
        memset(new, 0, count * size);
    }

    return new;
}

void *arena_realloc(void *data, void *ptr, size_t old_size, size_t new_size) {
    void *new = arena_alloc(data, new_size);
    memcpy(new, ptr, old_size);

    return new;
}

Allocator new_arena_allocator(Arena *arena) {
    return (Allocator) {
        .data = arena,
        .ftable = &arena_table,
    };
}

void arena_free_arena(Arena *arena) {
    Region *region = arena->begin;
    while (region != NULL) {
        Region *next = region->next;
        free_region(region);
        region = next;
    }

    arena->begin = NULL;
    arena->end = NULL;
}

Region *new_region(size_t capacity) {
    size_t size = sizeof(Region) + sizeof(uintptr_t) * capacity;
    Region *region = malloc(size);

    region->next = NULL;
    region->count = 0;
    region->capacity = capacity;

    return region;
}

void free_region(Region *region) {
    free(region);
}
```
