#include "da.h"
#include <stdint.h>
#include <stdio.h>

typedef struct
{
    size_t size;
    size_t value;
} Item;

typedef struct
{
    Item *items;
    size_t count;
    size_t capacity;
} Items;

size_t bp_eval_size(Items *bp)
{
    size_t sum = 0;
    for (size_t i = 0; i < bp->count; i++)
    {
        sum += bp->items[i].size;
    }
    return sum;
}

size_t bp_eval_value(Items *bp)
{
    size_t sum = 0;
    for (size_t i = 0; i < bp->count; i++)
    {
        sum += bp->items[i].value;
    }
    return sum;
}

Items eval_max_backpack(Items *items, size_t max_size)
{
    assert(items->count <= 64);

    Items max_items = {0};
    max_items.capacity = 64;
    max_items.items = malloc(sizeof(Item) * 64);

    size_t max_value = 0;

    Items temp_items = {0};
    temp_items.capacity = 64;
    temp_items.items = malloc(sizeof(Item) * 64);

    for (uint64_t itemList = 1; itemList < 1ul << items->count; itemList++)
    {
        for (size_t i = 0; i < items->count; i++)
        {
            if (itemList & 1ul << i)
                da_append(temp_items, items->items[i]);
        }

        size_t temp_size = bp_eval_size(&temp_items);
        if (temp_size <= max_size)
        {
            size_t temp_value = bp_eval_value(&temp_items);
            if (temp_value > max_value)
            {
                max_value = temp_value;
                max_items.count = 0;
                for (size_t i = 0; i < temp_items.count; i++)
                {
                    da_append(max_items, temp_items.items[i]);
                }
            }
        }
    }

    free(temp_items.items);

    return max_items;
}

int main()
{
    Items items = {0};
    da_append(items, ((Item){5, 50}));
    da_append(items, ((Item){13, 20}));
    da_append(items, ((Item){9, 19}));
    da_append(items, ((Item){2, 1}));

    Items result = eval_max_backpack(&items, 50);
    printf("%zu\n", bp_eval_value(&result));
    return 0;
}
