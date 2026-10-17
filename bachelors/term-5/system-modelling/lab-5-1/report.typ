#import "../common.typ": *

#show: report.with(number: "5.1", title: "Имитационное моделирование СМО в GPSS World")

== Цель работы

Закрепление теоретических основ имитационного моделирования систем массового обслуживания и
приобретение практических навыков разработки имитационных моделей типовых систем на языках высокого
уровня.

== Исходные данные

+ $U slash M slash 1$
+ $E_3 slash E_2 slash 5 slash 5$

== Ход работы

=== Имитационная модель одноканальной системы массового обслуживания заданного типа на основе примеров 1, 1а

В данном разделе будет моделироваться система $U slash M slash 1$ при низком, среднем и высоком
коэффициенте нагрузки.

==== Низкий коэффициент нагрузки

В данной модели используется время появления транзактов в диапазоне 10±1. Средняя длина очереди
получилась равной 0.128, среднее время ожидания — 1.2795.

#figure(
  caption: [Текст GPSS-модели с использованием Uniform],
  ```gpss
  **************************************
  GENERATE (Uniform(1, 9, 11))
  QUEUE 1
  SEIZE node
  DEPART 1
  ADVANCE (Exponential(5, 0, 5))
  RELEASE node
  TERMINATE 2
  **************************************
  START 100000
  ```,
) <lst-low-uniform>

#figure(
  caption: [Результат симуляции модели из листинга~#ref(<lst-low-uniform>, supplement: none)],
  image("./assets/low-uniform-result.png"),
) <fig-low-uniform-result>

#figure(
  caption: [Текст GPSS-модели с использованием равномерного распределения в GENERATE],
  ```gpss
  **************************************
  GENERATE 10, 1
  QUEUE 1
  SEIZE node
  DEPART 1
  ADVANCE (Exponential(5, 0, 5))
  RELEASE node
  TERMINATE 2
  **************************************
  START 100000
  ```,
) <lst-low-generate>

#figure(
  caption: [Результат симуляции модели из листинга~#ref(<lst-low-generate>, supplement: none)],
  image("./assets/low-generate-result.png"),
) <fig-low-generate-result>

==== Средний коэффициент нагрузки

В данной модели используется время появления транзактов в диапазоне 5±1. Средняя длина очереди
получилась равной 79.6545, среднее время ожидания — 398.131.

#figure(
  caption: [Текст GPSS-модели с использованием Uniform],
  ```gpss
  **************************************
  GENERATE (Uniform(1, 4, 6))
  QUEUE 1
  SEIZE node
  DEPART 1
  ADVANCE (Exponential(5, 0, 5))
  RELEASE node
  TERMINATE 2
  **************************************
  START 100000
  ```,
) <lst-medium-uniform>

#figure(
  caption: [Результат симуляции модели из листинга~#ref(<lst-medium-uniform>, supplement: none)],
  image("./assets/medium-uniform-result.png"),
) <fig-medium-uniform-result>

#figure(
  caption: [Текст GPSS-модели с использованием равномерного распределения в GENERATE],
  ```gpss
  **************************************
  GENERATE 5, 1
  QUEUE 1
  SEIZE node
  DEPART 1
  ADVANCE (Exponential(5, 0, 5))
  RELEASE node
  TERMINATE 2
  **************************************
  START 100000
  ```,
) <lst-medium-generate>

#figure(
  caption: [Результат симуляции модели из листинга~#ref(<lst-medium-generate>, supplement: none)],
  image("./assets/medium-generate-result.png"),
) <fig-medium-generate-result>

==== Высокий коэффициент нагрузки

В данной модели используется время появления транзактов в диапазоне 2±1. Средняя длина очереди
получилась равной 37482.079, среднее время ожидания — 74924.7525.

#figure(
  caption: [Текст GPSS-модели с использованием Uniform],
  ```gpss
  **************************************
  GENERATE (Uniform(1, 1, 3))
  QUEUE 1
  SEIZE node
  DEPART 1
  ADVANCE (Exponential(5, 0, 5))
  RELEASE node
  TERMINATE 2
  **************************************
  START 100000
  **************************************
  ```,
) <lst-high-uniform>

