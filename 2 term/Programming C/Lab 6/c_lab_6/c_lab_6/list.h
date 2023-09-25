#pragma once

typedef unsigned long long size_t; 

typedef struct node
{
    void* data;
    struct node* next;
} node;

typedef struct list
{
    node* head;
    node* tail;
    size_t count;
} list;

// Creates a new list.
list* list_create(void);

// Returns a data of the lists head.
void* list_get_head(const list* list);

// Returns a data of the lists tail.
void* list_get_tail(const list* list);

// Returns a data from the list at index.
void* list_get(const list* list, size_t index);

// Returns a data from the list at index starting from end of list.
void* list_get_from_end(const list* list, size_t index);

// Converts a list to an array and returns a pointer to the array.
// Warning: a memory for an array is allocated with malloc.
// Don't forget to free the array after use.
void** list_to_array(const list* list);

// Adds a new element at the end of the list.
int list_push_back(list* list, void* data);

// Adds a new element at rhe start of the list
int list_push_front(list* list, void* data);

// Inserts a new element at a desired index.
int list_insert(list* list, void* data, size_t index);

// Removes an element from the end of the list and returns ins data
void* list_pop_back(list* list);

// Removes an element from the start of the list and returns ins data
void* list_pop_front(list* list);

// Removes an element from the list at index.
int list_remove_at(list* list, size_t index);

// Removes an element from the list at indext starting from the end.
int list_remove_at_from_end(list* list, size_t index);

// Applies a void function to every element of the list.
void list_apply(const list* list, void(*func)(void*));

// Applies a void function to every element of the list and
// saves the result to a new list.
// Warning: the new list will be allocated with malloc.
list* list_apply_and_save(const list* list, void*(*func)(void*));

// Deletes all the nodes of the list.
// Warning: data inside the nodes will not be deleted.
int list_delete(list* list);
