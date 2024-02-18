#ifndef DA_H
#define DA_H

#include <assert.h>
#include <stdlib.h>

#define INITIAL_CAP 16

#define da_append(da, item)                                                                                            \
    do                                                                                                                 \
    {                                                                                                                  \
        if ((da).count == (da).capacity)                                                                               \
        {                                                                                                              \
            size_t new_cap = (da).capacity ? (da).capacity * 2 : INITIAL_CAP;                                          \
            (da).items = realloc((da).items, sizeof((da).items[0]) * new_cap);                                         \
            assert((da).items != NULL && "Buy more RAM lol");                                                          \
            (da).capacity = new_cap;                                                                                   \
        }                                                                                                              \
        (da).items[(da).count] = item;                                                                                 \
        (da).count++;                                                                                                  \
    } while (0)

#endif // DA_H
