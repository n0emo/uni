#strong[ФЕДЕРАЛЬНОЕ АГЕНТСТВО ЖЕЛЕЗНОДОРОЖНОГО ТРАНСПОРТА]

#strong[]

Федеральное#emph[ ]государственное бюджетное образовательное учреждение
высшего образования

#strong[ «Петербургский государственный университет путей сообщения]

#strong[Императора Александра I»]

#strong[#strong[ ]\(ФГБОУ ВО ПГУПС)]

#strong[]

Факультет #emph[«Автоматизация и интеллектуальные технологии»]

Кафедра #emph[«Информационные и вычислительные системы»]

#emph[#strong[]]

#strong[]

#strong[]

#strong[]

#strong[КУРСОВОЙ ПРОЕКТ ]

#strong[]

#strong[по дисциплине ]

#strong[]

#strong[«КОМПЬЮТЕРНАЯ ГРАФИКА»]

#strong[]

#strong[на тему: «Реализация трёхмерной сцены с освещением и тенями с
помощью техники Ray marching на базе API WebGPU»]

#strong[]

#strong[]

#strong[]

#strong[]

#strong[]

#strong[]

#figure(
  align(center)[#table(
    columns: 4,
    align: (auto,auto,auto,auto,),
    [#emph[]

    #emph[Обучающийся]

    ], [], [], [А. Шефнер],
    [#emph[]], [подпись, дата

    ], [], [И.О. Фамилия

    #emph[ИВБ-211]

    ],
    [#emph[]

    #emph[]

    #emph[Руководитель#emph[#strong[]]]

    ], [#strong[]

    #strong[]

    ], [#strong[]], [Группа

    О.В. Проурзин

    ],
    [#emph[]

    #emph[#strong[]]

    ], [подпись, дата

    #strong[]

    ], [#strong[]], [И.О. Фамилия

    ],
  )]
  , kind: table
  )

#strong[]

#strong[]

#emph[#strong[]]

#emph[#strong[]]

#emph[#strong[]]

#emph[#strong[]]

#emph[#strong[]]

#emph[#strong[]]

#emph[#strong[]]

Санкт-Петербург 2024

#strong[Федеральное государственное бюджетное образовательное
учреждение]

#strong[высшего образования]

#strong[«ПЕТЕРБУРГСКИЙ ГОСУДАРСТВЕННЫЙ УНИВЕРСИТЕТ ПУТЕЙ СООБЩЕНИЯ
ИМПЕРАТОРА АЛЕКСАНДРА I»]

#strong[\(ФГБОУ ВО ПГУПС)]

#strong[]

#figure(
  align(center)[#table(
    columns: 4,
    align: (auto,auto,auto,auto,),
    [Факультет], [Автоматизация и интеллектуальные
    технологии], [Кафедра], [Информационные и вычислительные системы],
  )]
  , kind: table
  )

#emph[]

#emph[]

#figure(
  align(center)[#table(
    columns: 2,
    align: (auto,auto,),
    [Специальность (направление)], [09.03.01 «Информатика и
    вычислительная техника»],
    [Специализация (профиль, магистерская программа)], [Программное
    обеспечение средств вычислительной техники и автоматизированных
    систем],
  )]
  , kind: table
  )

#strong[]

#strong[ЗАДАНИЕ]

#strong[на курсовой проект по дисциплине «Моделирование систем»]

#emph[#strong[]]

Тема:

#figure(
  align(center)[#table(
    columns: 1,
    align: (auto,),
    [«Реализация трёхмерной сцены с освещением и тенями с помощью
    техники Ray marching на базе API WebGPU»],
  )]
  , kind: table
  )

Срок сдачи обучающимся законченной работы: до даты сдачи экзамена по
дисциплине.

Исходные данные к работе

#figure(
  align(center)[#table(
    columns: 1,
    align: (auto,),
    [Научные статьи],
    [Учебные пособия],
    [Официальная документация программных инструментов ],
    [Примеры выполнения курсовых работ по дисциплине],
  )]
  , kind: table
  )

Содержание

#figure(
  align(center)[#table(
    columns: 1,
    align: (auto,),
    [Описание используемых технологий --- API WebGPU, Rust, wgpu],
    [Создание основы для кроссплатформенного графического приложения],
    [Реализация шейдера, выполняющего отрисовку сцены с помощью Ray
    marching],
    [Разработка и развёртывание веб-приложения, включающего в себя
    реализованную сцену],
  )]
  , kind: table
  )

Перечень графического материала

#figure(
  align(center)[#table(
    columns: 1,
    align: (auto,),
    [Рисунков - 3],
    [Листингов - 6],
    [],
    [],
  )]
  , kind: table
  )

Дата выдачи задания: «23» сентября 2024 г.

Руководитель: \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_ О.В. Проурзин

Задание принял к исполнению: \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_ А. Шефнер

#strong[]

#strong[]

#strong[КАЛЕНДАРНЫЙ ПЛАН ]

#strong[]

#figure(
  align(center)[#table(
    columns: 4,
    align: (auto,auto,auto,auto,),
    [№

    п/п

    ], [

    Наименование этапов

    выполнения КП

    ], [Сроки выполнения этапов КР], [Примечание],
    [1], [Сбор материалов. Подбор литературы и иных источников.
    Формирование замысла КП.], [30.10.24 -- 05.11.24], [],
    [2], [Разработка кода программы], [05.1.24-14.11.24], [],
    [3], [Написание разделов КП], [15.11.24-16.11.24], [],
    [4], [Подготовка введения, заключения КП. Оформление КП.
    ], [17.11.24], [],
    [5], [Защита КП (Демонстрация программы)], [Период промежуточной
    аттестации до даты сдачи экзамена по дисциплине ], [],
  )]
  , kind: table
  )

#strong[Обучающийся \_\_\_\_\_\_\_\_\_\_\_\_ А. Шефнер]

#strong[]

#strong[Руководитель \_\_\_\_\_\_\_\_\_\_\_\_ О.В. Проурзин]

