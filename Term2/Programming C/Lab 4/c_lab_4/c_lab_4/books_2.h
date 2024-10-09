#pragma once

#define SURNAME_CHARS 20
#define THEME_CHARS 50
#define YEARS_CHARS 5
#define PAGES_CHARS 5

// lines are allocated with malloc, so don't forget to free.
char** get_lines(char* path, int* count); 

char*** chop_lines(char** lines, int count);

char*** filter_chopped_lines(
    char*** chopped_lines,
    int (*filter)(char**),
    int count,
    int* filtered_count
    );

void write_chopped_lines(char* path, char*** chopped_lines, int count);

void free_lines(char** lines, int count);

void free_chopped_lines(char*** lines, int count);
