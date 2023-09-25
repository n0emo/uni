#include <stdlib.h>
#include <stdio.h>

#include "hanoisolve.h"
#include "hanoicalcs.h"

void show_info_task();

void solve_hanoi_task();

int main() {
    system("chcp 65001");
    system("cls");
    int task_num;
    printf_s("Введите номер желаемого действия:\n");
    printf_s("1 - вывести информацию:\n");
    printf_s("2 - решить ханойскую башню без ходов A=>C и C=>A:\n");
    scanf_s("%d", &task_num);
    switch (task_num) {
        case 1:
            show_info_task();
            break;
        case 2:
            solve_hanoi_task();
            break;
        default:
            printf_s("Неверный номер действия.\n");
    }

    system("pause");
    return 0;
}

void show_info_task() {
    int disc_count = 64;
    unsigned long long turn_count = calc_turn_count(disc_count);
    printf_s("Для %d дисков потребуется сделать %llu ходов.\n", disc_count, turn_count);
    unsigned long long seconds = calc_time(disc_count);
    unsigned long long years = seconds / 60 / 60 / 24 / 365;
    printf("Это займёт %llu секунд или %llu лет.\n", seconds, years );
}

void solve_hanoi_task() {
    int disc_count;
    printf_s("Введите количество дисков.\n");
    scanf_s("%d", &disc_count);
    if(disc_count <=0) {
        printf_s("Количество дисков должно быть положительным.");
        return;
    }

    int dest;
    printf_s("Введите номер стержня, на который надо переместить диски (1 - B или 2 - C)\n");
    scanf_s("%d", &dest);
    if(dest < 1 || dest > 2) {
        printf_s("Неверный номер.");
        return;
    }

    solve_hanoi(disc_count, dest);
}