#strong[]

#emph[#strong[]]

#emph[Примечание (см. СМК РД 7.3.212-216)]

#emph[Завершенный курсовой проект (работа) подписывается преподавателем
«к защите» в течении семестра.]

#emph[Защиты курсовых проектов (работ) обучающимися проводятся в период
промежуточной аттестации до даты сдачи экзамена/зачета/диф. зачета по
соответствующей дисциплине в часы консультаций, установленные кафедрой.]

#emph[#strong[]]

#strong[]

#strong[Оценочный лист]#super[#strong[#footnote[ #strong[Объем: 30-45000
знаков с пробелами (см. статистика).]

#strong[]]]]

Объем (знаков с пробелами): 37133

#figure(
  align(center)[#table(
    columns: 5,
    align: (auto,auto,auto,auto,auto,),
    table.header([#strong[№]

      #strong[]

      ], [#strong[Материалы для оценки ]], [#strong[Показатель]

      #strong[ оценивания ]

      ], [#strong[Критерии ]

      #strong[оценивания]

      ], [#strong[Шкала оценивания]],),
    table.hline(),
    table.cell(rowspan: 3)[1

    ], table.cell(rowspan: 3)[Нативное и веб-приложение с трёхмерной
    сценой, включающей в себя свет и
    тени], table.cell(rowspan: 3)[Работоспособность и производительность
    приложения], [Разработана полноценная программа, отвечающая базовым
    требованиям и имеющая дополнительный функционал; получены
    результаты, соответствующие утвержденному заданию.], [40

    35

    ],
    [Разработана программа, отвечающая базовым требованиям; получены
    результаты, соответствующие утвержденному заданию.

    При достижении результата работы сделаны замечания, частично
    исправленные обучающимся.

    ], [30

    25

    20

    ],
    [Представлена программа, имеющая не полный функционал; получены
    результаты, частично соответствующие или не соответствующие
    утвержденному заданию. По процессу и результату исследования сделаны
    замечания, не исправленные обучающимся.], [15

    10

    5

    0

    ],
    table.cell(rowspan: 6)[2], table.cell(rowspan: 6)[Пояснительная
    записка (текст КП)], table.cell(rowspan: 3)[Оформление пояснительной
    записки (текста КП) ], [Соответствует рекомендациям], [15],
    [Частично соответствует ], [10

    5

    ],
    [Не соответствует], [0],
    table.cell(rowspan: 3)[Структура и логика изложения
    текста], [Присутствует], [15],
    [Частично присутствует], [10

    5

    ],
    [Отсутствует], [0],
    table.cell(colspan: 4)[#strong[Итого количество баллов за курсовой
    проект (максимально 70)]], [#strong[]],
  )]
  , kind: table
  )

К защите: руководитель (подпись, расшифровка, дата):
\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_

Допуск к защите курсовой работе:  45 баллов

При защите:

#figure(
  align(center)[#table(
    columns: 2,
    align: (auto,auto,),
    [получены полные ответы на вопросы -- 25-30 баллов;], [],
    [получены достаточно полные ответы на вопросы -- 20-24 баллов;], [],
    [получены неполные ответы на вопросы или часть вопросов -- 11-20
    баллов;], [],
    [не получены ответы на вопросы или вопросы не раскрыты -- 0-10
    баллов.], [],
  )]
  , kind: table
  )

Итого баллов за курсовой проект: \_\_\_\_\_\_\_\_\_\_

Заключение: #emph[рецензируемый курсовой проект соответствует
требованиям основной профессиональной образовательной программы
направления 09.03.01 «Информатика и вычислительная техника»..]

#emph[]

Итоговая оценка: \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_

«Отлично» - 86-100 баллов; «Хорошо» - 75-85 баллов; «Удовлетворительно»
\- 60-74 баллов; «Неудовлетворительно» - менее 59 баллов (вкл.)

Руководитель (подпись, расшифровка, дата):
\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_#strong[ ]

#strong[]

#strong[]

= ​<anchor>ВВЕДЕНИЕ
<введение>

Целью данной курсовой работы является освоение современных
кроссплатформенных технологий отрисовки изображения графическим
адаптером на базе API WebGPU. Одна из реализаций этого программного
интерфейса wgpu является безопасной и кроссплатформенной графической
библиотекой для Rust на базе WebGPU, которая может использоваться для
графики и вычислений на графическом адаптере. В рамках проекта будет
разработано нативное и веб-приложение, реализующее трёхмерную сцену с
помощью техники Ray marching и включающую в себя работу со светом и
тенью.

Основная часть приложения будет написана на языке Rust --- языке
программирования общего назначения с автоматическим управлением памятью
посредством идиомы RAII. За счёт компиляции в нативный код с помощью
LLVM этот язык обеспечивает высокую производительность приложения, что
важно для высоконагруженных графических приложений, а функции
безопасности памяти делают его идеальным выбором для разработки
поддерживаемых и надёжных приложений.

Трёхмерная сцена будет реализована целиком на шейдере на языке WGSL ---
WebGPU Shading Language. С помощью знаковых функций расстояния по
технике Ray marching на сцене будут представлены земля и небо, храм и
губка Менгера. Будет реализованы алгоритм диффузного освещения и работа
с тенями. Сцена будет изменяться во времени и поддерживать
пользовательское управление камерой.

Для реализации кроссплатформенного приложения будет использована
библиотека winit, которая позволяет собрать проект для ОС Windows,
Linux, MacOS, Android и iOS, а так же поддерживает архитектуру сборки
WASM32 (WebAssembly) для запуска приложения в браузере. Веб-приложение
будет построено с помощью Leptos и Trunk, а развёрнуто на хостинге Fly
на базе веб-сервера Nginx. Такой выбор технологий позволит быстро
разработать производительное приложение, доступное на всех основных
платформах.

= ​<anchor-1>ИСТОРИЯ WEBGPU
<история-webgpu>

