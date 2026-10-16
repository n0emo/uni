== Листинг src/http/server.c

```c
#include <mew/http/server.h>

#include <stdlib.h>

#include <mew/core.h>
#include <mew/log.h>

typedef struct {
    HttpServer *server;
    MewTcpStream stream;
} ThreadData;

bool init_socket(HttpServer *server);
bool accept_connection(HttpServer *server);
int handle_connection(void *arg);

bool http_server_init(HttpServer *server, HttpServerSettings settings) {
    bool result = false;

    server->handler = settings.handler;
    server->user_data = settings.user_data;
    server->settings = settings;
    MewThreadError error = thrdpool_init(&server->thread_pool, 100);
    if (error != MEW_THREAD_SUCCESS) {
        log_error("%s", mew_thread_error_description(error));
        goto defer;
    }

    if (!init_socket(server)) {
        goto defer;
    }

    return true;

defer:
    return result;
}

bool init_socket(HttpServer *server) {
    bool result = true;

    MewNativeTcpListenerOptions options;
    mew_tcplistener_init_default_native_options(&options);
    MewTcpListener listener;
    if (!mew_tcplistener_init_native(&listener, options)) {
        return_defer(false);
    }

    if (server->settings.host == NULL)
        server->settings.host = "0.0.0.0";
    if (!mew_tcplistener_bind(listener, server->settings.host, server->settings.port)) {
        return_defer(false);
    }

    server->listener = listener;
    return true;

defer:
    mew_tcplistener_close(listener);
    return result;
}

void http_server_destroy(HttpServer *server) {
    mew_tcplistener_close(server->listener);
    thrdpool_destroy(&server->thread_pool);
}

bool http_server_start(HttpServer *server) {
    if (!mew_tcplistener_listen(server->listener, 100))
        return false;

    log_info("Serving at %s:%d", server->settings.host, server->settings.port);

    while (true) {
        accept_connection(server);
    }
}

bool accept_connection(HttpServer *server) {
    bool result = true;
    ThreadData *data = NULL;
    MewTcpStream stream;
    if (!mew_tcplistener_accept(server->listener, &stream))
        return_defer(false);

    mew_tcpstream_set_timeout(stream, 120);

    data = calloc(1, sizeof(ThreadData));
    data->stream = stream;
    data->server = server;

    thrdpool_add_job(&server->thread_pool, handle_connection, (void *)data);

defer:
    if (!result) {
        mew_tcpstream_close(stream);
        if (data)
            free(data);
    }
    return result;
}

static bool serve_request(ThreadData *data) {
    bool result = true;

    Arena arena = {0};
    HttpRequest request = {0};
    Allocator alloc = new_arena_allocator(&arena);
    http_request_init(&request, alloc);

    HttpResponse response = {0};
    response.body.alloc = alloc;
    http_headermap_init(&response.headers, alloc);

    try(http_request_parse(&request, data->stream));
    http_headermap_insert_cstrs(&response.headers, "X-Frame-Options", "SAMEORIGIN");
    http_headermap_insert_cstrs(&response.headers, "Content-Security-Policy", "default-src 'self';");
    try(data->server->handler(&request, &response, data->server->user_data));

    try(http_response_write(&response, data->stream));

defer:
    arena_free_arena(&arena);
    return result;
}

int handle_connection(void *arg) {
    ThreadData *data = (ThreadData *)arg;

    while (serve_request(data)) {}

    mew_tcpstream_close(data->stream);
    free(data);
    return 0;
}
```
