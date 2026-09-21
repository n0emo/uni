#include "list.h"

#include <stdlib.h>

list* list_create(void)
{
    list* list = malloc(sizeof(struct list));
    list->count = 0;
    list->head = NULL;
    list->tail = NULL;
    return list;
}

void* list_get_head(const list* list)
{
    return list->head == NULL ? NULL : list->head->data;
}

void* list_get_tail(const list* list)
{
    return list->tail == NULL ? NULL : list->tail->data;
}

void* list_get(const list* list, const size_t index)
{
    if(index >= list->count || index < 0) return NULL;

    const node* tmp = list->head;
    for(size_t i = 0; i < index; i++)
    {
        tmp = tmp->next;
        if(tmp == NULL) return NULL;
    }

    return tmp->data;
}

void* list_get_from_end(const list* list, const size_t index)
{
    return list_get(list, list->count - index);
}

void** list_to_array(const list* list)
{
    if(list->count == 0) return NULL;
    void** array = malloc(sizeof(void*) * list->count);

    const node* tmp = list->head;
    for(size_t i = 0; i < list->count; i++)
    {
        array[i] = tmp->data;
        tmp = tmp->next;
    }

    return array;
}

int list_push_back(list* list, void* data)
{
    node* node_ptr = malloc(sizeof(node));
    
    node_ptr->data = data;
    if(list->count == 0)
        list->head = node_ptr;
    else
        list->tail->next = node_ptr;
    list->tail = node_ptr;

    list->count++;
    
    return 1;
}

int list_push_front(list* list, void* data)
{
    if(list->count == 0)
    {
        return list_push_back(list, data);
    }
    node* new_node = malloc(sizeof(node));
    new_node->data = data;
    new_node->next = list->head;
    list->head = new_node;
    if(list->count == 1)
    {
        list->tail = list->head->next;
    }
    list->count++;
    return 1;
}

int list_insert(list* list, void* data, const size_t index)
{
    if(index > list->count || index < 0) return 0;
    if(index == list->count) return list_push_back(list, data);
    if(index == 0) return list_push_front(list, data);

    node* tmp = list->head;
    node* new_node = malloc(sizeof(node));
    new_node->data = data;
    
    for(size_t i = 0; i < index - 1; i++)
    {
        tmp = tmp->next;
    }
    
    new_node->next = tmp->next;
    tmp->next = new_node;
    list->count++;
    
    return 1;
}

void* list_pop_back(list* list)
{
    if(list->count == 0) return NULL;
    
    void* return_data = list->tail->data;

    if(list->count == 1)
    {
        free(list->tail);
        list->tail = NULL;
        list->head = NULL;
        list->count--;
        return return_data;
    }

    node* tmp = list->head;
    for(size_t i = 0; i < list->count - 2; i++)
    {
        tmp = tmp->next;
    }

    free(list->tail);
    list->tail = tmp;
    list->count--;
    
    return return_data;
}

void* list_pop_front(list* list)
{
    if(list->count == 0) return NULL;
    if(list->count == 1) return list_pop_back(list);

    void* data = list->head->data;
    node* tmp = list->head;
    list->head = list->head->next;
    free(tmp);
    list->count--;
    return data;
}

int list_remove_at(list* list, const size_t index)
{
    if(list->count == 0 || index < 0) return 0;
    if(index == 0)
    {
        list_pop_front(list);
        return 1;
    }
    if(index == list->count - 1)
    {
        list_pop_back(list);
        return 1;
    }

    if(list->count == 1)
    {
        free(list->head);
        list->head = NULL;
        list->tail = NULL;
        return 1;
    }

    node* tmp = list->head;
    for(size_t i = 0; i < index - 1; i++)
    {
        tmp = tmp->next;
    }

    node* removed = tmp->next;
    tmp->next = removed->next;
    free(removed);
    list->count--;
    
    return 1;
}

int list_remove_at_from_end(list* list, size_t index)
{
    return list_remove_at(list, list->count - index);
}

void list_apply(const list* list, void(* func)(void*))
{
    const node* tmp = list->head;
    for(size_t i = 0; i < list->count; i++)
    {
        func(tmp->data);
        tmp = tmp->next;
    }
}

list* list_apply_and_save(const list* list, void*(* func)(void*))
{
    struct list* new_list = list_create();
    
    if(list->count == 0) return new_list;

    const node* tmp = list->head;
    node* tmp_new = malloc(sizeof(node));

    new_list->head = tmp_new;
    new_list->head->data = func(list->head->data);
    
    
    for(size_t i = 0; i < list->count - 1; i++)
    {
        tmp_new->next = malloc(sizeof(node));
        tmp_new = tmp_new->next;
        tmp = tmp->next;
        tmp_new->data = func(tmp->data);
    }

    new_list->tail = tmp_new;

    new_list->count = list->count;
    
    return new_list;
}

int list_delete(list* list)
{
    if(list->count == 0)
    {
        free(list);
        return 1;
    }
    if(list->count == 1)
    {
        free(list->head);
        free(list);
        return 1;
    }
    
    node* tmp = list->head;
    for(size_t i = 0; i < list->count; i++)
    {
        node* tmp_next = tmp->next;
        free(tmp);
        tmp = tmp_next;
    }
    free(list);
    return 1;
}
