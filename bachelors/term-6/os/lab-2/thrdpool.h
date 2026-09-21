#ifndef MEW_INCLUDE_MEW_THRDPOOL_H_
#define MEW_INCLUDE_MEW_THRDPOOL_H_

#include <stdbool.h>

#ifdef _WIN32
#define WINDOWS_LEAN_AND_MEAN
#include <windows.h>
#else
#include <pthread.h>
#endif

typedef int (JobExecutor)(void *arg);

typedef struct ThreadPoolJob {
    JobExecutor *executor;
    void *arg;
    struct ThreadPoolJob *next;
} ThreadPoolJob;

typedef struct ThreadPoolQueue {
    ThreadPoolJob *first;
    ThreadPoolJob *last;
    size_t count;
    bool about_to_destroy;

#ifdef _WIN32
    CRITICAL_SECTION mutex;
    CONDITION_VARIABLE not_empty;
#else
    pthread_mutex_t mutex;
    pthread_cond_t not_empty;
#endif
} ThreadPoolQueue;

void queue_init(ThreadPoolQueue *queue);
void queue_destroy(ThreadPoolQueue *queue);
void queue_push(ThreadPoolQueue *queue, ThreadPoolJob job);
ThreadPoolJob queue_pop(ThreadPoolQueue *queue, bool *ok);

typedef struct ThreadPool {
    ThreadPoolQueue queue;
    size_t thread_count;
    size_t threads_alive;
    bool cancel;

#ifdef _WIN32
    HANDLE *threads;
    CRITICAL_SECTION mutex;
#else
    pthread_t *threads;
    pthread_mutext_t mutex;
#endif
} ThreadPool;

void thrdpool_init(ThreadPool *pool, size_t thread_count);
void thrdpool_destroy(ThreadPool *pool);
void thrdpool_add_job(ThreadPool *pool, JobExecutor *executor, void *arg);

#endif // MEW_INCLUDE_MEW_THRDPOOL_H_
