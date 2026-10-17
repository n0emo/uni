свФЕДЕРАЛЬНОЕ АГЕНСТВО ЖЕЛЕЗНОДОРОЖНОГО ТРАНСПОРТА

Федеральное государственное бюджетное образовательное учреждение высшего
образования

«ПЕТЕРБУРГСКИЙ ГОСУДАРСТВЕННЫЙ УНИВЕРСИТЕТ ПУТЕЙ СООБЩЕНИЯ Императора
Александра I»

Кафедра «Информационные и вычислительные системы»

Дисциплина «Операционные системы»

#strong[ОТЧЁТ]

#strong[ПО ЛАБОРАТОРНОЙ РАБОТЕ №2]

#strong[«Исследование синхронизации на примере операционной системы
Windows -- NT»]

#figure(
  align(center)[#table(
    columns: 2,
    align: (auto,auto,),
    [Выполнил студент

    Факультет: АИТ

    Группа: ИВБ-211

    ], [Шефнер А.],
    [Проверил:

    Старший преподаватель кафедры

    «Информационные и вычислительные

    системы»

    ], [Молодкин И.А.],
  )]
  , kind: table
  )

#strong[Санкт-Петербург]

#strong[2025]

Оценочный лист результатов ЛР №2

Ф.И.О. студента: #emph[Шефнер А.]

Группа \_\_\_\_\_\_\_\_\_\_\_\_\_#emph[ИВБ-211]\_\_\_\_\_\_\_\_\_\_\_\_

Старший преподаватель кафедры

«Информационные и вычислительные

системы»#strong[ «\_\_» \_\_\_\_\_\_\_\_\_\_2025 г. Молодкин И.А.]

#strong[Цель]

#strong[ ]Изучить средства синхронизации многопоточного доступа на
примере Windows NT

#strong[Задание]

Разработать приложение, использующее несколько потоков. Выполнить
синхронизацию выполнения потоков с помощью одного из объектов по
указанию преподавателя.

#strong[Введение]

В данной лабораторной работе будет представлен порт микробиблиотеки
thrdpool, позволяющей создать пул потоков, с POSIX на Windows API.
Приложение демонстрирует создание и использование потоков, мьютексов и
условных переменных для формирования очереди задач, которые выполняются
последовательно забираются потоками из пула потоков и выполняются
параллельно. В качестве Pthread Mutex был использован
CONDITION\_VARIABLE, а Pthread Cond -- CRITICAL\_SECTION.

#strong[Ход Работы]

Представим интерфейс библиотеки в заголовочном файле. Обратите внимание,
что в зависимости от целевой платформы, с помощью препроцессора
подключается один из заголовочных файлов: windows.h или pthread.h.
Библиотека предоставляет функции взаимодействия с самим пулом потоков и
очередью.

#strong[thrdpool.h]

\#ifndef MEW\_INCLUDE\_MEW\_THRDPOOL\_H\_

\#define MEW\_INCLUDE\_MEW\_THRDPOOL\_H\_

\#include \<stdbool.h\>

\#ifdef \_WIN32

\#define WINDOWS\_LEAN\_AND\_MEAN

\#include \<windows.h\>

\#else

\#include \<pthread.h\>

\#endif

typedef int (JobExecutor)(void \*arg);

typedef struct ThreadPoolJob {

JobExecutor \*executor;

void \*arg;

struct ThreadPoolJob \*next;

} ThreadPoolJob;

typedef struct ThreadPoolQueue {

ThreadPoolJob \*first;

ThreadPoolJob \*last;

size\_t count;

bool about\_to\_destroy;

\#ifdef \_WIN32

CRITICAL\_SECTION mutex;

CONDITION\_VARIABLE not\_empty;

\#else

pthread\_mutex\_t mutex;

pthread\_cond\_t not\_empty;

\#endif

} ThreadPoolQueue;

void queue\_init(ThreadPoolQueue \*queue);

void queue\_destroy(ThreadPoolQueue \*queue);

void queue\_push(ThreadPoolQueue \*queue, ThreadPoolJob job);

ThreadPoolJob queue\_pop(ThreadPoolQueue \*queue, bool \*ok);

typedef struct ThreadPool {

ThreadPoolQueue queue;

size\_t thread\_count;

size\_t threads\_alive;

bool cancel;

\#ifdef \_WIN32

HANDLE \*threads;

CRITICAL\_SECTION mutex;

\#else

pthread\_t \*threads;

pthread\_mutext\_t mutex;

\#endif

} ThreadPool;

void thrdpool\_init(ThreadPool \*pool, size\_t thread\_count);

void thrdpool\_destroy(ThreadPool \*pool);

void thrdpool\_add\_job(ThreadPool \*pool, JobExecutor \*executor, void
\*arg);

