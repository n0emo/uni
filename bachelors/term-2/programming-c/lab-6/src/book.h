#pragma once

#define SURNAME_CHAR_NUMBER 20
#define THEME_CHAR_NUMBER 50
#define FULL_CHAR_NUMBER 83

#define SURNAME_FORMAT "%20s"
#define THEME_FORMAT "%50s"
#define YEAR_FORMAT "%5hu"
#define PAGE_FORMAT "%5hu"

#define BOOK_FORMAT SURNAME_FORMAT" "THEME_FORMAT" "YEAR_FORMAT" "PAGE_FORMAT

typedef struct book
{
    char surname[SURNAME_CHAR_NUMBER + 1];
    char theme[THEME_CHAR_NUMBER + 1];
    unsigned short year;
    unsigned short page_count;
} book;

void book_print(book* book);

book* book_get_scanf(void);
