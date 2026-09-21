#define _CRT_SECURE_NO_WARNINGS

#include "book.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void replace_char(char str[], char from, char to, int size)
{
    for(int i = 0; i < size; i++)
    {
        if(str[i] == from) str[i] = to;
    }
}

book** get_books_from_file(const char* path, int* count)
{
    FILE* file;
    file = fopen(path, "r");
    fscanf(file, "%i\n", count);
    book** books = malloc(sizeof(book*) * *count);
    for(int i = 0; i < *count; i++)
    {
        books[i] = (book*)malloc(sizeof(book));
        char* surname[SURNAME_CHAR_NUMBER];
        char* theme[THEME_CHAR_NUMBER];
        unsigned short year;
        unsigned short page_count;
        fscanf(file,  SURNAME_FORMAT " " THEME_FORMAT " " YEAR_FORMAT " " PAGE_FORMAT "\n",
             surname,
             theme,
             &year,
             &page_count
             );
        strcpy(books[i]->surname, surname);
        strcpy(books[i]->theme, theme);
        replace_char(books[i]->theme, '_', ' ', THEME_CHAR_NUMBER);
        books[i]->year = year;
        books[i]->page_count = page_count;
    }
    fclose(file);
    return books;
}

int book_compare_year(const book* a, const book* b)
{
    if(a->year < b->year) return -1;
    if(a->year > b->year) return 1;
    return 0;
}

int book_compare_pages(const book* a, const book* b)
{
    if(a->page_count < b->page_count) return -1;
    if(a->page_count > b->page_count) return 1;
    return 0;
}

int book_compare_surname(const book* a, const book* b)
{
    return strcmp(a->surname, b->surname);
}
