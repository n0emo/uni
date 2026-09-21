#include <stdio.h>
#include <stdlib.h>

#include "book.h"
#include "sort.h"
#include "testing.h"

int main(int argc, char* argv[])
{
    int count;
    book** books = get_books_from_file("books.txt", &count);
    printf("Before sort:\n\n");
    print_books(books, count);

    system("pause");  // NOLINT(concurrency-mt-unsafe)
    test_info_sort(books, count, bubble_iter_info, book_compare_pages, "\n\nBubble sort.\n\n");
    system("pause");  // NOLINT(concurrency-mt-unsafe)
    test_info_sort(books, count, insertion_iter_info, book_compare_surname, "\n\nInsertion sort.\n\n");
    system("pause");  // NOLINT(concurrency-mt-unsafe)
    test_info_sort_rec(books, count, bubble_rec_info, book_compare_year, "\n\nBubble sort recursive.\n\n");
    system("pause");  // NOLINT(concurrency-mt-unsafe)
    test_info_sort_rec(books, count, insertion_rec_info, book_compare_year, "\n\nInsertion sort recursive.\n\n");
    system("pause");  // NOLINT(concurrency-mt-unsafe)
    test_info_sort_rec(books, count, quicksort_info, book_compare_year, "\n\nQuick sort.\n\n");
    
    for(int i = 0; i < count; i++)
    {
        free(books[i]);
    }
    free(books);
    printf("\n");
    system("pause");  // NOLINT(concurrency-mt-unsafe)
    return 0;
}
