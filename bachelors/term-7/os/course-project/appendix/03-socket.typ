== Листинг src/core/os/socket_posix.c

```c
#include <mew/core/os/socket.h>

#include <arpa/inet.h>
#include <errno.h>
#include <fcntl.h>
#include <netdb.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <unistd.h>

#ifndef __APPLE__
    #include <sys/sendfile.h>
#endif

#include <mew/core.h>
#include <mew/log.h>

mew_tcplistener_bind_t mew_tcplistener_native_bind;
mew_tcplistener_listen_t mew_tcplistener_native_listen;
mew_tcplistener_accept_t mew_tcplistener_native_accept;
mew_tcplistener_close_t mew_tcplistener_native_close;

mew_tcpstream_set_timeout_t mew_tcpstream_native_set_timeout;
mew_tcpstream_read_t mew_tcpstream_native_read;
mew_tcpstream_write_t mew_tcpstream_native_write;
mew_tcpstream_sendfile_t mew_tcpstream_native_sendfile;
mew_tcpstream_close_t mew_tcpstream_native_close;

void mew_tcplistener_init_default_native_options(MewNativeTcpListenerOptions *options) {
    memset(options, 0, sizeof(*options));
    options->reuse_address = true;
}

bool mew_tcplistener_init_native(MewTcpListener *listener, MewNativeTcpListenerOptions options) {
    bool result = true;

    int sd = socket(AF_INET, SOCK_STREAM, 0);
    if (sd == -1) {
        log_error("Error creating socker: %s", strerror(errno));
        return_defer(false);
    }

    if (options.reuse_address) {
        int option = 1;
        int ret = setsockopt(sd, SOL_SOCKET, SO_REUSEADDR, &option, sizeof(option));
        if (ret == -1) {
            log_error("Error creating socket: %s", strerror(errno));
            return_defer(false);
        }
    }

    listener->data = (void *)(uintptr_t)sd;
    listener->bind = &mew_tcplistener_native_bind;
    listener->listen = &mew_tcplistener_native_listen;
    listener->accept = &mew_tcplistener_native_accept;
    listener->close = &mew_tcplistener_native_close;
    return true;

defer:
    if (sd != -1)
        close(sd);
    return result;
}

bool mew_tcplistener_native_bind(void *data, const char *host, uint16_t port) {
    int ret;
    int sd = (int)(uintptr_t)data;

    struct sockaddr_in addr = {
        .sin_family = AF_INET,
        .sin_port = htons(port),
        .sin_zero = {0},
    };

    ret = inet_pton(AF_INET, host, &addr.sin_addr);
    if (ret != 1) {
        log_error("Invalid address: %s", strerror(errno));
        return false;
    }

    ret = bind(sd, (struct sockaddr *)&addr, sizeof(addr));
    if (ret == -1) {
        log_error("Error binding socket: %s", strerror(errno));
        return false;
    }

    return true;
}

bool mew_tcplistener_native_listen(void *data, uint32_t max_connections) {
    int sd = (int)(uintptr_t)data;
    int ret = listen(sd, (int)max_connections);
    if (ret == -1) {
        log_error("Error listening: %s", strerror(errno));
        return false;
    } else {
        return true;
    }
}

bool mew_tcplistener_native_accept(void *data, MewTcpStream *stream) {
    int sd = (int)(uintptr_t)data;
    int stream_sd = accept(sd, NULL, NULL);
    if (stream_sd == -1)
        return false;
    memset(stream, 0, sizeof(*stream));
    stream->data = (void *)(uintptr_t)stream_sd;
    stream->set_timeout = &mew_tcpstream_native_set_timeout;
    stream->read = &mew_tcpstream_native_read;
    stream->write = &mew_tcpstream_native_write;
    stream->sendfile = &mew_tcpstream_native_sendfile;
    stream->close = &mew_tcpstream_native_close;
    return true;
}

bool mew_tcplistener_native_close(void *data) {
    int sd = (int)(uintptr_t)data;
    if (sd == -1)
        return true;
    return (close(sd) == 0);
}

bool mew_tcpstream_native_set_timeout(void *data, uint32_t seconds) {
    int sd = (int)(uintptr_t)data;
    struct timeval tv;
    tv.tv_sec = seconds;
    tv.tv_usec = 0;
    int ret = setsockopt(sd, SOL_SOCKET, SO_RCVTIMEO, (const char *)&tv, sizeof tv);
    return ret != -1;
}

ptrdiff_t mew_tcpstream_native_read(void *data, char *buf, uintptr_t size) {
    int sd = (int)(uintptr_t)data;
    return recv(sd, buf, size, 0);
}

ptrdiff_t mew_tcpstream_native_write(void *data, const char *buf, uintptr_t size) {
    int sd = (int)(uintptr_t)data;
    return send(sd, buf, size, MSG_NOSIGNAL);
}

bool mew_tcpstream_native_sendfile(void *data, const char *path, uintptr_t size) {
    int sd = (int)(uintptr_t)data;
    int body_fd = open(path, O_RDONLY);
    if (body_fd < 0)
        return false;

#ifdef __APPLE__
    off_t offset = (off_t)size;
    int ret = sendfile(body_fd, sd, 0, &offset, NULL, 0);
    if (close(body_fd) < 0 || ret != 0)
        return false;
#else
    ptrdiff_t ret = sendfile(sd, body_fd, NULL, size);
    if (close(body_fd) < 0 || ret != (ssize_t)size)
        return false;
#endif

    return true;
}

bool mew_tcpstream_native_close(void *data) {
    int sd = (int)(uintptr_t)data;
    return close(sd) == 0;
}
```

