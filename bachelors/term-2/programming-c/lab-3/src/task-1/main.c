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
    printf("Введите номер желаемого действия:\n");
    printf("1 - вывести информацию:\n");
    printf("2 - решить ханойскую башню без ходов A=>C и C=>A:\n");
    scanf("%d", &task_num);
    switch (task_num) {
        case 1:
            show_info_task();
            break;
        case 2:
            solve_hanoi_task();
            break;
        default:
            printf("Неверный номер действия.\n");
    }

    system("pause");
    return 0;
}

void show_info_task() {
    int disc_count = 64;
    unsigned long long turn_count = calc_turn_count(disc_count);
    printf("Для %d дисков потребуется сделать %llu ходов.\n", disc_count, turn_count);
    unsigned long long seconds = calc_time(disc_count);
    unsigned long long years = seconds / 60 / 60 / 24 / 365;
    printf("Это займёт %llu секунд или %llu лет.\n", seconds, years );
}

void solve_hanoi_task() {
    int disc_count;
    printf("Введите количество дисков.\n");
    scanf("%d", &disc_count);
    if(disc_count <=0) {
        printf("Количество дисков должно быть положительным.");
        return;
    }

    int dest;
    printf("Введите номер стержня, на который надо переместить диски (1 - B или 2 - C)\n");
    scanf("%d", &dest);
    if(dest < 1 || dest > 2) {
        printf("Неверный номер.");
        return;
    }

    solve_hanoi(disc_count, dest);
}
