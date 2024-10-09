#include "string.h"
#include "strfuncs.h"
#include <stdio.h>
#include "tests.h"

void test_strlen(char* str) {
    printf_s("Testing strlen function.\n");

    size_t strlen_std_res = strlen(str);
    size_t strlen_indexing_res = strlen_indexing(str);
    size_t strlen_pointers_res = strlen_pointers(str);

    printf_s("Results for string \"%s\":\n", str);
    printf_s("strlen_std: %d\n", strlen_std_res);
    printf_s("strlen_indexing: %d\n", strlen_indexing_res);
    printf_s("strlen_pointers: %d\n", strlen_pointers_res);
    printf_s("\n");
}

void test_strcpy(char* str) {
    printf_s("Testing strcpy function.\n");
    printf_s("Results for string \"%s\":\n", str);
    size_t len = strlen(str) + 1;
    char *strcpy_std_res[len];
    char *strcpy_indexing_res[len];
    char *strcpy_pointers_res[len];

    strcpy(strcpy_std_res, str);
    printf_s("strcpy_std: \"%s\"\n", strcpy_std_res);

    strcpy_indexing(strcpy_indexing_res, str);
    printf_s("strcpy_indexing: \"%s\"\n", strcpy_indexing_res);

    strcpy_pointers(strcpy_pointers_res, str);
    printf_s("strcpy_pointers: \"%s\"\n", strcpy_pointers_res);

    printf_s("\n");
}

void test_strcat(char* destination, char* source) {
    printf_s("Testing strcat function.\n");
    printf_s("Resuts for strings \"%s\" and \"%s\"\n", destination, source);
    size_t source_len = strlen(source) + 1;
    size_t dest_len = strlen(destination) + source_len + 1;

    char* strcat_std_dest[dest_len];
    strcpy(strcat_std_dest, destination);
    char* strcat_indexing_dest[dest_len];
    strcpy(strcat_indexing_dest, destination);
    char* strcat_pointers_dest[dest_len];
    strcpy(strcat_pointers_dest, destination);

    strcat(strcat_std_dest, source);
    printf_s("strcpy_std: \"%s\"\n", strcat_std_dest);

    strcat_indexing(strcat_indexing_dest, source);
    printf_s("strcat_indexing: \"%s\"\n", strcat_indexing_dest);

    strcat_pointers(strcat_pointers_dest, source);
    printf_s("strcat_pointers: \"%s\"\n", strcat_pointers_dest);

    printf_s("\n");
}

void test_strcmp(
        const char *str1,
        const char *str2,
        const char *str3,
        const char *str4,
        const char *str5,
        const char *str6) {
    printf_s("Testing strcmp function.\n");
    printf_s("Results for:\n");
    printf_s("\"%s\" and \"%s\" - first number.\n", str1, str2);
    printf_s("\"%s\" and \"%s\" - second number.\n", str3, str4);
    printf_s("\"%s\" and \"%s\" - third number.\n", str5, str6);

    int strcmp_std_res_1 = strcmp(str1, str2);
    int strcmp_std_res_2 = strcmp(str3, str4);
    int strcmp_std_res_3 = strcmp(str5, str6);
    printf_s("strcmp_std: %d %d %d\n", strcmp_std_res_1, strcmp_std_res_2, strcmp_std_res_3);

    int strcmp_indexing_res_1 = strcmp_indexing(str1, str2);
    int strcmp_indexing_res_2 = strcmp_indexing(str3, str4);
    int strcmp_indexing_res_3 = strcmp_indexing(str5, str6);
    printf_s("strcmp_indexing: %d %d %d\n", strcmp_indexing_res_1, strcmp_indexing_res_2, strcmp_indexing_res_3);

    int strcmp_pointers_res_1 = strcmp_pointers(str1, str2);
    int strcmp_pointers_res_2 = strcmp_pointers(str3, str4);
    int strcmp_pointers_res_3 = strcmp_pointers(str5, str6);
    printf_s("strcmp_pointers: %d %d %d\n", strcmp_pointers_res_1, strcmp_pointers_res_2, strcmp_pointers_res_3);
}

void test_all()  {
    test_strlen("string example");
    test_strcpy("another string");
    test_strcat( "My name is ", "Terminator");
    test_strcmp("Mathematics","Physics",
                "Equality","Equality",
                "Alfred","Albert");
}