#pagebreak()
== Листинг src/core/os/socket_windows.c

```c
#include <mew/core/os/threads.h>

#include <stdio.h>
#include <stdlib.h>

#define WINDOWS_LEAN_AND_MEAN
#include <windows.h>

#define MEW_FUNC_NOT_IMPLEMENTED()                                                                                     \
    do {                                                                                                               \
        fprintf(stderr, "Not yet implemented: %s", __FUNCTION__);                                                      \
        abort();                                                                                                       \
    } while (0)

typedef struct MewThreadContext {
    mew_thread_func_t *func;
    void *arg;
} MewThreadContext;

MewThreadError mew_threads_error_from_windows();

unsigned long mew_thread_func(void *arg) {
    MewThreadContext *ctx = (MewThreadContext *)arg;
    unsigned long result = (unsigned long)ctx->func(ctx->arg);
    free(ctx);
    return result;
}

MewThreadError mew_thread_create(MewThread *handle, mew_thread_func_t *func, void *arg) {
    if (handle == NULL || func == NULL) {
        return MEW_THREAD_ERROR_INVALID_ARGUMENT;
    }

    MewThreadContext *ctx = malloc(sizeof(*ctx));
    ctx->func = func;
    ctx->arg = arg;

    HANDLE result = CreateThread(NULL, 0, mew_thread_func, ctx, 0, NULL);
    if (result != NULL) {
        *handle = result;
        return MEW_THREAD_SUCCESS;
    } else {
        free(ctx);
        return mew_threads_error_from_windows();
    }
}

MewThread mew_thread_current(void) {
    return (MewThread)GetCurrentThread();
}

MewThreadError mew_thread_join(MewThread thread, int *return_status) {
    if (thread == NULL) {
        return MEW_THREAD_ERROR_INVALID_ARGUMENT;
    }

    HANDLE handle = (HANDLE)thread;
    DWORD result = WaitForSingleObject(handle, INFINITE);
    if (result == WAIT_FAILED) {
        return mew_threads_error_from_windows();
    }

    if (return_status == NULL) {
        return MEW_THREAD_SUCCESS;
    }

    DWORD status;
    if (GetExitCodeThread(handle, &status)) {
        *return_status = (int)status;
        return MEW_THREAD_SUCCESS;
    } else {
        return mew_threads_error_from_windows();
    }
}

MewThreadError mew_thread_detach(MewThread thread) {
    if (thread == NULL) {
        return MEW_THREAD_ERROR_INVALID_ARGUMENT;
    }

    if (CloseHandle(thread)) {
        return MEW_THREAD_SUCCESS;
    } else {
        return mew_threads_error_from_windows();
    }
}

MewThreadError mew_mutex_init(MewMutex *mtx) {
    if (mtx == NULL) {
        return MEW_THREAD_ERROR_INVALID_ARGUMENT;
    }

    CRITICAL_SECTION *section = malloc(sizeof(*section));
    if (section == NULL) {
        return MEW_THREAD_ERROR_OUT_OF_MEMORY;
    }

    InitializeCriticalSection(section);
    *mtx = (MewMutex)section;
    return MEW_THREAD_SUCCESS;
}

MewThreadError mew_mutex_destroy(MewMutex mtx) {
    if (mtx == NULL) {
        return MEW_THREAD_ERROR_INVALID_ARGUMENT;
    }

    CRITICAL_SECTION *section = (CRITICAL_SECTION *)mtx;
    DeleteCriticalSection(section);
    free(section);
    return MEW_THREAD_SUCCESS;
}

MewThreadError mew_mutex_lock(MewMutex mtx) {
    if (mtx == NULL) {
        return MEW_THREAD_ERROR_INVALID_ARGUMENT;
    }

    CRITICAL_SECTION *section = (CRITICAL_SECTION *)mtx;
    EnterCriticalSection(section);
    return MEW_THREAD_SUCCESS;
}

MewThreadError mew_mutex_unlock(MewMutex mtx) {
    if (mtx == NULL) {
        return MEW_THREAD_ERROR_INVALID_ARGUMENT;
    }

    CRITICAL_SECTION *section = (CRITICAL_SECTION *)mtx;
    LeaveCriticalSection(section);
    return MEW_THREAD_SUCCESS;
}

MewThreadError mew_cond_init(MewCond *cond) {
    if (cond == NULL) {
        return MEW_THREAD_ERROR_INVALID_ARGUMENT;
    }

    CONDITION_VARIABLE *condition = malloc(sizeof(*condition));
    if (condition == NULL) {
        return MEW_THREAD_ERROR_OUT_OF_MEMORY;
    }

    InitializeConditionVariable(condition);
    *cond = (MewCond)condition;
    return MEW_THREAD_SUCCESS;
}

MewThreadError mew_cond_destroy(MewCond cond) {
    if (cond == NULL) {
        return MEW_THREAD_ERROR_INVALID_ARGUMENT;
    }

    // Windows condition variables don't need explicit destruction
    CONDITION_VARIABLE *condition = (CONDITION_VARIABLE *)cond;
    free(condition);
    return MEW_THREAD_SUCCESS;
}

MewThreadError mew_cond_wait(MewCond cond, MewMutex mtx) {
    if (cond == NULL || mtx == NULL) {
        return MEW_THREAD_ERROR_INVALID_ARGUMENT;
    }

    CONDITION_VARIABLE *condition = (CONDITION_VARIABLE *)cond;
    CRITICAL_SECTION *section = (CRITICAL_SECTION *)mtx;

    if (!SleepConditionVariableCS(condition, section, INFINITE)) {
        return mew_threads_error_from_windows();
    } else {
        return MEW_THREAD_SUCCESS;
    }
}

MewThreadError mew_cond_notify(MewCond cond) {
    if (cond == NULL) {
        return MEW_THREAD_ERROR_INVALID_ARGUMENT;
    }

    CONDITION_VARIABLE *condition = (CONDITION_VARIABLE *)cond;
    WakeConditionVariable(condition);
    return MEW_THREAD_SUCCESS;
}

MewThreadError mew_cond_notify_all(MewCond cond) {
    if (cond == NULL) {
        return MEW_THREAD_ERROR_INVALID_ARGUMENT;
    }

    CONDITION_VARIABLE *condition = (CONDITION_VARIABLE *)cond;
    WakeAllConditionVariable(condition);
    return MEW_THREAD_SUCCESS;
}

MewThreadError mew_threads_error_from_windows() {
    DWORD error = GetLastError();
    switch (error) {
        case ERROR_SUCCESS:
            return MEW_THREAD_SUCCESS;
        case ERROR_ACCESS_DENIED:
            return MEW_THREAD_ERROR_PERMISSIONS;
        case ERROR_INVALID_HANDLE:
            return MEW_THREAD_ERROR_NOT_FOUND;
        case ERROR_NO_SYSTEM_RESOURCES:
        case ERROR_OUTOFMEMORY:
            return MEW_THREAD_ERROR_OUT_OF_MEMORY;
        case ERROR_BUSY:
            return MEW_THREAD_ERROR_BUSY;
        case ERROR_INVALID_PARAMETER:
            return MEW_THREAD_ERROR_INVALID_ARGUMENT;
        case ERROR_POSSIBLE_DEADLOCK:
            return MEW_THREAD_ERROR_DEADLOCK;
        case ERROR_NOT_ENOUGH_MEMORY:
            return MEW_THREAD_ERROR_TRY_AGAIN;
        default:
            return MEW_THREAD_ERROR_UNKNOWN;
    }
}
```
