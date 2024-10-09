#define _CRT_SECURE_NO_WARNINGS

#include "booksfile.h"

#include <stdio.h>
#include <stdlib.h>

#include "book.h"


list* get_book_list_from_file(const char* path)
{
    FILE* file = fopen(path, "r");
    if(!file) return NULL;

    list* book_list = list_create();
    char buf[300];

    while(fgets(buf, 300, file))
    {
        book* new_book = malloc(sizeof(book));
        int idx = 0;
        for(int i = 0; i < SURNAME_CHAR_NUMBER; i++, idx++)
        {
            new_book->surname[i] = buf[idx];
        }
        new_book->surname[SURNAME_CHAR_NUMBER] = '\0';
        idx++;
        
        for(int i = 0; i < THEME_CHAR_NUMBER; i++, idx++)
        {
            new_book->theme[i] = buf[idx];
        }
        new_book->theme[THEME_CHAR_NUMBER] = '\0';
        idx++;
        
        char num_str[5];
        
        for(int i = 0; i < 5; i++, idx++)
        {
            num_str[i] = buf[idx];
        }
        idx++;
        new_book->year = atoi(num_str);
        
        for(int i = 0; i < 5; i++, idx++)
        {
            num_str[i] = buf[idx];
        }
        new_book->page_count = atoi(num_str);

        list_push_back(book_list, new_book);
    }

    fclose(file);
    
    return book_list;
}

int write_book_list_to_file(char* path, list* list)
{
    FILE* file = fopen(path, "w");
    if(!file) return 0;

    book** book_arr = list_to_array(list);
    for(int i = 0; i < list->count; i++)
    {
        fprintf(file, BOOK_FORMAT"\n",
            book_arr[i]->surname,
            book_arr[i]->theme,
            book_arr[i]->year,
            book_arr[i]->page_count
            );
    }

    fclose(file);
    free(book_arr);
    
    return 1;
}