#strong[WebGPU] --- современный API для выполнение графических и
вычислительных задач на графическом адаптере в веб-страницах, впервые
появившийся 18 мая 2021 года. Впервые о замене WebGL начали говорить в
2016 году, когда на презентации Google была представлена концепция
«WebGL Next». 27 января 2017 года на конференции Khronos, посвящённой
идеям WebGL Next, были представлены рабочие прототипы от Google, Mozilla
и Apple. Google показали новый API, реализующий OpenGL в движке
Chromium, а Mozilla и Apple показали свой API в движках Servo и Safari
соотвественно, очень походивший на API Metal. В 2018 году компания
Google заявила о намерении реализовать будущий стандарт WebGPU в
браузере Chrome. Позже движение в эту сторону начали Mozilla и Apple.

Стандарт WebGPU предполагает новый язык шейдеров WGSL, который должен
транслироваться в язык шейдеров текущей платформы. Так же браузеры
Google Chrome и Firefox поддерживают шейдеры, скомпилированные в SPIR-V,
однако это не закреплено в стандарте, поскольку Apple не сможет
реализовать его поддержку в Safari из-за лицензионных ограничений.
Синтаксис языка решили сделать похожим на синтаксис Rust.

На сегодняшний день WebGPU поддерживается по умолчанию в браузерах на
базе Chromium на ОС Windows, MacOS, ChromeOS и Android, а так же
доступна для использования в нативных приложениях для ОС Windows, MacOS,
Linux, Android и iOS посредством библиотек wgpu и dawn. API WebGPU в
будущем может стать полноценной заменой OpenGL, предоставляющей все
необходимые функции работы с графическим адаптером для приложений и
видеоигр.

= ​<anchor-2>СОЗДАНИЕ ОКНА ПРИЛОЖЕНИЯ
<создание-окна-приложения>

Для создания графического приложения была выбрана библиотека winit. Она
предоставляет функции, похожие на функции GLUT --- создание окна и
поверхности отрисовки и обработка событий. Для её использования первым
делом необходимо создать окно. Для нативной архитектуры доступно
стандартное создание окна, а для WASM32 возможно использование уже
существующего Canvas элемента.

Следующим действием будет получение WebGPU-адаптера, совместимого с
поверхностью winit. Адаптер позволит передавать команды графического
адаптера в нативный драйвер операционной системы, которые далее будут
выполнены на реальном графическом адаптере. Далее с помощью
WebGPU-адаптера необходимо создать логическое устройство и очередь
команд. Именно с помощью них в дальнейшем графическое приложение сможет
выполнить отрисовку изображения.

Последним действием будет создание цикла событий и запуск приложения.
Winit и WebGPU имеют асинхронную «природу» выполнения, поэтому для
дальнейшей работы приложения потребуется асинхронная среда выполнения.
Для нативной платформы подойдёт pollster, с помощью которого можно
заблокировать главный поток программы в асинхронным потоком (Future)
winit. Для платформы WASM32 возможно использование асинхронной среды
самого браузера, для этого вместо блокирования основного потока
необходимо создавать браузерный Worker-поток, который и будет
осуществлять выполнение цикла событий приложения.

Графическое приложение, которое будет работать в данном окне,
абстрагировано в типаж framework::Application (см. приложение 1), для
реализации которого у приложения должны быть функции init и render для
инициализации и отрисовки соотвественно. Так же для использование
дополнительных функций возможно реализовать функции required\_features,
update и resize.

= ​<anchor-3>РАЗРАБОТКА ОСНОВЫ ГРАФИЧЕСКОГО ПРИЛОЖЕНИЯ
<разработка-основы-графического-приложения>

Поскольку тема данного курсового проекта целиком завязана на Ray
marching, было реализовано минимальное приложение, выводящее один
квадрат во весь экран и изменяющее настройки камеры в зависимости от
нажатых клавиш. Для этого была создана структура
course\_project::Application (см. приложение 2), реализующая типаж
framework::Application.

В ассоциированной функции инициализации приложения добавлено создание
Render Pipeline для отрисовки квадрата и запуска фрагментного шейдера, а
так же Uniform Buffer с состоянием приложения и настройками камеры, в
которой далее будет производиться запись из потока приложение и из
которого будет производиться чтение в шейдере. Помимо этого был создан
вершинный буфер, в который были загружены вершины двух треугольников,
формирующих квадрат.

В методе структуры render происходит отрисовка приложения. Для этого
первым делом обновляются время и настройки камеры, после чего
производится запись новой информации в Uniform буфер. Далее создаётся
Render Pass, для которого устанавливаются Pipeline и необходимые буферы
и вызывается команда draw. В конце метода набор команда Render Pass
передаётся в очередь команд графического адаптера.

В методе update выполняется обработка нажатий клавиш, которые влияют на
настройки камеры. Для этого предусмотрена структура CameraController,
содержащая в себе информацию о текущем направлении движения камеры. В
методе resize в состояние приложения записываются новые ширина и высота
окна.

= ​<anchor-4>РЕАЛИЗАЦИЯ ТРЁХМЕРНОЙ СЦЕНЫ НА ЯЗЫКЕ WGSL
<реализация-трёхмерной-сцены-на-языке-wgsl>

Следующим действием в разработке приложения будет создание фрагментного
шейдера (см. приложение 3), который будет выполнять алгоритм Ray
marching. Принцип работы алгоритма очень просто. Первым делом из камеры
выпускается луч, который представляет из себя шагающую точку. Каждый шаг
точки производится в направлении луча на расстояние, равное расстоянию
от этой точки до сцены. Таким образом обеспечивается безопасное
расстояние, проходя которое луч не столкнётся с объектами сцены. Если
расстояние до сцены ниже определённого порога, считается, что луч
столкнулся с объектом. Для алгоритма определено ограничение по
количеству шагов и максимальное расстояние, пройденное лучём.

Во входной точке шейдера на основе настроек камеры инициализируется луч,
задающийся исходной точкой и направлением. После этого выполняется сам
алгоритм. Шейдер было решено разделить на некоторые модули,
специализирующиеся на конкретных моментах сцены. В следующих абзацах
будет рассказано о каждом модуле.

