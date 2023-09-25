#define _CRT_SECURE_NO_WARNINGS

#include "book.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void write_str_without_trailing_spaces(char* str_ptr)
{
    while (*str_ptr == ' ') str_ptr++;
    while (*str_ptr != '\0')
    {
        char tmp = *str_ptr == '_' ? ' ' : (char)(*str_ptr);
        putc(tmp, stdout);
        str_ptr++;
    }
}

void book_print(book* book)
{
    write_str_without_trailing_spaces(book->surname);
    printf(" - ");
    write_str_without_trailing_spaces(book->theme);
    printf("\nyear: %d. %d pages.\n\n", book->year, book->page_count);
}

book* book_get_scanf(void)
{
    fseek(stdin,0,SEEK_END);
    
    book* book = malloc(sizeof(struct book));
    
    printf("\nEnter surname:\n");
    fgets(book->surname, SURNAME_CHAR_NUMBER, stdin);
    book->surname[strcspn(book->surname, "\r\n")] = '\0';
    
    printf("Enter theme:\n");
    fgets(book->theme, THEME_CHAR_NUMBER, stdin);
    book->theme[strcspn(book->theme, "\r\n")] = '\0';
    
    printf("Enter year: ");
    scanf("%hd", &book->year);
    printf("Enter page count: ");
    scanf("%hd", &book->page_count);
    return book;
}
