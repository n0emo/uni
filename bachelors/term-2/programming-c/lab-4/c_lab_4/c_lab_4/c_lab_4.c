#define _CRT_SECURE_NO_WARNINGS

#include <stdio.h>
#include <stdlib.h>
#include "books_1.h"
#include "books_2.h"

int filter_struct(book* book)
{
    return book->year >= 2000;
}

int filter_line(char** line)
{
    return atoi(line[2]) >= 2018;
}

void test_books_1(void);

void test_books_2(void);

int main(int argc, char* argv[])
{
    test_books_1();
    test_books_2();
    
    system("pause");  // NOLINT(concurrency-mt-unsafe)
    return 0;
}

void test_books_1(void)
{
    printf("\n\nbooks_1\n\n");
    int count;
    book* books = get_books_from_file("books.txt", &count);
    for(int i = 0; i < count; i++)
    {
        printf("%s - %s %d year (%d pages)\n", books[i].surname, books[i].theme, books[i].year, books[i].page_count);
    }

    printf("\n\nfiltered:\n\n");

    int filtered_count = 0;
    book* filtered = filter_books(books, filter_struct, count, &filtered_count);
    write_books_to_file(filtered, filtered_count, "filtered_1.txt");
    for(int i = 0; i < filtered_count; i++)
    {
        printf("%s - %s %d year (%d pages)\n", filtered[i].surname, filtered[i].theme, filtered[i].year, filtered[i].page_count);
    }

    free(books);
    free(filtered);
}

void test_books_2(void)
{
    printf("\n\nbooks_2\n\n");
    int count;
    char** lines = get_lines("books.txt", &count);

    printf("Lines readden from file\n\n");
    for(int i = 0; i < count; i++)
    {
        printf("%s\n", lines[i]);
    }
    
    char*** chopped_lines = chop_lines(lines, count);

    printf("\n\nChopped lines:\n\n");
    for(int i = 0; i < count; i++)
    {
        printf("%s|%s|%s|%s\n",
            chopped_lines[i][0],
            chopped_lines[i][1],
            chopped_lines[i][2],
            chopped_lines[i][3]
            );
    }

    int filtered_count;
    char*** filtered_lines = filter_chopped_lines(
        chopped_lines,
        filter_line,
        count,
        &filtered_count
        );
    printf("\n\nFiltered lines:\n\n");
    for(int i = 0; i < filtered_count; i++)
    {
        printf("%s|%s|%s|%s\n",
            filtered_lines[i][0],
            filtered_lines[i][1],
            filtered_lines[i][2],
            filtered_lines[i][3]
            );
    }

    write_chopped_lines("filtered_2.txt", filtered_lines, filtered_count);

    printf("\n\nData successfully written to file.\n\n");
    
    free_lines(lines, count);
    free_chopped_lines(chopped_lines, count);
    free_chopped_lines(filtered_lines, filtered_count);
}