#strong[Модуль объектов ]содержит в себе функции для основных объектов
сцены --- землю, храм и губку Менгера. Все эти функции в своей основе
комбинируют знаковые функции расстояния для различных примитивов. В
основе объекта земли лежит расстояние для плоскости, перпендикулярной
оси Y. В основе храма лежит комбинация таких примитивов, как усечённые
цилиндры и кубы. Комбинация функций расстояния осуществляется с помощью
функции минимума, которая позволяет сделать из двух простых объектов
объект сложнее. Помимо этого в функциях объектов выполняется покраска
точки в случае, если расстояние меньше порога. Для этого они принимают
вектор цвета по указателю. В качестве результата выполнения функции они
возвращают расстояние до самого объекта для использование в алгоритме
Ray marching.

#strong[Модуль знаковых функций расстояния ]содержит в себе функции,
вычисляющие знаковое расстояние до некоторого примитива. Знаковое
расстояние --- это расширение понятия расстояния, при котором расстояние
от точки внутри объекта до самого объекта определено отрицательным
значением. В модуле представлены функции расстояния до земли, усечённого
цилиндра, куба и губки Менгера. Последняя является результатом
комбинации различных искажений траектории движения луча и функцией
расстояния до куба. Так же в модуле представлена вспомогательная функция
расстояния до всей сцены.

#strong[Модуль работы со светом и тенью] содержит в себе функции,
необходимые для построение света и тени на сцене. Для освещения
реализован алгоритм диффузного освещения, для которого необходимо
значение нормали в точке, для которой вычисляется уровень освещённости.
Поскольку вся сцена представлена функцией расстояния, эта задача
становится тривиальной. Достаточно вычислить приближённое значение
градиента сцены в точке, что представлено в функции scene\_normal. Тени
в Ray marching так же вычисляются тривиальным образом. Из точки, в
которую попал изначальный луч, необходимо выпустить ещё один луч в
сторону источника света. Если луч дошёл до него --- исходная точка
освещена, а если столкнулся со сценой по пути --- исходная точка
затемнена.

#strong[Модуль утилит] содержит в себе различные полезные функции для
искажения движения луча и матричных вращений. Особый интерес здесь
представляет функция smin, которая является реализацией «мягкого
минимума». Её использование вместо обычной функции минимума позволяет
сделать слияние двух объектов мягким, то есть они будут «переходить»
друг в друга.

= ​<anchor-5>РАЗРАБОТКА ВЕБ-ПРИЛОЖЕНИЯ И РАЗВЁРТЫВАНИЕ
<разработка-веб-приложения-и-развёртывание>

Для реализации веб-приложения была выбрана технология клиентской
отрисовки (CSR) и библиотека Leptos, позволяющая описывать реактивные
HTML компоненты на языке Rust. Был создан компонент App (см. приложение
4), включающий в свой состав элемент Canvas и запускающий на нём
приложение framework::Application. Итоговое веб-приложение собирается с
помощью Trunk и Stylance. Для их интеграции разработан файл конфигурации
Trunk.toml, содержащий в себе вызов stylance (см. \ приложение 5).

Развёртывание приложения выполняется на хостинге Fly. Он позволяет
запустить любое приложение, содержащееся в Docker-контейнере. Был
разработан Dockerfile (см. приложение 6), копирующий в себя артефакты
сборки Trunk и вызывающий веб-сервер Nginx. Итоговое приложение доступно
по ссылке: #link("https://cg-labs.fly.dev/")[https:/\/cg-labs.fly.dev]
--- читатель может к ней обратиться и убедиться в работоспособности
приложения (при условии, что его браузер поддерживает WebGPU).

= ​<anchor-6>ЗАКЛЮЧЕНИЕ
<заключение>

В ходе работы была реализована трёхмерная сцена с помощью алгоритма Ray
marching и было разработано веб-приложение, включающее реализованную
сцену на базе Api WebGPU на языках программирования Rust и WGSL и были
получены практические навыки в создании высокопроизводительных
кроссплатформенных графических приложений. Демонстрацию работы программы
смотрите в приложениях 7-9.

В процессе работы над проектом была изучена история и особенности API
WebGPU, что позволило глубже понять его преимущества по сравнению с
предыдущими стандартами, такими как OpenGL. Реализация графического
приложения с использованием библиотеки winit обеспечила
кроссплатформенность, что является важным аспектом в современном
программировании. Создание трёхмерной сцены с использованием шейдеров на
языке WGSL и алгоритма Ray marching позволило не только визуализировать
объекты, но и реализовать динамическое освещение и тени, что значительно
повысило качество графики. Пользовательское управление камерой добавило
интерактивности, что является важным элементом в современных графических
приложениях.

Таким образом, выполненная работа не только подтвердила теоретические
знания о современных графических технологиях, но и предоставила
практический опыт в разработке кроссплатформенных приложений. Полученные
результаты могут быть использованы в дальнейшем для создания более
сложных графических систем и приложений, а также для углубленного
изучения возможностей API WebGPU и языка Rust.

= ​<anchor-7>СПИСОК ИСПОЛЬЗОВАННЫХ ИСТОЧНИКОВ
<список-использованных-источников>
#strong[]

+ Основы современных компьютерных технологий / Учебник под ред. проф.
  А.Д. Хомоненко. -- СПб.: КОРОНА принт, 2009. -- 672 с.

+ Клабник Стив, Николс Кэрол. Программирование на Rust. СПб.: Питер,
  \2021. 592 с. (Серия «Для профессионалов»).

+ Introduction to wgpu. URL: https:/\/sotrh.github.io/learn-wgpu

+ An introduction to Raymarching. \ URL:
  #link("https://youtu.be/khblXafu7iA?si=Xiw5PBCybeg3hjfK")

