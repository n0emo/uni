#include "thrdpool.h"

#include <stdio.h>

#include <conio.h>

int job(void *arg) {
    size_t id = (size_t) arg;
    DWORD thread = GetCurrentThreadId();
    printf("[%zu] (Thread ID: %lu): Begin\n", id, thread);
    Sleep(3000);
    printf("[%zu] (Thread ID: %lu): End\n", id, thread);
    return 0;
}

int main() {
    ThreadPool pool;
    thrdpool_init(&pool, 4);

    printf("Press 'SPACE' to create a new job\n");
    printf("Press 'q' to exit\n");

    size_t id = 0;
    bool quit = false;
    while (!quit) {
        int c = _getch();
        switch (c) {
            case ' ': {
                thrdpool_add_job(&pool, job, (void *) id);
                id++;
            } break;

            case 'q': {
                quit = true;
            } break;
        }
    }

    printf("Exiting\n");

    thrdpool_destroy(&pool);
}
