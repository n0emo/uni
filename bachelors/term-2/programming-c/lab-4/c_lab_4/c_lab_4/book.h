#pragma once

#define SURNAME_CHAR_NUMBER 20
#define THEME_CHAR_NUMBER 50

#define SURNAME_FORMAT "%20s"
#define THEME_FORMAT "%50s"
#define YEAR_FORMAT "%5hu"
#define PAGE_FORMAT "%5hu"

typedef struct book
{
    char surname[SURNAME_CHAR_NUMBER];
    char theme[THEME_CHAR_NUMBER];
    unsigned short year;
    unsigned short page_count;
} book;