= ​<anchor-8><anchor-9><anchor-10><anchor-11>ПРИЛОЖЕНИЯ
<приложения>
= 
<section>
#strong[​<anchor-12><anchor-13><anchor-14><anchor-15>ПРИЛОЖЕНИЕ 1 (типаж
framework::Application)]

pub trait Application {

const SRGB: bool = true;

const NAME: &str;

const DESCRIPTION: &str;

fn init(config: &SurfaceConfiguration, ctx: &WgpuContext) -\> Self;

fn render(&mut self, view: &wgpu::TextureView, dt: f32, ctx:
&WgpuContext);

fn required\_features() -\> wgpu::Features {

wgpu::Features::empty()

}

fn required\_limits() -\> wgpu::Limits {

wgpu::Limits::downlevel\_webgl2\_defaults()

}

fn resize(&mut self, config: &SurfaceConfiguration, ctx: &WgpuContext) {

let \_ = (config, ctx);

}

fn update(&mut self, event: WindowEvent) {

let \_ = event;

}

}

#strong[​<anchor-16><anchor-17><anchor-18><anchor-19>ПРИЛОЖЕНИЕ 2
(course-project/src/app.rs)]

use std::f32::consts::PI;

use framework::WgpuContext;

use wgpu::{

util::{BufferInitDescriptor, DeviceExt as \_},

BindGroup, BindGroupDescriptor, BindGroupEntry,
BindGroupLayoutDescriptor,

BindGroupLayoutEntry, BindingType, BlendState, Buffer,
BufferBindingType, BufferUsages,

ColorTargetState, ColorWrites, CommandEncoderDescriptor, FragmentState,
Operations,

PipelineCompilationOptions, PrimitiveState, RenderPassColorAttachment,
RenderPassDescriptor,

RenderPipelineDescriptor, ShaderStages, VertexAttribute,
VertexBufferLayout, VertexState,

VertexStepMode,

};

use winit::{

event::WindowEvent,

keyboard::{KeyCode, PhysicalKey},

};

\#\[repr(C)\]

\#\[derive(Debug, Clone, Copy, bytemuck::Pod, bytemuck::Zeroable,
Default)\]

struct StateUniform {

time: f32,

width: f32,

height: f32,

camera\_angle\_horizontal: f32,

camera\_angle\_vertical: f32,

camera\_zoom: f32,

}

\#\[derive(Default, Debug)\]

struct CameraController {

rotate\_left: bool,

rotate\_right: bool,

rotate\_up: bool,

rotate\_down: bool,

zoom\_in: bool,

zoom\_out: bool,

}

pub struct Application {

pipeline: wgpu::RenderPipeline,

vertex\_buf: wgpu::Buffer,

state\_uniform: StateUniform,

state\_buffer: Buffer,

state\_bind\_group: BindGroup,

camera\_controler: CameraController,

}

