#pragma once

#include "list.h"

list* get_book_list_from_file(const char* path);

int write_book_list_to_file(char* path, list* list);
