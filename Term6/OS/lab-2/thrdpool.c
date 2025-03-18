#include "thrdpool.h"

#include <assert.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <inttypes.h>

#ifdef _WIN32
#   define THREAD_RETURN_T DWORD
#   define MUTEX_INIT InitializeCriticalSection
#   define MUTEX_DESTROY DeleteCriticalSection
#   define MUTEX_LOCK EnterCriticalSection
#   define MUTEX_UNLOCK LeaveCriticalSection
#   define COND_INIT InitializeConditionVariable
#   define COND_DESTROY(...)
#   define COND_WAIT(...) SleepConditionVariableCS(__VA_ARGS__, INFINITE)
#else
#   define THREAD_RETURN_T void *
#   define MUTEX_INIT(...) pthread_mutex_init(__VA_ARGS__, NULL)
#   define MUTEX_DESTROY pthread_mutex_destroy
#   define MUTEX_LOCK pthread_mutex_lock
#   define MUTEX_UNLOCK pthread_mutex_unlock
#   define COND_INIT(...) pthread_cond_init(__VA_ARGS__, NULL)
#   define COND_DESTROY pthread_cond_destroy
#   define COND_WAIT pthread_cond_wait
#endif

void queue_init(ThreadPoolQueue *queue) {
    queue->first = NULL;
    queue->last = NULL;
    queue->count = 0;
    queue->about_to_destroy = false;

    MUTEX_INIT(&queue->mutex);
    COND_INIT(&queue->not_empty);
}

void queue_destroy(ThreadPoolQueue *queue) {
    MUTEX_DESTROY(&queue->mutex);
    COND_DESTROY(&queue->not_empty);

    ThreadPoolJob *node = queue->first;
    ThreadPoolJob *next = NULL;
    while (node) {
        next = node->next;
        free(node);
        node = next;
    }
}

void queue_push(ThreadPoolQueue *queue, ThreadPoolJob job) {
    MUTEX_LOCK(&queue->mutex);

    ThreadPoolJob *node = malloc(sizeof(*node));
    memcpy(node, &job, sizeof(*node));

    if (queue->count == 0) {
        queue->first = node;
        queue->last = node;
        queue->count += 1;
    } else {
        queue->last->next = node;
        queue->last = node;
        queue->count += 1;
    }

    MUTEX_UNLOCK(&queue->mutex);

#ifdef _WIN32
    WakeConditionVariable(&queue->not_empty);
#else
    pthread_cond_signal(&queue->not_empty);
#endif
}

ThreadPoolJob queue_pop(ThreadPoolQueue *queue, bool *ok) {
    ThreadPoolJob result = {0};

    MUTEX_LOCK(&queue->mutex);
    while (queue->count == 0) {
        if (queue->about_to_destroy) {
            if (ok != NULL) *ok = false;
            MUTEX_UNLOCK(&queue->mutex);
            return result;
        }
        COND_WAIT(&queue->not_empty, &queue->mutex);
    }

    assert(queue->count > 0);
    queue->count -= 1;
    ThreadPoolJob *first = queue->first;
    queue->first = queue->first->next;
    memcpy(&result, first, sizeof(result));
    free(first);

    MUTEX_UNLOCK(&queue->mutex);

    if (ok != NULL) *ok = true;
    return result;
}

THREAD_RETURN_T thread_func(void *arg) {
    ThreadPool *pool = (ThreadPool *) arg;

#ifdef _WIN32
    HANDLE current_thrd = GetCurrentThread();
#else
    pthread_t current_thrd = pthread_self();
#endif

    MUTEX_LOCK(&pool->mutex);
    pool->threads_alive += 1;
    MUTEX_UNLOCK(&pool->mutex);

    while (!pool->cancel) {
        ThreadPoolJob job = queue_pop(&pool->queue, NULL);
        if (pool->cancel) break;

        int res = job.executor(job.arg);

        if (res != 0) {
            fprintf(stderr, "Job returned status %d (thread %" PRIu64 ")", res, (uint64_t) current_thrd);
        }
    }

    MUTEX_LOCK(&pool->mutex);
    pool->threads_alive -= 1;
    MUTEX_UNLOCK(&pool->mutex);

    return 0;
}

void thrdpool_init(ThreadPool *pool, size_t thread_count) {
    queue_init(&pool->queue);
    pool->thread_count = thread_count;
    pool->threads = malloc(sizeof(*pool->threads) * thread_count);
    pool->threads_alive = 0;
    pool->cancel = false;

    MUTEX_INIT(&pool->mutex);

    for (size_t i = 0; i < thread_count; i++) {
#ifdef _WIN32
        CreateThread(NULL, 0, thread_func, pool, 0, NULL);
#else
        pthread_create(&pool->threads[i], NULL, thread_func, pool);
#endif
    }
}

void thrdpool_destroy(ThreadPool *pool) {
    MUTEX_LOCK(&pool->queue.mutex);
    pool->queue.about_to_destroy = true;
    MUTEX_UNLOCK(&pool->queue.mutex);

    MUTEX_LOCK(&pool->mutex);
    pool->cancel = true;
    MUTEX_UNLOCK(&pool->mutex);

#ifdef _WIN32
    while (pool->threads_alive > 0) {
        WakeAllConditionVariable(&pool->queue.not_empty);
    }

    WaitForMultipleObjects(pool->thread_count, pool->threads, true, INFINITE);

#else
    while (pool->threads_alive > 0) {
        pthread_cond_broadcast(&pool->queue.not_empty);
    }
    for (size_t i = 0; i < pool->thread_count; i++) {
        void *res;
        pthread_join(pool->threads[i], &res);
    }
#endif

    queue_destroy(&pool->queue);

    MUTEX_DESTROY(&pool->mutex);
    free(pool->threads);
}

void thrdpool_add_job(ThreadPool *pool, JobExecutor *executor, void *arg) {
    ThreadPoolJob job = { executor, arg, NULL };
    queue_push(&pool->queue, job);
}
