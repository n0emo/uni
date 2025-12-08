== 3.1 Аллокаторы

Модель выделения памяти оказывает значительное влияние как на производительность
программы, так и на опыт разработчика. В разрабатываемой библиотеке с самого
начала её разработки присутствует механизм использования разных аллокаторов.

В библиотеку включён простой интерфейс, показанный на рисунке
#ref(label("allocator-interface"), supplement: none). Для описания интерфейса в
языке C можно воспользоваться техникой "толстый указатель". Её суть заключается в
создании структуры, содержащей два указателя -- указатель на динамические данные
и указатель на таблицу виртуальных функций. В своей сути, толстый указатель
позволяет гибко сгруппировать данные и поведение в одном объекте, что и было
сделано при проектировании аллокатора.

#figure(
  ```c
  typedef struct {
      allocator_alloc_t *const alloc;
      allocator_free_t *const free;
      allocator_calloc_t *const calloc;
      allocator_realloc_t *const realloc;
  } AllocatorFunctionTable;

  typedef struct Allocator {
      void *data;
      const AllocatorFunctionTable *ftable;
  } Allocator;
  ```,
  kind: image,
  caption: [Интерфейс Allocator]
) <allocator-interface>

Библиотека предоставляет две реализации данного интерфейса:
1. Обёртка над libc malloc.
2. Линейный аллокатор.

Линейный аллокатор позволяет освобождать множество выделений за раз.
Код реализации представлен в приложении @sup-arena.
Подробнее о линейном аллокаторе и других стратегиях выделения памяти можно
прочитать в статье В. Балуна@allocators. 

Помимо использования предоставленных
реализаций интерфейса, пользователь может реализовать простой интерфейс для
своего аллокатора памяти, что актуально для встраиваемых систем, в то время как
настольных программ интересным выбором аллокатора может стать сторонний
аллокатор  jemalloc@jemalloc, который во многих ситуациях работает значительно
быстрее, чем реализация malloc из GNU libc.

== 3.2 Контейнеры

Никакая хоть сколько-нибудь сложная программа не обходится без использования
динамических структур данных. В частности, для разработки HTTP-сервера особый
интерес представляют динамический массив, хеш-таблицу и ассоциативный массив.

=== Динамический массив

Динамический массив с уверенностью можно назвать самой важной структурой данных
в программировании. Стандартная библиотека C не предоставляет готовую реализацию
этой структуры. Реализация динамического массива включена в состав
библиотеки и носит название "MewVector"
(рисунок #ref(label("mewvector"), supplement: none)).

#figure(
  ```c
typedef struct MewVector {
    Allocator alloc;
    char *data;
    usize capacity;
    usize count;
    usize element_size;
} MewVector;

void mew_vec_init(MewVector *vec, Allocator alloc, size_t element_size);
void mew_vec_destroy(MewVector *vec);
void mew_vec_reserve(MewVector *vec, size_t new_capacity);
void *mew_vec_get(MewVector *vec, size_t index);
void mew_vec_push(MewVector *vec, const void *element);
void mew_vec_insert_at(MewVector *vec, const void *element, size_t index);
void mew_vec_delete_at(MewVector *vec, size_t index);
  ```,
  kind: image,
  caption: [Объявление MewVector]
) <mewvector>

Реализация MewVector представлена в приложении @sup-vector. Можно заметить
использование интерфейса аллокатора, что позволяет отделить динамический
массив от конкретной модели выделения памяти.

=== Словарь

Для упрощения реализации разных видов словарей решено использовать эмуляцию
наследования в C. @mewmap показывает объявление структуры MewMap. В терминологии
объектно-ориентированного программирования эту структуру можно назвать
абстрактным классом. Конкретные реализации словаря должны иметь поле типа
MewMap в качестве первого поля структуры. Такой подход часто можно заметить,
исследуя, к примеру, исходный код ядра Linux.

#figure(
  ```c
  typedef struct MewMap {
      Allocator alloc;
      MewMapFuncTable funcs;
      usize key_size;
      usize value_size;
      usize count;
      void *user_data;
  } MewMap;
  ```,
  kind: image,
  caption: [Структура MewMap]
) <mewmap>

Для определения поведения необходимо реализовать "методы" интерфейса из
таблицы виртуальных функций, показанной на рисунке 
#ref(label("mewmap-vtable"), supplement: none).

#figure(
  ```c
  typedef void MewMapDestroy(MewMap *map);
  typedef void MewMapInsert(MewMap *map, const void *key, const void *value);
  typedef bool MewMapPop(MewMap *map, const void *key, void *found_key, void *value);
  typedef void *MewMapGet(MewMap *map, const void *key);
  typedef bool MewMapIterate(MewMap *map, MewMapIter iter, void *user_data);

  typedef struct MewMapFuncTable {
      MewMapDestroy *destroy;
      MewMapInsert *insert;
      MewMapPop *pop;
      MewMapGet *get;
      MewMapIterate *iterate;
  } MewMapFuncTable;
  ```,
  kind: image,
  caption: [Таблица виртуальных функций MewMap]
) <mewmap-vtable>

Разрабатываемая в рамках проекта библиотека предлагает реализации абстрактного
класса MewMap на основе хеш-таблицы с открытой адресацией и ассоциативного
массива.

== 3.3 Работа со строками

Для эффективной работы с запросами и ответами в HTTP, а так же при генерации
HTML-страниц очень полезен обстоятельный набор функций для работы со строками.
Библиотека предлагает структуры данных StringView и StringBuilder, а также
функции для работы и конвертации C-строк, представлений строк и строковых
построителей. Пример использования этих функций можно увидеть в отрывке кода
генерации списка классов HTML-элемента, представленного на рисунке 
#ref(label("strings"), supplement: none).

#figure(
  ```c
  sb_append_cstr(&html->sb, " class=\"");
  sb_append_sv
    &html->sb,
    *(StringView *)mew_vec_get(&html->classes, 0)
  );
  for (size_t i = 1; i < html->classes.count; i++) {
      sb_append_char(&html->sb, ' ');
      sb_append_sv(
        &html->sb,
        *(StringView *)mew_vec_get(&html->classes, 0)
      );
  }
  sb_append_cstr(&html->sb, "\"");
  ```,
  kind: image,
  caption: [Пример использования StringView, StringBuilder и MewVec]
) <strings>