impl framework::Application for Application {

const NAME: &str = \"КП. Ray marching\";

const DESCRIPTION: &str =

\"Курсовой проект - реализация трёхмерной сцены с помощью Ray
marching\";

fn init(config: &wgpu::SurfaceConfiguration, ctx: &WgpuContext) -\> Self
{

let shader = ctx

\.device

\.create\_shader\_module(wgpu::include\_wgsl!(\"shader.wgsl\"));

let vertices: \[Vertex; 6\] = \[

Vertex { pos: \[1.0, 1.0\] },

Vertex { pos: \[-1.0, 1.0\] },

Vertex { pos: \[-1.0, -1.0\] },

Vertex { pos: \[-1.0, -1.0\] },

Vertex { pos: \[1.0, -1.0\] },

Vertex { pos: \[1.0, 1.0\] },

\];

let vertex\_buf = ctx.device.create\_buffer\_init(&BufferInitDescriptor
{

label: Some(\"Screen Buffer\"),

contents: bytemuck::cast\_slice(&vertices),

usage: BufferUsages::VERTEX,

});

let state\_uniform = StateUniform {

width: config.width as f32,

height: config.height as f32,

camera\_zoom: 2.0,

\..Default::default()

};

let state\_buffer =
ctx.device.create\_buffer\_init(&BufferInitDescriptor {

label: Some(\"State Uniform Buffer\"),

contents: bytemuck::bytes\_of(&state\_uniform),

usage: BufferUsages::UNIFORM | BufferUsages::COPY\_DST,

});

let state\_bind\_group\_layout =

ctx.device

\.create\_bind\_group\_layout(&BindGroupLayoutDescriptor {

label: Some(\"State Uniform Bind Group Layout\"),

entries: &\[BindGroupLayoutEntry {

binding: 0,

visibility: ShaderStages::VERTEX\_FRAGMENT,

ty: BindingType::Buffer {

ty: BufferBindingType::Uniform,

has\_dynamic\_offset: false,

min\_binding\_size: None,

},

count: None,

}\],

});

let state\_bind\_group =
ctx.device.create\_bind\_group(&BindGroupDescriptor {

label: Some(\"State Uniform Bind Group\"),

layout: &state\_bind\_group\_layout,

entries: &\[BindGroupEntry {

binding: 0,

resource: state\_buffer.as\_entire\_binding(),

}\],

});

let pipeline =

ctx.device

\.create\_render\_pipeline(&RenderPipelineDescriptor {

label: Some(\"Ray Marching Render Pipeline\"),

layout: Some(&ctx.device.create\_pipeline\_layout(

&wgpu::PipelineLayoutDescriptor {

label: Some(\"Ray Marching Pipeline Layout\"),

bind\_group\_layouts: &\[&state\_bind\_group\_layout\],

push\_constant\_ranges: &\[\],

},

)),

vertex: VertexState {

module: &shader,

entry\_point: Some(\"vs\_main\"),

compilation\_options: PipelineCompilationOptions::default(),

buffers: &\[Vertex::layout()\],

},

fragment: Some(FragmentState {

module: &shader,

entry\_point: Some(\"fs\_main\"),

targets: &\[Some(ColorTargetState {

format: config.view\_formats\[0\],

blend: Some(BlendState::ALPHA\_BLENDING),

write\_mask: ColorWrites::ALL,

})\],

compilation\_options: PipelineCompilationOptions::default(),

}),

primitive: PrimitiveState {

topology: wgpu::PrimitiveTopology::TriangleList,

strip\_index\_format: None,

front\_face: wgpu::FrontFace::Ccw,

cull\_mode: Some(wgpu::Face::Back),

polygon\_mode: wgpu::PolygonMode::Fill,

unclipped\_depth: false,

conservative: false,

},

depth\_stencil: None,

multisample: wgpu::MultisampleState {

count: 1,

mask: !0,

alpha\_to\_coverage\_enabled: false,

},

multiview: None,

cache: None,

});

let camera\_controler = CameraController::default();

Self {

pipeline,

vertex\_buf,

state\_uniform,

state\_buffer,

state\_bind\_group,

camera\_controler,

}

}

fn render(

&mut self,

view: &wgpu::TextureView,

dt: f32,

WgpuContext {

instance: \_,

adapter: \_,

device,

queue,

}: &WgpuContext,

) {

self.state\_uniform.time += dt;

{

let c = &self.camera\_controler;

let u = &mut self.state\_uniform;

let a\_s = dt;

let z\_s = dt \* 3.0;

if c.rotate\_left {

u.camera\_angle\_horizontal -= a\_s;

}

if c.rotate\_right {

u.camera\_angle\_horizontal += a\_s;

}

if c.rotate\_up {

u.camera\_angle\_vertical += a\_s;

}

if c.rotate\_down {

u.camera\_angle\_vertical -= a\_s;

}

if c.zoom\_in {

u.camera\_zoom -= z\_s;

}

if c.zoom\_out {

u.camera\_zoom += z\_s;

}

u.camera\_zoom = u.camera\_zoom.clamp(0.01, 10.0);

u.camera\_angle\_vertical %= 2.0 \* PI;

u.camera\_angle\_vertical = u.camera\_angle\_vertical.clamp(0.0, PI \*
0.3);

u.camera\_angle\_horizontal %= 2.0 \* PI;

}

queue.write\_buffer(

&self.state\_buffer,

0,

bytemuck::bytes\_of(&self.state\_uniform),

);

let mut encoder =
device.create\_command\_encoder(&CommandEncoderDescriptor {

label: Some(\"Ray Marching Command Encoder\"),

});

let mut rpass = encoder.begin\_render\_pass(&RenderPassDescriptor {

label: Some(\"Ray Marching Render Pass\"),

color\_attachments: &\[Some(RenderPassColorAttachment {

view,

resolve\_target: None,

ops: Operations {

load: wgpu::LoadOp::Clear(wgpu::Color {

r: 0.0,

g: 0.0,

b: 0.0,

a: 1.0,

}),

store: wgpu::StoreOp::Store,

},

})\],

depth\_stencil\_attachment: None,

timestamp\_writes: None,

occlusion\_query\_set: None,

});

rpass.set\_pipeline(&self.pipeline);

rpass.set\_vertex\_buffer(0, self.vertex\_buf.slice(..));

rpass.set\_bind\_group(0, &self.state\_bind\_group, &\[\]);

rpass.draw(0..6, 0..1);

drop(rpass);

queue.submit(std::iter::once(encoder.finish()));

}

fn update(&mut self, event: WindowEvent) {

match event {

WindowEvent::KeyboardInput {

device\_id: \_,

event,

is\_synthetic: \_,

} =\> {

let PhysicalKey::Code(code) = event.physical\_key else {

return;

};

let pressed = event.state.is\_pressed();

match code {

KeyCode::KeyW =\> self.camera\_controler.rotate\_up = pressed,

KeyCode::KeyS =\> self.camera\_controler.rotate\_down = pressed,

KeyCode::KeyA =\> self.camera\_controler.rotate\_left = pressed,

KeyCode::KeyD =\> self.camera\_controler.rotate\_right = pressed,

KeyCode::KeyQ =\> self.camera\_controler.zoom\_in = pressed,

KeyCode::KeyE =\> self.camera\_controler.zoom\_out = pressed,

\_ =\> {}

}

}

\_ =\> {}

}

}

fn resize(&mut self, config: &wgpu::SurfaceConfiguration, \_ctx:
&WgpuContext) {

self.state\_uniform.width = config.width as f32;

self.state\_uniform.height = config.height as f32;

}

}

\#\[repr(C)\]

\#\[derive(Clone, Copy, bytemuck::Pod, bytemuck::Zeroable)\]

pub struct Vertex {

pub pos: \[f32; 2\],

}

impl Vertex {

const ATTRIBUTES: &\'static \[VertexAttribute\] =
&wgpu::vertex\_attr\_array!\[0 =\> Float32x2\];

pub fn layout() -\> VertexBufferLayout\<\'static\> {

VertexBufferLayout {

array\_stride: std::mem::size\_of::\<Vertex\>() as wgpu::BufferAddress,

step\_mode: VertexStepMode::Vertex,

attributes: Self::ATTRIBUTES,

}

}

}

#strong[​<anchor-20><anchor-21><anchor-22><anchor-23>ПРИЛОЖЕНИЕ 3
(course-project/src/shader.wgsl)]

const EPSILON: f32 = 0.001;

const MAX\_DISTANCE: f32 = 100.0;

const MAX\_ITERATIONS: i32 = 300;

const SHADOW\_SHARPNESS: f32 = 30.0;

struct VertexInput {

\@location(0) pos: vec2\<f32\>,

}

struct VertexOutput {

\@builtin(position) pos: vec4\<f32\>,

}

struct StateUniform {

time: f32,

width: f32,

height: f32,

camera\_angle\_horizontal: f32,

camera\_angle\_vertical: f32,

camera\_zoom: f32,

}

\@group(0) \@binding(0)

var\<uniform\> state: StateUniform;

\@vertex

fn vs\_main(in: VertexInput) -\> VertexOutput {

var out: VertexOutput;

out.pos = vec4\<f32\>(in.pos, 0.0, 1.0);

return out;

}

\@fragment

fn fs\_main(in: VertexOutput) -\> \@location(0) vec4\<f32\> {

let ratio = state.width / state.height;

let uv = vec2\<f32\>(

ratio \* (in.pos.x / state.width - 0.5),

1.0 - in.pos.y / state.height - 0.5,

);

var ro = vec3\<f32\>(0.0, 0.0, -state.camera\_zoom);

var rd = normalize(vec3\<f32\>(uv, 1));

\/\/ Rotate vertical

let ry = mat\_rot\_2d(state.camera\_angle\_vertical);

let royz = ro.yz \* ry;

ro = vec3\<f32\>(ro.x, royz);

let rdyz = rd.yz \* ry;

rd = vec3\<f32\>(rd.x, rdyz);

\/\/ Rotate horizontal

let rx = mat\_rot\_2d(state.camera\_angle\_horizontal);

let roxz = ro.xz \* rx;

ro = vec3\<f32\>(roxz.x, ro.y, roxz.y);

let rdxz = rd.xz \* rx;

rd = vec3\<f32\>(rdxz.x, rd.y, rdxz.y);

var travelled = 0.0;

var color = vec3\<f32\>(0.7, 0.8, 1.0);

var i = 0;

var point: vec3\<f32\>;

for (; i \< MAX\_ITERATIONS; i += 1) {

point = ro + rd \* travelled;

let distance = scene(point, &color);

travelled += distance;

if distance \< EPSILON || travelled \> MAX\_DISTANCE {

break;

}

}

apply\_lights(point, rd, &color);

return vec4\<f32\>(color, 1.0);

}

fn scene(pos: vec3\<f32\>, color: ptr\<function, vec3\<f32\>\>) -\> f32
{

let s = sponge(pos, color);

let b = bottom(pos, color);

return min(s, b);

}

\/\/
\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*

\/\/ Objects

\/\/
\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*

fn bottom(pos: vec3\<f32\>, color: ptr\<function, vec3\<f32\>\>) -\> f32
{

let t = temple(pos, color);

var c2 = vec3\<f32\>(0.0);

let g = ground\_sdf(pos - vec3\<f32\>(0.0, -2.0, 0.0));

let d = smin(t, g, 0.1);

if d \< EPSILON && g \> EPSILON {

\*color = vec3\<f32\>(1.0, 1.0, 0.7);

} else if g \< EPSILON {

\*color = vec3\<f32\>(1.0, 1.0, 0.5);

}

return d;

}

fn temple(pos: vec3\<f32\>, color: ptr\<function, vec3\<f32\>\>) -\> f32
{

let q\_c = pos - vec3\<f32\>(0.0, -2.8, 0.0);

let c = capped\_cylinder\_sdf(q\_c, 2.0, 0.4) - 0.03;

let size = vec2\<i32\>(2, 2);

let rep = 4.7;

let rep\_v = repeat\_rectangular(pos.xz, size, rep);

let q\_p = vec3\<f32\>(rep\_v.x, pos.y, rep\_v.y);

let p = capped\_cylinder\_sdf(q\_p, 2.8, 0.3);

let q\_r = pos - vec3\<f32\>(0.0, 2.7, 0.0);

let r = box\_sdf(q\_r, vec3\<f32\>(2.9, 0.1, 2.9)) - 0.05;

let q\_b = pos - vec3\<f32\>(0.0, -2.0, 0.0);

let b = box\_sdf(q\_b, vec3\<f32\>(3.0, 0.15, 3.0)) - 0.05;

let s = 0.05;

let d = smin(p,

smin(c,

smin(b, r, s), s), s);

if d \< EPSILON {

\*color = vec3\<f32\>(1.0, 1.0, 0.7);

}

return d;

}

fn sponge(pos: vec3\<f32\>, color: ptr\<function, vec3\<f32\>\>) -\> f32
{

let q = rot\_3d(

pos - vec3\<f32\>(0.0, sin(state.time \* 2.0) \* 0.1, 0.0),

normalize(vec3\<f32\>(1.0, 1.0, 1.0)),

3.141592 \* fract(state.time \* 0.2) \* 2.0

);

let scale = 0.25;

let d = sponge\_sdf(q / scale) \* scale - 0.001;

if d \< EPSILON {

\*color = vec3\<f32\>(0.49, 0.604, 0.89);

}

return d;

}

\/\/
\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*

\/\/ Signed Distance Functions

\/\/
\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*

fn scene\_sdf(pos: vec3\<f32\>) -\> f32 {

var color = vec3\<f32\>(0.0);

return scene(pos, &color);

}

fn ground\_sdf(pos: vec3\<f32\>) -\> f32 {

return pos.y;

}

fn capped\_cylinder\_sdf(p: vec3\<f32\>, h: f32, r: f32) -\> f32 {

let d = abs(vec2(length(p.xz), p.y)) - vec2(r, h);

return min(max(d.x, d.y), 0.0) + length(max(d, vec2\<f32\>(0.0)));

}

fn sponge\_sdf(pos: vec3\<f32\>) -\> f32 {

let scale = 81.0;

var p = pos \* scale;

for (var s = scale; s \>= 1.0; s /= 3.0) {

p = trans(p, s);

}

return box\_sdf(p, vec3\<f32\>(0.5)) / scale;

}

fn box\_sdf(p: vec3\<f32\>, b: vec3\<f32\>) -\> f32 {

let q = abs(p) - b;

return length(max(q, vec3\<f32\>(0.0))) + min(max(q.x, max(q.y, q.z)),
0.0);

}

\/\/
\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*

\/\/ Light and shadows

\/\/
\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*

fn apply\_lights(point: vec3\<f32\>, ray\_direction: vec3\<f32\>, color:
ptr\<function, vec3\<f32\>\>) {

let sun = normalize(vec3\<f32\>(20.0, 10.0, -10.0));

let normal = scene\_normal(point);

let light\_diffuse = max(dot(normal, sun), 0.0);

let light\_ambient = 0.2;

let light\_bounce = max(dot(normal, -sun), 0.0);

let shadow = max(scene\_shadow(point, sun), 0.2);

let light = min((light\_diffuse + 0.1 \* light\_bounce) \* shadow +
light\_ambient, 1.0);

let light\_specular = max(dot((ray\_direction + normal) \* 0.5, sun),
0.0);

\*color = (\*color) \* light + 1.5 \* pow(light\_specular, 4.0);

}

fn scene\_normal(p: vec3\<f32\>) -\> vec3\<f32\> {

let e = vec2\<f32\>(1.0, -1.0) \* 0.5773 \* 0.0005;

return normalize(

e.xyy \* scene\_sdf(p + e.xyy) +

e.yyx \* scene\_sdf(p + e.yyx) +

e.yxy \* scene\_sdf(p + e.yxy) +

e.xxx \* scene\_sdf(p + e.xxx)

);

}

fn scene\_shadow(origin: vec3\<f32\>, direction: vec3\<f32\>) -\> f32 {

var travelled = 0.1;

var result = 1.0;

for (var i = 0; i \< MAX\_ITERATIONS; i++) {

let point = origin + travelled \* direction;

let d = scene\_sdf(point);

result = min(result, SHADOW\_SHARPNESS \* d / travelled);

travelled += d;

if travelled \> MAX\_DISTANCE {

return result;

} else if d \< EPSILON {

break;

}

}

return 0.0;

}

\/\/
\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*

\/\/ Utilities

\/\/
\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*

fn trans(pos: vec3\<f32\>, s: f32) -\> vec3\<f32\> {

\/\/Mirror

var p = abs(pos) - 1.0 \* s;

p \*= -1.0;

\/\/Reflect column

if p.x - p.y \> 0.0 {

p = vec3\<f32\>(p.y, p.x, p.z);

}

if p.z - p.y \> 0.0 {

p = vec3\<f32\>(p.x, p.z, p.y);

}

\/\/construct column

p.y = abs(p.y - 0.5 \* s) - 0.5 \* s;

return p;

}

fn mat\_rot\_2d(angle: f32) -\> mat2x2\<f32\> {

return mat2x2\<f32\>(cos(angle), -sin(angle), sin(angle), cos(angle));

}

fn rot\_3d(p: vec3\<f32\>, axis: vec3\<f32\>, angle: f32) -\>
vec3\<f32\> {

let m = mix(dot(axis, p) \* axis, p, cos(angle));

let c = cross(axis, p) \* sin(angle);

return m + c;

}

fn smin(d1: f32, d2: f32, k: f32) -\> f32 {

let h = clamp(0.5 + 0.5 \* (d2 - d1) / k, 0.0, 1.0);

return mix(d2, d1, h) - k \* h \* (1.0 - h);

}

fn repeat\_rectangular(pos: vec2\<f32\>, size: vec2\<i32\>, spacing:
f32) -\> vec2f {

var p = abs(pos / spacing) - (vec2\<f32\>(size) \* 0.5 - 0.5);

if p.x \< p.y {

p = p.yx;

}

p.y -= min(0.0, round(p.y));

return p\*spacing;

}

#strong[]

#strong[​<anchor-24><anchor-25><anchor-26><anchor-27>ПРИЛОЖЕНИЕ 4
(Компоненты App и CourseProject)]

\#\[component\]

fn App\<A: Application + \'static\>(\#\[prop(optional)\] marker:
PhantomData\<A\>) -\> impl IntoView {

let \_ = marker;

let handle =
Arc::new(Mutex::new(framework::ApplicationHandle::default()));

let handle\_cloned = handle.clone();

let canvas = NodeRef::\<html::Canvas\>::new();

canvas.on\_load(|\_| {

framework::run::\<A\>(Some(handle\_cloned));

});

on\_cleanup(move || {

handle.lock().unwrap().exit();

});

view!(

\<h1\>{A::DESCRIPTION}\</h1\>

\<canvas node\_ref=canvas id=\"canvas\" class=style::window /\>

)

}

\#\[component\]

pub fn CourseProject() -\> impl IntoView {

view!(\<App marker={PhantomData::\<course\_project::Application\>} /\>)

}

#strong[​<anchor-28><anchor-29><anchor-30><anchor-31>ПРИЛОЖЕНИЕ 5
(web/Trunk.toml)]

\[build\]

target = \"index.html\"

dist = \"dist\"

\[watch\]

watch = \[\"../\"\]

ignore = \[\"../target\", \"./public/bundle.scss\"\]

\[\[hooks\]\]

stage = \"pre\_build\"

command = \"stylance\"

command\_arguments = \[\".\"\]

#strong[​<anchor-32><anchor-33><anchor-34><anchor-35>ПРИЛОЖЕНИЕ 6
(web/Dockerfile)]

FROM nginx:alpine

COPY nginx.conf /etc/nginx/conf.d/default.conf

COPY dist /usr/share/nginx/html

#strong[​<anchor-36><anchor-37><anchor-38><anchor-39>ПРИЛОЖЕНИЕ 7
(демонстрация работы нативного приложения для ОС на базе ядра Linux)]

#strong[#strong[]]

= #box(image("course-project/assets/Pictures/1000000100000A82000005F62D970DE6.png", height: 3.6846in, width: 6.4965in))
<section-1>
#strong[​<anchor-40><anchor-41><anchor-42><anchor-43>ПРИЛОЖЕНИЕ 8
(демонстрация работы нативного приложения для MacOS)]

#strong[#box(image("course-project/assets/Pictures/1000000100000E1C00000918FD9B78AD.png", height: 4.1866in, width: 6.4965in))#strong[]]

#strong[​<anchor-44><anchor-45><anchor-46><anchor-47>ПРИЛОЖЕНИЕ 9
(демонстрация работы веб-приложения)]

#strong[#box(image("course-project/assets/Pictures/1000000100000E1C0000091852C186C5.png", height: 4.1866in, width: 6.4965in))#strong[]]
