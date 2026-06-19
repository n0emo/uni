== Wassel

#align(horizon)[
  *Библиотека для Rust*
  - Поставляется в виде отдельного крейта для встраивания в сторонние приложения
  - Программный API для конфигурации стека плагинов без манифеста `wassel.toml`
  - Используется как библиотека внутри административной панели (крейт `admin-dashboard`)
  *Веб-сервер*
  - Асинхронный сервер на базе tokio и hyper
  - URL-роутинг на базе префиксного дерева
  *CLI-приложение*
  - Запуск сервера на основе манифеста `wassel.toml`
  - Сборка плагинов: запуск команды `build.cmd` из манифеста `plugin.toml`
  - Кэширование собранных компонентов в директории `.wassel`
]

#pagebreak()

*Foreign Function Interface*

На основе функций Rust генерируются функции C. Wassel можно использовать из любого языка
программирования, поддерживающего FFI.

```cpp
typedef struct wassel_Stack wassel_Stack;

wassel_Stack *wassel_stack_load(const char *path);

void wassel_stack_unload(struct wassel_Stack *stack);

void wassel_stack_handle(wassel_Stack *stack,
                         wassel_HttpRequest *request,
                         wassel_HttpResponse *response);
```

#pagebreak()


#align(center + horizon)[
  *Панель администратора*
  #image("../assets/screenshot-dashboard.png", width: 85%)
]
