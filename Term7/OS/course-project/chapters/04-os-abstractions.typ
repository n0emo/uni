== 4.1 Сокеты

При разработке сетевых приложений одними из самых важных примитивов ОС являются
сокеты. Они позволяют отправлять пакеты информации, подключаться к другим
устройствам сети, или, напротив, слушать подключения от других устройств. При
разработке библиотеки особое внимание было уделено сокетам. В библиотеку
добавлены интерфейсы TcpListener и TcpStream, позволяющие слушать подключения и
обмениваться данными по сокету соответственно.

На рисунке #ref(label("tcplistener"), supplement: none) показан интерфейс
TcpListener. При работе с сокетами на сервере обычно вызываются функции bind и
listen для начала работы с сокетом, и далее в цикле вызывается функция accept.
Разрабатываемая библиотека сохранила этот принцип взаимодействия с
нативными сокетами.

#figure(
  ```c
  typedef bool(mew_tcplistener_bind_t)(void *data, const char *host, uint16_t port);
  typedef bool(mew_tcplistener_listen_t)(void *data, uint32_t max_connections);
  typedef bool(mew_tcplistener_accept_t)(void *data, MewTcpStream *stream);
  typedef bool(mew_tcplistener_close_t)(void *data);

  struct MewTcpListener {
      void *data;
      mew_tcplistener_bind_t *bind;
      mew_tcplistener_listen_t *listen;
      mew_tcplistener_accept_t *accept;
      mew_tcplistener_close_t *close;
  };
  ```,
  kind: image,
  caption: [Интерфейс MewTcpListener],
) <tcplistener>

После успешного вызова функции accept пользователь получает объект TcpStream, с
помощью которого возможен обмен данных с клиентом. С помощью операций read и
write возможно получать и отправлять данные. @tcpstream показывает интерфейс
сокета.

#figure(
  ```c
  typedef bool(mew_tcpstream_set_timeout_t)(void *data, uint32_t seconds);
  typedef ptrdiff_t(mew_tcpstream_read_t)(void *data, char *buf, uintptr_t size);
  typedef ptrdiff_t(mew_tcpstream_write_t)(void *data, const char *buf, uintptr_t size);
  typedef bool(mew_tcpstream_sendfile_t)(void *data, const char *path, uintptr_t size);
  typedef bool(mew_tcpstream_close_t)(void *data);

  struct MewTcpStream {
      void *data;
      mew_tcpstream_set_timeout_t *set_timeout;
      mew_tcpstream_read_t *read;
      mew_tcpstream_write_t *write;
      mew_tcpstream_sendfile_t *sendfile;
      mew_tcpstream_close_t *close;
  };
  ```,
  kind: image,
  caption: [Интерфейс MewTcpStream],
) <tcpstream>

Особый интерес представляет собой функция sendfile. Она позволяет отправить файл по
сети, не читая содержимое файла в пользовательском контексте и не выделяя память
под временное хранение содержимого. В Linux и BSD системах этот функционал
реализуется с помощью системного вызова sendfile. На Windows с обновлением
Windows Socket 2 также появилась функция для отправки файла по
сокету -- TransmitFile.

Интерфейс и реализация сокетов для POSIX и Windows платформ представлены в
приложении @sup-socket.

== 4.2 Файловая система

Для работы с файлами в разрабатываемой библиотеке представлен минимальный
набор функций, необходимый для реализации её высокоуровневых компонентов. Эти
функции показаны на рисунке #ref(label("fs-c"), supplement: none).

#figure(
  ```c
  bool mew_fs_exists(const char *path);
  bool mew_fs_get_size(const char *path, usize *size);
  bool mew_fs_read_file_to_sb(const char *path, StringBuilder *asb);
  ```,
  kind: image,
  caption: [Функции работы с файловой системой]
) <fs-c>

== 4.3 Потоки

Одной из важных характеристик любого веб-сервера является возможность
обслуживания нескольких подключений одновременно. В библиотеке для организации
одновременной обработки входящих подключений используется пул потоков.

Для реализации пула потоков в библиотеке представлены следующие примитивы:
1. поток;
2. мьютекс;
3. условная переменная.

=== Примитив потока

@thread показывает набор функций для работы с потоками. Для POSIX систем
указатель MewThread является pthread_t, для Windows -- HANDLE потока,
созданный функцией CreateThread.

#figure(
  ```c
  typedef void *MewThread;

  typedef int(mew_thread_func_t)(void *arg);
  MewThreadError mew_thread_create(MewThread *handle, mew_thread_func_t *func, void *arg);
  MewThread mew_thread_current(void);
  MewThreadError mew_thread_join(MewThread thread, int *return_status);
  MewThreadError mew_thread_detach(MewThread thread);
  ```,
  kind: image,
  caption: [Функции работы с потоками],
) <thread>

=== Примитив мьютекса

@mutex показывает набор функций для работы с мьютексами. Для POSIX систем
MewMutex будет pthread_mutex_t, для Windows -- CRITICAL_SECTION.

#figure(
  ```c
  typedef void *MewMutex;

  MewThreadError mew_mutex_init(MewMutex *mtx);
  MewThreadError mew_mutex_destroy(MewMutex mtx);
  MewThreadError mew_mutex_lock(MewMutex mtx);
  MewThreadError mew_mutex_unlock(MewMutex mtx);
  ```,
  kind: image,
  caption: [Функции работы с мьютексами]
) <mutex>

=== Примитив условной переменной

@cond показывает набор функций для работы с условными переменными. Для POSIX
 систем MewCond будет pthread_cond_t, для Windows -- CONDITION_VARIABLE.

#figure(
  ```c
  typedef void *MewCond;

  MewThreadError mew_cond_init(MewCond *cond);
  MewThreadError mew_cond_destroy(MewCond cond);
  MewThreadError mew_cond_wait(MewCond cond, MewMutex mtx);
  MewThreadError mew_cond_notify(MewCond cond);
  MewThreadError mew_cond_notify_all(MewCond cond);
  ```,
  kind: image,
  caption: [Функции работы с мьютексами]
) <cond>
