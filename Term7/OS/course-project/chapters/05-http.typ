== 5.1 Чтение запроса

Работа с HTTP-запросами в библиотеке реализована в точности по спецификации
RFC №2616@rfc2616. Согласно стандарту, запрос состоит из трёх секций:
1. строка запроса;
2. заголовки запроса;
3. тело запроса (может быть опущено).

Строка запроса и заголовки разделяются символами переноса строки CR+LF.
Статусная строка содержит название метода, путь к ресурсу и версию протокола
HTTP. Каждый заголовок записан в формате пары ключ-значение, разделённой
двоеточием. Ключ нечувствителен к регистру. Если тело присутствует,
оно отделяется от заголовков двумя переносами строки, а в заголовках содержится
"Content-Length" с размером тела в байтах. @http-request показывает
пример простого запроса.

#figure(
  ```http
  GET /README.md HTTP/1.1
  Host: localhost:8080
  User-Agent: curl/8.7.1
  Accept: */*
  ```,
  kind: image,
  caption: [Пример минимального HTTP-запроса],
) <http-request>

Для моделирования запроса в коде создана структура HttpRequest (см. рисунок
#ref(label("http-request-struct"), supplement: none)).

#figure(
  ```c
  typedef struct {
      HttpMethod method;
      StringView resource_path;
      StringView version;
      HttpHeaderMap headers;
      StringBuilder body;

      HttpRequestContext ctx;
  } HttpRequest;
  ```,
  kind: image,
  caption: [Структура HttpRequest],
) <http-request-struct>

== 5.2 Отправка ответа

Ответ по спецификации имеет те же секции, что и запрос, за исключением строки
запроса, вместо которой указывается статусная строка. В статусной строке
указываются версия протокола, статусный код и текстовое описание статусного
кода. @http-response показывает пример ответа.

#figure(
  ```http
  HTTP/1.1 200 OK
  Server: mewserver
  Content-Length: 45

  # Mewlib

  Zero-dependency HTTP library for C
  ```,
  kind: image,
  caption: [Пример минимального HTTP-ответа],
) <http-response>

Для моделирования ответа в коде создана структура HttpResponse (см. рисунок
#ref(label("http-response-struct"), supplement: none)).

#figure(
  ```c
  typedef struct {
      HttpStatus status;
      HttpHeaderMap headers;
      ResponseBody body;
  } HttpResponse;
  ```,
  kind: image,
  caption: [Структура HttpResponse],
) <http-response-struct>

Тело ответа может иметь разный источник. В частности, в
библиотеке различаются три вида тела: отсутствие тела, буфер и sendfile.
По этой причине структура ResponseBody -- это
тип-сумма#footnote[Тип-сумма (англ. discriminated union, или tagged union) --
  алгебраический тип данных, позволяющий хранить один из различных, но
  фиксированных типов (вариантов), и включающий в себя метку для указания какой
  вариант хранится в значении тип-суммы.]
(см. рисунок #ref(label("response-body-struct"), supplement: none)).
В языке C возможно эмулировать тип-сумму с помощью объединения (union) и метки.

#figure(
  ```c
  typedef struct {
      Allocator alloc;
      ResponseBodyKind kind;

      union {
          StringBuilder bytes;
          ResponseSendFile sendfile;
      } as;
  } ResponseBody;
  ```,
  kind: image,
  caption: [Структура ResponseBody],
) <response-body-struct>

== 5.3 Организация сервера

Разрабатываемая библиотека предоставляет HTTP-сервер, функции которого включают
в себя чтение запроса, вызов функции обработки пользователя и запись ответа
сервера. Обработка каждого подключения делегируется пулу потоков. @http-server
показывает интерфейс взаимодействия с сервером. Пользователь должен определить
функцию-обработчик handler и вызвать функцию http_server_init, передав туда
настройки слушания и функцию-обработчик. После успешной инициализации для
запуска сервера следует вызвать функцию http_server_start.

#figure(
  ```c
  typedef struct HttpServer {
      ThreadPool thread_pool;
      HttpRequestHandler *handler;
      void *user_data;
      MewTcpListener listener;
      HttpServerSettings settings;
  } HttpServer;

  bool http_server_init(HttpServer *server, HttpServerSettings settings);
  void http_server_destroy(HttpServer *server);
  bool http_server_start(HttpServer *server);
  ```,
  kind: image,
  caption: [Интерфейс HTTP-сервера],
) <http-server>

Функция-обработчик имеет следующие параметры:
1. Запрос типа HttpRequest.
2. Ответ типа Httpresponse.
3. Указатель на пользовательские данные.

Функция возвращает булевое значение "истина" в случае успешной обработки и
"ложь" в ином случае.

Реализация функций HTTP-сервера представлена в приложении @sup-server.