#figure(
  caption: [Результат симуляции модели из листинга~#ref(<lst-high-uniform>, supplement: none)],
  image("./assets/high-uniform-result.png"),
) <fig-high-uniform-result>

#figure(
  caption: [Текст GPSS-модели с использованием равномерного распределения в GENERATE],
  ```gpss
  **************************************
  GENERATE 2, 1
  QUEUE 1
  SEIZE node
  DEPART 1
  ADVANCE (Exponential(5, 0, 5))
  RELEASE node
  TERMINATE 2
  **************************************
  START 100000
  **************************************
  ```,
) <lst-high-generate>

#figure(
  caption: [Результат симуляции модели из листинга~#ref(<lst-high-generate>, supplement: none)],
  image("./assets/high-generate-result.png"),
) <fig-high-generate-result>

==== Выводы по пункту 1

Среднее время ожидания и средняя длина очереди прямо пропорционально зависят от интенсивности
нагрузки, что отображено в результатах симуляции. Использование *Uniform* или равномерного
распределения в *GENERATE* не имеет существенной разницы.

=== Имитационная модель одноканальной системы массового обслуживания заданного типа на основе примеров 2, 2а

В данном разделе будет моделироваться система $E_3 slash E_2 slash 5 slash 5$ при 1000 и 10000
заявках.

#figure(
  caption: [Текст GPSS-модели],
  ```gpss
  *****************************************************************************
  node STORAGE 5
  T_w QTABLE channel_1,15,15,10
  T_u TABLE M1,30,30,10
  *****************************************************************************
  GENERATE (Exponential(1, 0, 2) + Exponential(1, 0, 9) + Exponential(1, 0, 7))
  TEST L Q$channel_1,5,reject
  QUEUE channel_1
  ENTER node
  DEPART channel_1
  ADVANCE (Exponential(1, 0, 68) + Exponential(1, 0, 19))
  LEAVE node
  TABULATE T_u
  TERMINATE 1
  reject TERMINATE 1
  *****************************************************************************
  ```,
) <lst-erlang>

==== 1000 заявок

#figure(
  caption: [Фрагмент отчёта симуляции при 1000 заявках],
  image("./assets/erlang-1000-report.png"),
) <fig-erlang-1000-report>

#figure(
  caption: [Гистограммы плотностей распределений времени пребывания $T_U$ и времени ожидания $T_W$
    заявок],
  grid(
    columns: 2,
    gutter: 0.8em,
    image("./assets/erlang-1000-hist-tu.png"), image("./assets/erlang-1000-hist-tw.png"),
  ),
) <fig-erlang-1000-hist>

==== 10000 заявок

#figure(
  caption: [Фрагмент отчёта симуляции при 10000 заявках],
  image("./assets/erlang-10000-report.png"),
) <fig-erlang-10000-report>

#figure(
  caption: [Гистограммы плотностей распределений времени пребывания $T_U$ и времени ожидания $T_W$
    заявок],
  grid(
    columns: 2,
    gutter: 0.8em,
    image("./assets/erlang-10000-hist-tu.png"), image("./assets/erlang-10000-hist-tw.png"),
  ),
) <fig-erlang-10000-hist>

==== Выводы по пункту 2

Средние значения различных параметров (длина очереди, время ожидания, время пребывания, частота
отказов) при 1000 и 10000 заявках радикально не отличаются, однако при 1000 заявках
среднеквадратичное отклонение выше, что говорит о том, что результат оказался менее точным.

== Выводы

В данной работе были разработаны различные модели и симулированы при помощи средств языка
программирования высокого уровня GPSS и среды GPSS World. Эта среда позволяет с лёгкостью
моделировать системы массового обслуживания и получить приближённые значения параметров, которые
довольно тяжело вычислять аналитически.