\#endif /\/ MEW\_INCLUDE\_MEW\_THRDPOOL\_H\_

Далее представлена пользовательская программа, использующая пул потоков
для имитации работы.

#strong[main.c]

#strong[]

\#include \"thrdpool.h\"

\#include \<stdio.h\>

\#include \<conio.h\>

int job(void \*arg) {

size\_t id = (size\_t) arg;

DWORD thread = GetCurrentThreadId();

printf(\"\[%zu\] (Thread ID: %lu): Begin\\n\", id, thread);

Sleep(3000);

printf(\"\[%zu\] (Thread ID: %lu): End\\n\", id, thread);

return 0;

}

int main() {

ThreadPool pool;

thrdpool\_init(&pool, 4);

printf(\"Press \'SPACE\' to create a new job\\n\");

printf(\"Press \'q\' to exit\\n\");

size\_t id = 0;

bool quit = false;

while (!quit) {

int c = \_getch();

switch (c) {

case \' \': {

thrdpool\_add\_job(&pool, job, (void \*) id);

id++;

} break;

case \'q\': {

quit = true;

} break;

}

}

printf(\"Exiting\\n\");

thrdpool\_destroy(&pool);

}

Программа создаёт пул с 4 потоками и по запросу пользователя передаёт в
него задачи, выполнение которых занимает примерно 3 секунды. Так же по
запросу пользователя программа может «правильно» завершиться, т.е.
дождаться выполнения всех задач и освободить пул потоков.

Перед демонстрацией работы приложения следует ознакомиться с реализацией
библиотеки. В следующем листинге видно использование различных функций
Windows API для работы с потоками и объектами синхронизации. Там же
представлена реализация для POSIX, использование которой предусмотрено
для Linux и MacOS.

#strong[thrdpool.c]

#strong[]

\#include \"thrdpool.h\"

\#include \<assert.h\>

\#include \<stdlib.h\>

\#include \<stdio.h\>

\#include \<string.h\>

\#include \<inttypes.h\>

\#ifdef \_WIN32

\# define THREAD\_RETURN\_T DWORD

\# define MUTEX\_INIT InitializeCriticalSection

\# define MUTEX\_DESTROY DeleteCriticalSection

\# define MUTEX\_LOCK EnterCriticalSection

\# define MUTEX\_UNLOCK LeaveCriticalSection

\# define COND\_INIT InitializeConditionVariable

\# define COND\_DESTROY(...)

\# define COND\_WAIT(...) SleepConditionVariableCS(\_\_VA\_ARGS\_\_,
INFINITE)

\#else

\# define THREAD\_RETURN\_T void \*

\# define MUTEX\_INIT(...) pthread\_mutex\_init(\_\_VA\_ARGS\_\_, NULL)

\# define MUTEX\_DESTROY pthread\_mutex\_destroy

\# define MUTEX\_LOCK pthread\_mutex\_lock

\# define MUTEX\_UNLOCK pthread\_mutex\_unlock

\# define COND\_INIT(...) pthread\_cond\_init(\_\_VA\_ARGS\_\_, NULL)

\# define COND\_DESTROY pthread\_cond\_destroy

\# define COND\_WAIT pthread\_cond\_wait

\#endif

void queue\_init(ThreadPoolQueue \*queue) {

queue-\>first = NULL;

queue-\>last = NULL;

queue-\>count = 0;

queue-\>about\_to\_destroy = false;

MUTEX\_INIT(&queue-\>mutex);

COND\_INIT(&queue-\>not\_empty);

}

void queue\_destroy(ThreadPoolQueue \*queue) {

MUTEX\_DESTROY(&queue-\>mutex);

COND\_DESTROY(&queue-\>not\_empty);

ThreadPoolJob \*node = queue-\>first;

ThreadPoolJob \*next = NULL;

while (node) {

next = node-\>next;

free(node);

node = next;

}

}

void queue\_push(ThreadPoolQueue \*queue, ThreadPoolJob job) {

MUTEX\_LOCK(&queue-\>mutex);

ThreadPoolJob \*node = malloc(sizeof(\*node));

memcpy(node, &job, sizeof(\*node));

if (queue-\>count == 0) {

queue-\>first = node;

queue-\>last = node;

queue-\>count += 1;

} else {

queue-\>last-\>next = node;

queue-\>last = node;

queue-\>count += 1;

}

MUTEX\_UNLOCK(&queue-\>mutex);

\#ifdef \_WIN32

WakeConditionVariable(&queue-\>not\_empty);

\#else

pthread\_cond\_signal(&queue-\>not\_empty);

\#endif

}

ThreadPoolJob queue\_pop(ThreadPoolQueue \*queue, bool \*ok) {

ThreadPoolJob result = {0};

MUTEX\_LOCK(&queue-\>mutex);

while (queue-\>count == 0) {

if (queue-\>about\_to\_destroy) {

if (ok != NULL) \*ok = false;

MUTEX\_UNLOCK(&queue-\>mutex);

return result;

}

COND\_WAIT(&queue-\>not\_empty, &queue-\>mutex);

}

assert(queue-\>count \> 0);

queue-\>count -= 1;

ThreadPoolJob \*first = queue-\>first;

queue-\>first = queue-\>first-\>next;

memcpy(&result, first, sizeof(result));

free(first);

MUTEX\_UNLOCK(&queue-\>mutex);

if (ok != NULL) \*ok = true;

return result;

}

THREAD\_RETURN\_T thread\_func(void \*arg) {

ThreadPool \*pool = (ThreadPool \*) arg;

\#ifdef \_WIN32

HANDLE current\_thrd = GetCurrentThread();

\#else

pthread\_t current\_thrd = pthread\_self();

\#endif

MUTEX\_LOCK(&pool-\>mutex);

pool-\>threads\_alive += 1;

MUTEX\_UNLOCK(&pool-\>mutex);

while (!pool-\>cancel) {

ThreadPoolJob job = queue\_pop(&pool-\>queue, NULL);

if (pool-\>cancel) break;

int res = job.executor(job.arg);

if (res != 0) {

fprintf(stderr, \"Job returned status %d (thread %\" PRIu64 \")\", res,
(uint64\_t) current\_thrd);

}

}

MUTEX\_LOCK(&pool-\>mutex);

pool-\>threads\_alive -= 1;

MUTEX\_UNLOCK(&pool-\>mutex);

return 0;

}

void thrdpool\_init(ThreadPool \*pool, size\_t thread\_count) {

queue\_init(&pool-\>queue);

pool-\>thread\_count = thread\_count;

pool-\>threads = malloc(sizeof(\*pool-\>threads) \* thread\_count);

pool-\>threads\_alive = 0;

pool-\>cancel = false;

MUTEX\_INIT(&pool-\>mutex);

for (size\_t i = 0; i \< thread\_count; i++) {

\#ifdef \_WIN32

CreateThread(NULL, 0, thread\_func, pool, 0, NULL);

\#else

pthread\_create(&pool-\>threads\[i\], NULL, thread\_func, pool);

\#endif

}

}

void thrdpool\_destroy(ThreadPool \*pool) {

MUTEX\_LOCK(&pool-\>queue.mutex);

pool-\>queue.about\_to\_destroy = true;

MUTEX\_UNLOCK(&pool-\>queue.mutex);

MUTEX\_LOCK(&pool-\>mutex);

pool-\>cancel = true;

MUTEX\_UNLOCK(&pool-\>mutex);

\#ifdef \_WIN32

while (pool-\>threads\_alive \> 0) {

WakeAllConditionVariable(&pool-\>queue.not\_empty);

}

WaitForMultipleObjects(pool-\>thread\_count, pool-\>threads, true,
INFINITE);

\#else

while (pool-\>threads\_alive \> 0) {

pthread\_cond\_broadcast(&pool-\>queue.not\_empty);

}

for (size\_t i = 0; i \< pool-\>thread\_count; i++) {

void \*res;

pthread\_join(pool-\>threads\[i\], &res);

}

\#endif

queue\_destroy(&pool-\>queue);

MUTEX\_DESTROY(&pool-\>mutex);

free(pool-\>threads);

}

void thrdpool\_add\_job(ThreadPool \*pool, JobExecutor \*executor, void
\*arg) {

ThreadPoolJob job = { executor, arg, NULL };

queue\_push(&pool-\>queue, job);

}

#strong[Демонстрация работы приложения]

Процесс компиляции выглядит следующим образом. Для простоты компилятору
cl передаются файлы исходного кода напрямую --- это позволяет избежать
хлопот при работе с MSBuild или CMake.

#box(image("./assets/10000000000002FC000001495DBA6A53.png", height: 2.8516in, width: 6.6209in))

На следующем рисунке представлена демонстрация работы программы.
Пользователь запрашивает добавление нескольких задач. Обратите внимание,
что в логе выполнения программы есть всего 4 уникальных Thread ID (832,
7504, 9368 и 12456) -- они соответствуют 4 потокам, созданным пулом
потоков. После запроса на выход из программы, она вывела “Exiting” и
сообщения о конце выполнения четырёх задач. Программа будет ожидать
выполнения тех задач, которые уже загружены в рабочие потоки. Остальные
будут отменены.

#box(image("./assets/1000000000000196000001F66062AC73.png", height: 5.2299in, width: 4.2299in))

#strong[Вывод]

В ходе работы была изучена работа с примитивами синхронизации Windows
API и разработано приложение, использующее пул потоков.
