#pragma once

#define SURNAME_CHAR_NUMBER 20
#define THEME_CHAR_NUMBER 50

#define SURNAME_FORMAT "%20s"
#define THEME_FORMAT "%50s"
#define YEAR_FORMAT "%5hu"
#define PAGE_FORMAT "%5hu"

struct book;
typedef struct book {
    char surname[SURNAME_CHAR_NUMBER];
    char theme[THEME_CHAR_NUMBER];
    unsigned short year;
    unsigned short page_count;
} book;

book** get_books_from_file(const char* path, int* count);

int book_compare_year(const book* a, const book* b);

int book_compare_pages(const book* a, const book* b);

int book_compare_surname(const book* a, const book* b);
