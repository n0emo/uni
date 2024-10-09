#define _CRT_SECURE_NO_WARNINGS

#include "books_1.h"

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

book* get_books_from_file(const char* path, int* count)
{
     FILE* file;
     file = fopen(path, "r");
     fscanf(file, "%i\n", count);
     book* books = malloc(sizeof(book) * *count);
     for(int i = 0; i < *count; i++)
     {
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
          strcpy(books[i].surname, surname);
          strcpy(books[i].theme, theme);
          replace_char(books[i].theme, '_', ' ', THEME_CHAR_NUMBER);
          books[i].year = year;
          books[i].page_count = page_count;
     }
     fclose(file);
     return books;
}

book* filter_books(book* books, int(* filter)(book*), int count, int* out_count)
{
     *out_count = 0;
     short* suitable_books = malloc(sizeof(short) * count);
     for(int i = 0; i < count; i++)
     {
          suitable_books[i] = filter(&books[i]);
          if(suitable_books[i]) (*out_count)++;
     }

     book* filtered_books = malloc(sizeof(book) * (*out_count));
     for(int i = 0, j = 0; i < count; i++)
     {
          if(suitable_books[i])
          {
               filtered_books[j] = books[i];
               j++;
          }
     }
     free(suitable_books);
     return filtered_books;
}

void write_books_to_file(book* books, int count, char* path)
{
     FILE* file;
     file = fopen(path, "w");
     fprintf(file, "%d\n", count);
     for(int i = 0; i < count; i++)
     {
          char theme[THEME_CHAR_NUMBER];
          strcpy(theme, books[i].theme);
          replace_char(theme, ' ', '_', THEME_CHAR_NUMBER);
          fprintf(file, SURNAME_FORMAT " " THEME_FORMAT " " YEAR_FORMAT " " PAGE_FORMAT "\n", books[i].surname, theme, books[i].year, books[i].page_count);
     }
     fclose(file);
}
