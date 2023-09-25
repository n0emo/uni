#define _CRT_SECURE_NO_WARNINGS

#include <stdio.h>
#include <stdlib.h>

#include "book.h"
#include "list.h"
#include "booksfile.h"

#define ACTION_COUNT 14

list* book_list;

void(*actions[ACTION_COUNT])(void);

char* action_names[ACTION_COUNT];

void action_get_head(void);
void action_list_get_tail(void);
void action_list_get(void);
void action_get_from_end(void);
void action_show_list(void);
void action_push_back(void);
void action_push_front(void);
void action_insert(void);
void action_pop_back(void);
void action_pop_front(void);
void action_remove_at(void);
void action_remove_from_end(void);
void action_load_from_file(void);
void action_write_to_file(void);


// void** list_to_array(const list* list);


void init_actions(void);
void print_actions(void);

int main(int argc, char* argv[])
{
    system("cls");
    init_actions();
    book_list = list_create();

    printf("Welcome to the book management tool!\n");

    while (1)
    {
        system("pause");
        system("cls");
        
        print_actions();
        
        int action_num;
        printf("Enter action number: ");
        scanf("%d", &action_num);
        if(action_num == 0) break;
        if(action_num < 1 || action_num > ACTION_COUNT)
        {
            printf("Invalid action number.\n");
            continue;
        }
        system("cls");
        fseek(stdin,0,SEEK_END);
        actions[action_num - 1]();
    }
    
    list_apply(book_list, free);
    list_delete(book_list);
    
    system("pause");
    
    return 0;
}

void action_get_head(void)
{
    printf("Head of the list:\n\n");
    book_print(list_get_head(book_list));
}

void action_list_get_tail(void)
{
    printf("Tail of the list:\n\n");
    book_print(list_get_tail(book_list));
}

void action_list_get(void)
{
    size_t index;
    printf("Enter desired index: ");
    scanf("%lld", &index);

    book* book = list_get(book_list, index);

    if(book == NULL)
    {
        printf("Invalid index.\n");
        return;
    }

    printf("Book at index %lld in the list:\n\n", index);
    book_print(book);
}

void action_get_from_end(void)
{
    size_t index;
    printf("Enter desired index: ");
    scanf("%lld", &index);

    book* book = list_get_from_end(book_list, index);

    if(book == NULL)
    {
        printf("Invalid index.\n");
        return;
    }

    printf("Book at index %lld in the list:\n\n", index);
    book_print(book);
}

void action_show_list(void)
{
    if(book_list->count == 0)
    {
        printf("The list is empty.\n");
        return;
    }
    printf("List of the books:\n\n");
    list_apply(book_list, book_print);
    printf("\n\n");
}

void action_push_back(void)
{
    printf("    Enter book:\n");
    book* new_book = book_get_scanf();
    list_push_back(book_list, new_book);
    printf("\nBook added to list successfully.\n\n");
}

void action_push_front(void)
{
    printf("    Enter book:\n");
    book* new_book = book_get_scanf();
    list_push_front(book_list, new_book);
    printf("\nBook added to list successfully.\n\n");
}

void action_insert(void)
{
    size_t index;
    printf("Enter index (0 - %lld): ", book_list->count);
    scanf("%lld", &index);
    if(index < 0 || index >= book_list->count)
    {
        printf("Invalid index.\n");
        
    }
    printf("    Enter book:\n");
    book* new_book = book_get_scanf();
    list_insert(book_list, new_book, index);
    printf("\nBook added to list successfully.\n\n");
}

void action_pop_back(void)
{
    book* removed_book = list_pop_back(book_list);
    if(removed_book == NULL)
    {
        printf("The list is empty.\n");
        return;
    }
    printf("The book, popped out from back:\n\n");
    book_print(removed_book);
    free(removed_book);
}

void action_pop_front(void)
{
    book* removed_book = list_pop_front(book_list);
    if(removed_book == NULL)
    {
        printf("The list is empty.\n");
        return;
    }
    printf("The book, popped out from front:\n\n");
    book_print(removed_book);
    free(removed_book);
}

void action_remove_at(void)
{
    size_t index;
    printf("Enter index (0 - %lld): ", book_list->count);
    scanf("%lld", &index);
    if(index < 0 || index >= book_list->count)
    {
        printf("Invalid index.\n");
        
    }
    
    book* removed_book = list_get(book_list, index);
    list_remove_at(book_list, index);
    printf("\nThe book, removed from the list:\n\n");
    book_print(removed_book);
    free(removed_book);
}

void action_remove_from_end(void)
{
    size_t index;
    printf("Enter index (0 - %lld): ", book_list->count);
    scanf("%lld", &index);
    if(index < 0 || index >= book_list->count)
    {
        printf("Invalid index.\n");
        
    }
    
    book* removed_book = list_get(book_list, index);
    list_remove_at_from_end(book_list, index);
    printf("\nThe book, removed from the list:\n\n");
    book_print(removed_book);
    free(removed_book);
}

void action_load_from_file(void)
{
    char filename[100];
    printf("Enter file name: ");
    scanf("%s", filename);

    list* tmp_list = get_book_list_from_file(filename);
    if(tmp_list == NULL)
    {
        printf("Invalid file name.\n");
        return;
    }

    list_apply(book_list, free);
    free(book_list);
    book_list = tmp_list;

    printf("Books loaded successfully\n");
}

void action_write_to_file(void)
{
    char filename[100];
    printf("Enter file name: ");
    scanf("%s", filename);

    if(write_book_list_to_file(filename, book_list))
    {
        printf("Data successfully written to the file.\n");
    }
    else
    {
        printf("Error during writing the list to file.\n");
    }
}

void init_actions(void)
{
    actions[0] = action_get_head;
    action_names[0] = "Get head of the list.";
    
    actions[1] =  action_list_get_tail;
    action_names[1] = "Get tail of the list.";
    
    actions[2] =  action_list_get;
    action_names[2] = "Get an element of the list at desired index.";
    
    actions[3] =  action_get_from_end;
    action_names[3] = "Get an element of the list at desired index starting from the end.";
    
    actions[4] =  action_show_list;
    action_names[4] = "Print all elements of the list.";
    
    actions[5] =  action_push_back;
    action_names[5] = "Push back anew element to the list.";
    
    actions[6] =  action_push_front;
    action_names[6] = "Push front anew element to the list.";
    
    actions[7] =  action_insert;
    action_names[7] = "Insert a new elenebt in the list at the desired index.";
    
    actions[8] =  action_pop_back;
    action_names[8] = "Pop back an element from the list and show it.";
    
    actions[9] =  action_pop_front;
    action_names[9] = "Pop front an element from the list and show it.";
    
    actions[10] =  action_remove_at;
    action_names[10] = "Remove an element from the list at the desired index.";
    
    actions[11] =  action_remove_from_end;
    action_names[11] = "Remove an element from the list at the desired index starting from the end.";

    actions[12] =  action_load_from_file;
    action_names[12] = "Load books from the file.";

    actions[13] =  action_write_to_file;
    action_names[13] = "Write books to the file.";
    
}

void print_actions(void)
{
    for(int i = 0; i < ACTION_COUNT; i++)
    {
        printf("%d - %s\n", i + 1, action_names[i]);
    }
    printf("\n%d - Exit.\n\n", 0);
}
