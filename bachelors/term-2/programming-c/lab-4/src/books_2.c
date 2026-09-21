// ReSharper disable CppDeprecatedEntity
// ReSharper disable CppClangTidyClangDiagnosticDeprecatedDeclarations
#define _CRT_SECURE_NO_WARNINGS

#include "books_2.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

const int len = SURNAME_CHARS + THEME_CHARS + YEARS_CHARS + PAGES_CHARS + 3;

char** get_lines(char* path, int* count)
{
    FILE* file = fopen(path, "r");

    char len_str[10];
    fgets(len_str, 10, file);
    *count = atoi(len_str);
    char** lines = malloc(sizeof(char*) * *count);
    for(int i = 0; i < *count; i++)
    {
        char* tmp = malloc(sizeof(char) *( len + 2));
        fgets(tmp, len + 2, file);
        tmp[len] = '\0';
        lines[i] = (char*)malloc(sizeof(char) * len + 1);
        strcpy(lines[i], tmp);
        free(tmp);
    }
    return lines;
}

char*** chop_lines(char** lines, int count)
{
    char*** chopped_lines = malloc(sizeof(char**) * count);
    for(int i = 0; i < count; i++)
    {
        chopped_lines[i] = malloc(sizeof(char*) * 4);

        chopped_lines[i][0] = malloc(sizeof(char) * SURNAME_CHARS + 1);
        chopped_lines[i][1] = malloc(sizeof(char) * THEME_CHARS + 1);
        chopped_lines[i][2] = malloc(sizeof(char) * YEARS_CHARS + 1);
        chopped_lines[i][3] = malloc(sizeof(char) * PAGES_CHARS + 1);

        int str_index = 0;
        for(int j = 0; j < SURNAME_CHARS; j++)
        {
            chopped_lines[i][0][j] = lines[i][str_index++];
        }
        str_index++;
        for(int j = 0; j < THEME_CHARS; j++)
        {
            chopped_lines[i][1][j] = lines[i][str_index++];
        }
        str_index++;
        for(int j = 0; j < YEARS_CHARS; j++)
        {
            chopped_lines[i][2][j] = lines[i][str_index++];
        }
        str_index++;
        for(int j = 0; j < PAGES_CHARS; j++)
        {
            chopped_lines[i][3][j] = lines[i][str_index++];
        }

        chopped_lines[i][0][SURNAME_CHARS] = '\0';
        chopped_lines[i][1][THEME_CHARS] = '\0';
        chopped_lines[i][2][YEARS_CHARS] = '\0';
        chopped_lines[i][3][PAGES_CHARS] = '\0';
    }
    return chopped_lines;
}

char*** filter_chopped_lines(char*** chopped_lines, int(*filter)(char**), int count, int* filtered_count)
{
    *filtered_count = 0;
    short* suitable_lines = (short*)malloc(sizeof(short) * count);
    for(int i = 0; i < count; i++)
    {
        suitable_lines[i] = filter(chopped_lines[i]);
        if(suitable_lines[i]) (*filtered_count)++;
    }

    char*** filtered_lines = malloc(sizeof(char**) * (*filtered_count));
    for(int i = 0, j = 0; i < count; i++)
    {
        if(suitable_lines[i])
        {
            filtered_lines[j] = malloc(sizeof(char*) * 4);

            filtered_lines[j][0] = malloc(sizeof(char) * SURNAME_CHARS + 1);
            filtered_lines[j][1] = malloc(sizeof(char) * THEME_CHARS + 1);
            filtered_lines[j][2] = malloc(sizeof(char) * YEARS_CHARS + 1);
            filtered_lines[j][3] = malloc(sizeof(char) * PAGES_CHARS + 1);
            strcpy(filtered_lines[j][0], chopped_lines[i][0]);
            strcpy(filtered_lines[j][1], chopped_lines[i][1]);
            strcpy(filtered_lines[j][2], chopped_lines[i][2]);
            strcpy(filtered_lines[j][3], chopped_lines[i][3]);
            
            j++;
        }
    }
    free(suitable_lines);
    return filtered_lines;
}

void write_chopped_lines(char* path, char*** chopped_lines, int count)
{
    FILE* file = fopen(path, "w");
    char count_str[10];
    _itoa(count, count_str, 20);
    fputs(count_str, file);
    fputc('\n', file);

    for(int i = 0; i < count; i++)
    {
        fputs(chopped_lines[i][0], file);
        fputc(' ', file);
        fputs(chopped_lines[i][1], file);
        fputc(' ', file);
        fputs(chopped_lines[i][2], file);
        fputc(' ', file);
        fputs(chopped_lines[i][3], file);
        fputc(' ', file);
        fputc('\n', file);
    }
}

void free_lines(char** lines, int count)
{
    for(int i = 0; i < count; i++)
    {
        free(lines[i]);
    }
    free(lines);
}

void free_chopped_lines(char*** lines, int count)
{
    for(int i = 0; i < count; i++)
    {
        for(int j = 0; j < 4; j++)
        {
            free(lines[i][j]);
        }
        free(lines[i]);
    }
    free(lines);
}
