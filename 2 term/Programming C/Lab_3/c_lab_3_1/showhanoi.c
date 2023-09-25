#include <stdio.h>
#include "showhanoi.h"
#include "malloc.h"
#define DISC_SYMBOL '_'
#define BASE_SYMBOL '='

char* get_disc_str(uint size, uint max) {
    uint len = max * 2 + 1;
    char* str = (char*)malloc(len + 1);
    for(int i = 0; i < len; i++) {
        str[i] = i < max - size + 1 || i > max + size - 1 ? ' ' : DISC_SYMBOL;
    }
    str[len] = '\0';
    return str;
}

char* get_base_str(uint max, char alias) {
    uint len = max * 2 + 3;
    char* str = (char*)malloc(len + 1);
    for(int i = 0; i < len; i++) {
        str[i] = BASE_SYMBOL;
    }
    str[max + 1] = alias;
    str[len] = '\0';
    return str;
}

void print_line(Rod *rods, uint line) {
    uint max = rods->size;
    for(int i = 0; i < 3; i++) {
        char* str = get_disc_str(rods[i].array[max - line - 1], max);
        printf_s("  %s  ", str);
        free(str);
    }
    printf_s("\n");
}

void print_bases(uint max, char* aliases) {
    for(int i = 0; i < 3; i++) {
        char* str = get_base_str(max, aliases[i]);
        printf_s(" %s ", str);
        free(str);
    }
    printf_s("\n\n");
}

void show_rods(Rod *rods, char* aliases) {
    uint disc_count = rods->size;
    for(int i = 0; i < disc_count; i++) {
        print_line(rods, i);
    }
    print_bases(disc_count, aliases);
}

void show_move(char from, char to, uint disc_max) {
    uint spaces = disc_max * 3 + 4;
    for(int i = 0; i < spaces; i++) {
        printf_s(" ");
    }
    printf_s("%c --> %c\n\n\n", from, to);
}
