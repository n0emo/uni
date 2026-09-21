#include "strfuncs.h"
#include "malloc.h"

// Indexing functions
size_t strlen_indexing(const char *str) {
    size_t len = 0;
    while (str[len] != '\0') {
        len++;
    }
    return len;
}

char* strcpy_indexing(char *destination, const char *source) {
    size_t source_len = strlen_indexing(source) + 1;
    for(int i = 0; i < source_len; i++) {
        destination[i] = source[i];
    }
    return destination;
}

char* strcat_indexing(char *destination, const char *source) {
    size_t dest_len = strlen_indexing(destination);
    size_t source_len = strlen_indexing(source) + 1;
    for(int i = 0; i < source_len; i++) {
        destination[i + dest_len] = source[i];
    }
    return destination;
}

int strcmp_indexing(const char *str1, const char *str2) {
    int cmp_result;
    int index = 0;
    char str1_tmp_char, str2_tmp_char;
    do {
        str1_tmp_char = str1[index];
        str2_tmp_char = str2[index];
        cmp_result = str1_tmp_char - str2_tmp_char;
        if(cmp_result != 0) break;
        index++;
    } while (str1_tmp_char != '\0' || str2_tmp_char != '\0');

    if(cmp_result < 0) return -1;
    else if(cmp_result > 0) return 1;
    return 0;
}

// Pointer functions
size_t strlen_pointers(const char *str) {
    const char* str_ptr = str;
    while (*str_ptr != '\0') {
        str_ptr++;
    }
    return str_ptr - str;
}

char *strcpy_pointers(char *destination, const char *source) {
    char* dest_ptr = destination;
    do {
        *(dest_ptr++) = *(source++);
    } while (*source != '\0');
    return destination;
}

char *strcat_pointers(char *destination, const char *source) {
    strcpy_pointers(destination + strlen_pointers(destination), source);
    return destination;
}

int strcmp_pointers(const char *str1, const char *str2) {
    int cmp_result;
    while (*str1 != '\0' || *str2 != '\0') {
        cmp_result = *(str1++) - *(str2++);
        if(cmp_result != 0) break;
    }

    if(cmp_result < 0) return -1;
    else if(cmp_result > 0) return 1;
    return 0;
}
