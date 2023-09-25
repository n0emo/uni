#pragma once
#include "book.h"

book* get_books_from_file(const char* path, int* count);

book* filter_books(book* books, int (*filter)(book*), int count, int* out_count);

void write_books_to_file(book* books, int count, char* path);
