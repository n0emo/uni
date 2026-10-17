ФЕДЕРАЛЬНОЕ АГЕНСТВО ЖЕЛЕЗНОДОРОЖНОГО ТРАНСПОРТА

Федеральное государственное бюджетное образовательное учреждение высшего
образования

«ПЕТЕРБУРГСКИЙ ГОСУДАРСТВЕННЫЙ УНИВЕРСИТЕТ ПУТЕЙ СООБЩЕНИЯ Императора
Александра I»

Кафедра «Информационные и вычислительные системы»

Дисциплина «Программирование на языке JAVA»

#strong[ОТЧЁТ]

#strong[ПО ПРАКТИЧЕСКОЙ РАБОТЕ № 1]

#strong[«Разработка структуры классов на основе модели данных»]

#figure(
  align(center)[#table(
    columns: 2,
    align: (auto,auto,),
    [Выполнил студент

    Факультет: АИТ

    Группа: ИВБ-211

    ], [Шефнер А.],
    [Проверила:

    Профессор кафедры

    «Информационные и вычислительные

    системы

    ], [Божко Л.М.],
  )]
  , kind: table
  )

#strong[Санкт-Петербург]

#strong[2024]

Оценочный лист результатов ПР № 1

Ф.И.О. студента: #emph[Шефнер А.]

Группа \_\_\_\_\_\_\_\_\_\_\_\_\_#emph[ИВБ-211]\_\_\_\_\_\_\_\_\_\_\_\_

Профессор кафедры

«Информационные и вычислительные

системы»#strong[ «\_\_» \_\_\_\_\_\_\_\_\_\_2024 г. Божко Л.М. ]

#strong[Цель]

Получить теоретические и практические навыки разработки модели для базы
данных веб-приложения

#strong[Задание ]

+ Разработать иерархию классов на примере какой-либо предметной области.
  Как минимум один из классов должен быть наследован от другого.
+ Подготовить ER-диаграмму данных классов.

#strong[Ход работы]

Хотя в Clojure возможно использование классов и JPA, часто это бывает
попросту непрактично, если разрабатывается новое ПО на этом языке и в
проекте нет большого количества кода на языке Java. Поэтому в данной
работе используется более естественное для такое среды решение -- SQL. С
помощью ragtime возможно выполнение миграций, а hugsql позволяет
выполнять \ SQL-запросы из Clojure и получать их результаты в виде
словарей или векторов словарей. В данной практической работе будет
представлен код миграций, создающий все таблицы базы данных. Модель
представляет из себя схему баз данных некоторой образовательной
организации, в которой хранится информация о факультетах, программах
обучения, дисциплинах, группах, студентах и их оценки. Оценки могут быть
разных видов, что в некотором роде можно сопоставить с наследованием. В
следующем единственном листинге показано содержание всех файлов миграций
разработанной модели:

\-\- resources/migrations/001-faculties.up.sql

create table faculties(

id serial primary key not null,

name text not null,

unique (name)

);

\-\- resources/migrations/001-faculties.down.sql

drop table faculties;

\-\- resources/migrations/002-disciplines.up.sql

create table disciplines(

id serial primary key not null,

name text not null,

faculty\_id integer not null,

unique(name),

foreign key (faculty\_id) references faculties(id)

);

\-\- resources/migrations/002-disciplines.down.sql

drop table disciplines;

\-\- resources/migrations/003-programs.up.sql

create table program\_kinds(

id integer primary key not null,

name text not null

);

insert into program\_kinds(id, name) values

\(1, \'bachelor\'),

\(2, \'specialist\'),

\(3, \'master\');

create table programs(

id serial primary key not null,

name text not null,

faculty\_id integer not null,

kind\_id integer not null,

unique (name),

foreign key (faculty\_id) references faculties(id),

foreign key (kind\_id) references program\_kinds(id)

);

\-\- resources/migrations/003-programs.down.sql

drop table programs;

drop table program\_kinds;

\-\- resources/migrations/004-groups.up.sql

create table groups(

id serial primary key not null,

name text not null,

year\_formed integer not null,

program\_id integer not null,

unique (name),

foreign key (program\_id) references programs(id)

);

\-\- resources/migrations/004-groups.down.sql

drop table groups;

\-\- resources/migrations/005-students.up.sql

create table student\_cards(

id serial primary key not null,

group\_id integer not null,

foreign key (group\_id) references groups(id)

);

create table students(

id serial primary key not null,

name text not null,

surname text not null,

fathersname text,

year\_of\_birth integer not null,

card\_id integer not null,

foreign key (card\_id) references student\_cards(id)

);

\-\- resources/migrations/005-students.down.sql

drop table students;

drop table student\_cards;

\-\- resources/migrations/006-student-marks.up.sql

create table mark\_kinds(

name text primary key not null,

title text not null,

unique(title)

);

insert into mark\_kinds(name, title) values

\(\'credit\', \'Зачёт\'),

\(\'exam\', \'Экзамен\'),

\(\'practice\', \'Практика\');

create table marks(

id serial primary key not null,

kind text not null,

card\_id integer not null,

study\_term integer not null,

foreign key (kind) references mark\_kinds(name),

foreign key (card\_id) references student\_cards(id)

);

create table credit\_marks(

id serial primary key not null,

mark\_id integer not null,

discipline\_id integer not null,

foreign key (mark\_id) references marks(id),

foreign key (discipline\_id) references disciplines(id)

);

create table exam\_marks(

id serial primary key not null,

mark\_id integer not null,

discipline\_id integer not null,

\"value\" integer not null,

foreign key (mark\_id) references marks(id),

foreign key (discipline\_id) references disciplines(id)

);

create table practice\_marks(

id serial primary key not null,

mark\_id integer not null,

description text not null,

foreign key (mark\_id) references marks(id)

);

\-\- resources/migrations/006-student-marks.down.sql

drop table practice\_marks;

drop table exam\_marks;

drop table credit\_marks;

drop table marks;

drop table mark\_kinds;

#strong[]

#strong[ER-диаграмма]

#box(image("./assets/10000001000002CA0000050168CE3B6E.png", height: 10.2839in, width: 5.7319in))#strong[]

#strong[Вывод]

В ходе работы были приобретены теоретические и практические навыки
разработки модели базы данных. Была разработана модель некоторой
образовательной организации и построена ER диаграмма схемы базы данных.
