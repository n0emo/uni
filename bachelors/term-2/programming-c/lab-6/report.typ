МИНИСТЕРСТВО ТРАНСПОРТА РОССИЙСКОЙ ФЕДЕРАЦИИ

ФЕДЕРАЛЬНОЕ АГЕНТСТВО ЖЕЛЕЗНОДОРОЖНОГО ТРАНСПОРТА

Государственное бюджетное образовательное учреждение

высшего образования

«ПЕТЕРБУРГСКИЙ ГОСУДАРСТВЕННЫЙ УНИВЕРСИТЕТ

ПУТЕЙ СООБЩЕНИЯ ИМПЕРАТОРА АЛЕКСАНДРА I»

Кафедра «ИНФОРМАЦИОННЫЕ И ВЫЧИСЛИТЕЛЬНЫЕ СИСТЕМЫ»

Дисциплина: «Программирование(C)»

ОТЧЕТ

по лабораторной работе № 6

Вариант #emph[19]

Выполнил студент Шефнер А.

Факультета #emph[АИТ]

Группы #emph[ИВБ-211]

Санкт-Петербург

2023

#emph[#strong[ \ ]]

#strong[Постановка задачи]

1) Создать односвязный список. Данными списка должны быть структуры из
задания № 4 соответствующего варианта. Создать функции для записи списка
в файл и чтения списка из файла.

2) Реализовать минимум все функции, приведённые в лекции, предложить
предложить свои варианты функций работы со списком.

3) Создать меню для управления работы со списком.

#strong[ \ ]

#strong[Пояснения]

Мой список является отдельной структурой list, в которой находится
количество элементов, ссылка на голову и ссылка на хвост листа. Данные
хранятся в узлаъ node в виде указателей на void. Это позволяет Вам
использовать данный список не только со структурой book, но и вообще с
любыми другими структурами, если Вы работаете с ними через указатели.
Для очистки списка сначала примените процедуру free для каждого элемента
(это может сделать моя функция list\_apply), а зачем вызовате
list\_delete.

#strong[ \ ]

#strong[Код программы]

#strong[c\_lab\_6.c] (точка входа программы и меню взаимодействия со
списком)

#strong[\#define \_CRT\_SECURE\_NO\_WARNINGS]

#strong[~]

#strong[\#include \<stdio.h\>]

#strong[\#include \<stdlib.h\>]

#strong[~]

#strong[\#include \"book.h\"]

#strong[\#include \"list.h\"]

#strong[\#include \"booksfile.h\"]

#strong[~]

#strong[\#define ACTION\_COUNT 14]

#strong[~]

#strong[list\* book\_list;]

#strong[~]

#strong[void(\*actions\[ACTION\_COUNT\])(void);]

#strong[~]

#strong[char\* action\_names\[ACTION\_COUNT\];]

#strong[~]

#strong[void action\_get\_head(void);]

#strong[void action\_list\_get\_tail(void);]

#strong[void action\_list\_get(void);]

#strong[void action\_get\_from\_end(void);]

#strong[void action\_show\_list(void);]

#strong[void action\_push\_back(void);]

#strong[void action\_push\_front(void);]

#strong[void action\_insert(void);]

#strong[void action\_pop\_back(void);]

#strong[void action\_pop\_front(void);]

#strong[void action\_remove\_at(void);]

#strong[void action\_remove\_from\_end(void);]

#strong[void action\_load\_from\_file(void);]

#strong[void action\_write\_to\_file(void);]

#strong[~]

#strong[~]

#emph[#strong[\/\/ void\*\* list\_to\_array(const list\* list);]]

#strong[~]

#strong[~]

#strong[void init\_actions(void);]

#strong[void print\_actions(void);]

#strong[~]

#strong[int main(int argc, char\* argv\[\])]

#strong[{]

#strong[system(\"cls\");]

#strong[init\_actions();]

#strong[book\_list = list\_create();]

#strong[~]

#strong[printf(\"Welcome to the book management tool!\\n\");]

#strong[~]

#strong[while (1)]

#strong[{]

#strong[system(\"pause\");]

#strong[system(\"cls\");]

#strong[print\_actions();]

#strong[int action\_num;]

#strong[printf(\"Enter action number: \");]

#strong[scanf(\"%d\", &action\_num);]

#strong[if(action\_num == 0) break;]

#strong[if(action\_num \< 1 || action\_num \> ACTION\_COUNT)]

#strong[{]

#strong[printf(\"Invalid action number.\\n\");]

#strong[continue;]

#strong[}]

#strong[system(\"cls\");]

#strong[fseek(stdin,0,SEEK\_END);]

#strong[actions\[action\_num - 1\]();]

#strong[}]

#strong[list\_apply(book\_list, free);]

#strong[list\_delete(book\_list);]

#strong[system(\"pause\");]

#strong[return 0;]

#strong[}]

#strong[~]

#strong[void action\_get\_head(void)]

#strong[{]

#strong[printf(\"Head of the list:\\n\\n\");]

#strong[book\_print(list\_get\_head(book\_list));]

#strong[}]

#strong[~]

#strong[void action\_list\_get\_tail(void)]

#strong[{]

#strong[printf(\"Tail of the list:\\n\\n\");]

#strong[book\_print(list\_get\_tail(book\_list));]

#strong[}]

#strong[~]

#strong[void action\_list\_get(void)]

#strong[{]

#strong[size\_t index;]

#strong[printf(\"Enter desired index: \");]

#strong[scanf(\"%lld\", &index);]

#strong[~]

#strong[book\* book = list\_get(book\_list, index);]

#strong[~]

#strong[if(book == NULL)]

#strong[{]

#strong[printf(\"Invalid index.\\n\");]

#strong[return;]

#strong[}]

#strong[~]

#strong[printf(\"Book at index %lld in the list:\\n\\n\", index);]

#strong[book\_print(book);]

#strong[}]

#strong[~]

#strong[void action\_get\_from\_end(void)]

#strong[{]

#strong[size\_t index;]

#strong[printf(\"Enter desired index: \");]

#strong[scanf(\"%lld\", &index);]

#strong[~]

#strong[book\* book = list\_get\_from\_end(book\_list, index);]

#strong[~]

#strong[if(book == NULL)]

#strong[{]

#strong[printf(\"Invalid index.\\n\");]

#strong[return;]

#strong[}]

#strong[~]

#strong[printf(\"Book at index %lld in the list:\\n\\n\", index);]

#strong[book\_print(book);]

#strong[}]

#strong[~]

#strong[void action\_show\_list(void)]

#strong[{]

#strong[if(book\_list-\>count == 0)]

#strong[{]

#strong[printf(\"The list is empty.\\n\");]

#strong[return;]

#strong[}]

#strong[printf(\"List of the books:\\n\\n\");]

#strong[list\_apply(book\_list, book\_print);]

#strong[printf(\"\\n\\n\");]

#strong[}]

#strong[~]

#strong[void action\_push\_back(void)]

#strong[{]

#strong[printf(\" Enter book:\\n\");]

#strong[book\* new\_book = book\_get\_scanf();]

#strong[list\_push\_back(book\_list, new\_book);]

#strong[printf(\"\\nBook added to list successfully.\\n\\n\");]

#strong[}]

#strong[~]

#strong[void action\_push\_front(void)]

#strong[{]

#strong[printf(\" Enter book:\\n\");]

#strong[book\* new\_book = book\_get\_scanf();]

#strong[list\_push\_front(book\_list, new\_book);]

#strong[printf(\"\\nBook added to list successfully.\\n\\n\");]

#strong[}]

#strong[~]

#strong[void action\_insert(void)]

#strong[{]

#strong[size\_t index;]

#strong[printf(\"Enter index (0 - %lld): \", book\_list-\>count);]

#strong[scanf(\"%lld\", &index);]

#strong[if(index \< 0 || index \>= book\_list-\>count)]

#strong[{]

#strong[printf(\"Invalid index.\\n\");]

#strong[}]

#strong[printf(\" Enter book:\\n\");]

#strong[book\* new\_book = book\_get\_scanf();]

#strong[list\_insert(book\_list, new\_book, index);]

#strong[printf(\"\\nBook added to list successfully.\\n\\n\");]

#strong[}]

#strong[~]

#strong[void action\_pop\_back(void)]

#strong[{]

#strong[book\* removed\_book = list\_pop\_back(book\_list);]

#strong[if(removed\_book == NULL)]

#strong[{]

#strong[printf(\"The list is empty.\\n\");]

#strong[return;]

#strong[}]

#strong[printf(\"The book, popped out from back:\\n\\n\");]

#strong[book\_print(removed\_book);]

#strong[free(removed\_book);]

#strong[}]

#strong[~]

#strong[void action\_pop\_front(void)]

#strong[{]

#strong[book\* removed\_book = list\_pop\_front(book\_list);]

#strong[if(removed\_book == NULL)]

#strong[{]

#strong[printf(\"The list is empty.\\n\");]

#strong[return;]

#strong[}]

#strong[printf(\"The book, popped out from front:\\n\\n\");]

#strong[book\_print(removed\_book);]

#strong[free(removed\_book);]

#strong[}]

#strong[~]

#strong[void action\_remove\_at(void)]

#strong[{]

#strong[size\_t index;]

#strong[printf(\"Enter index (0 - %lld): \", book\_list-\>count);]

#strong[scanf(\"%lld\", &index);]

#strong[if(index \< 0 || index \>= book\_list-\>count)]

#strong[{]

#strong[printf(\"Invalid index.\\n\");]

#strong[}]

#strong[book\* removed\_book = list\_get(book\_list, index);]

#strong[list\_remove\_at(book\_list, index);]

#strong[printf(\"\\nThe book, removed from the list:\\n\\n\");]

#strong[book\_print(removed\_book);]

#strong[free(removed\_book);]

#strong[}]

#strong[~]

#strong[void action\_remove\_from\_end(void)]

#strong[{]

#strong[size\_t index;]

#strong[printf(\"Enter index (0 - %lld): \", book\_list-\>count);]

#strong[scanf(\"%lld\", &index);]

#strong[if(index \< 0 || index \>= book\_list-\>count)]

#strong[{]

#strong[printf(\"Invalid index.\\n\");]

#strong[}]

#strong[book\* removed\_book = list\_get(book\_list, index);]

#strong[list\_remove\_at\_from\_end(book\_list, index);]

#strong[printf(\"\\nThe book, removed from the list:\\n\\n\");]

#strong[book\_print(removed\_book);]

#strong[free(removed\_book);]

#strong[}]

#strong[~]

#strong[void action\_load\_from\_file(void)]

#strong[{]

#strong[char filename\[100\];]

#strong[printf(\"Enter file name: \");]

#strong[scanf(\"%s\", filename);]

#strong[~]

#strong[list\* tmp\_list = get\_book\_list\_from\_file(filename);]

#strong[if(tmp\_list == NULL)]

#strong[{]

#strong[printf(\"Invalid file name.\\n\");]

#strong[return;]

#strong[}]

#strong[~]

#strong[list\_apply(book\_list, free);]

#strong[free(book\_list);]

#strong[book\_list = tmp\_list;]

#strong[~]

#strong[printf(\"Books loaded successfully\\n\");]

#strong[}]

#strong[~]

#strong[void action\_write\_to\_file(void)]

#strong[{]

#strong[char filename\[100\];]

#strong[printf(\"Enter file name: \");]

#strong[scanf(\"%s\", filename);]

#strong[~]

#strong[if(write\_book\_list\_to\_file(filename, book\_list))]

#strong[{]

#strong[printf(\"Data successfully written to the file.\\n\");]

#strong[}]

#strong[else]

#strong[{]

#strong[printf(\"Error during writing the list to file.\\n\");]

#strong[}]

#strong[}]

#strong[~]

#strong[void init\_actions(void)]

#strong[{]

#strong[actions\[0\] = action\_get\_head;]

#strong[action\_names\[0\] = \"Get head of the list.\";]

#strong[actions\[1\] = action\_list\_get\_tail;]

#strong[action\_names\[1\] = \"Get tail of the list.\";]

#strong[actions\[2\] = action\_list\_get;]

#strong[action\_names\[2\] = \"Get an element of the list at desired
index.\";]

#strong[actions\[3\] = action\_get\_from\_end;]

#strong[action\_names\[3\] = \"Get an element of the list at desired
index starting from the end.\";]

#strong[actions\[4\] = action\_show\_list;]

#strong[action\_names\[4\] = \"Print all elements of the list.\";]

#strong[actions\[5\] = action\_push\_back;]

#strong[action\_names\[5\] = \"Push back anew element to the list.\";]

#strong[actions\[6\] = action\_push\_front;]

#strong[action\_names\[6\] = \"Push front anew element to the list.\";]

#strong[actions\[7\] = action\_insert;]

#strong[action\_names\[7\] = \"Insert a new elenebt in the list at the
desired index.\";]

#strong[actions\[8\] = action\_pop\_back;]

#strong[action\_names\[8\] = \"Pop back an element from the list and
show it.\";]

#strong[actions\[9\] = action\_pop\_front;]

#strong[action\_names\[9\] = \"Pop front an element from the list and
show it.\";]

#strong[actions\[10\] = action\_remove\_at;]

#strong[action\_names\[10\] = \"Remove an element from the list at the
desired index.\";]

#strong[actions\[11\] = action\_remove\_from\_end;]

#strong[action\_names\[11\] = \"Remove an element from the list at the
desired index starting from the end.\";]

#strong[~]

#strong[actions\[12\] = action\_load\_from\_file;]

#strong[action\_names\[12\] = \"Load books from the file.\";]

#strong[~]

#strong[actions\[13\] = action\_write\_to\_file;]

#strong[action\_names\[13\] = \"Write books to the file.\";]

#strong[}]

#strong[~]

#strong[void print\_actions(void)]

#strong[{]

#strong[for(int i = 0; i \< ACTION\_COUNT; i++)]

#strong[{]

#strong[printf(\"%d - %s\\n\", i + 1, action\_names\[i\]);]

#strong[}]

#strong[printf(\"\\n%d - Exit.\\n\\n\", 0);]

#strong[}]

#strong[book.h] (струтура книги и основные функции)

#strong[\#pragma once]

#strong[~]

#strong[\#define SURNAME\_CHAR\_NUMBER 20]

#strong[\#define THEME\_CHAR\_NUMBER 50]

#strong[\#define FULL\_CHAR\_NUMBER 83]

#strong[~]

#strong[\#define SURNAME\_FORMAT \"%20s\"]

#strong[\#define THEME\_FORMAT \"%50s\"]

#strong[\#define YEAR\_FORMAT \"%5hu\"]

#strong[\#define PAGE\_FORMAT \"%5hu\"]

#strong[~]

#strong[\#define BOOK\_FORMAT SURNAME\_FORMAT\" \"THEME\_FORMAT\"
\"YEAR\_FORMAT\" \"PAGE\_FORMAT]

#strong[~]

#strong[typedef struct book]

#strong[{]

#strong[char surname\[SURNAME\_CHAR\_NUMBER + 1\];]

#strong[char theme\[THEME\_CHAR\_NUMBER + 1\];]

#strong[unsigned short year;]

#strong[unsigned short page\_count;]

#strong[} book;]

#strong[~]

#strong[void book\_print(book\* book);]

#strong[~]

#strong[book\* book\_get\_scanf(void);]

#strong[book.с]

#strong[\#define \_CRT\_SECURE\_NO\_WARNINGS]

#strong[~]

#strong[\#include \"book.h\"]

#strong[~]

#strong[\#include \<stdio.h\>]

#strong[\#include \<stdlib.h\>]

#strong[\#include \<string.h\>]

#strong[~]

#strong[void write\_str\_without\_trailing\_spaces(char\* str\_ptr)]

#strong[{]

#strong[while (\*str\_ptr == \' \') str\_ptr++;]

#strong[while (\*str\_ptr != \'\\0\')]

#strong[{]

#strong[char tmp = \*str\_ptr == \'\_\' ? \' \' : (char)(\*str\_ptr);]

#strong[putc(tmp, stdout);]

#strong[str\_ptr++;]

#strong[}]

#strong[}]

#strong[~]

#strong[void book\_print(book\* book)]

#strong[{]

#strong[write\_str\_without\_trailing\_spaces(book-\>surname);]

#strong[printf(\" - \");]

#strong[write\_str\_without\_trailing\_spaces(book-\>theme);]

#strong[printf(\"\\nyear: %d. %d pages.\\n\\n\", book-\>year,
book-\>page\_count);]

#strong[}]

#strong[~]

#strong[book\* book\_get\_scanf(void)]

#strong[{]

#strong[fseek(stdin,0,SEEK\_END);]

#strong[book\* book = malloc(sizeof(struct book));]

#strong[printf(\"\\nEnter surname:\\n\");]

#strong[fgets(book-\>surname, SURNAME\_CHAR\_NUMBER, stdin);]

#strong[book-\>surname\[strcspn(book-\>surname, \"\\r\\n\")\] =
\'\\0\';]

#strong[printf(\"Enter theme:\\n\");]

#strong[fgets(book-\>theme, THEME\_CHAR\_NUMBER, stdin);]

#strong[book-\>theme\[strcspn(book-\>theme, \"\\r\\n\")\] = \'\\0\';]

#strong[printf(\"Enter year: \");]

#strong[scanf(\"%hd\", &book-\>year);]

#strong[printf(\"Enter page count: \");]

#strong[scanf(\"%hd\", &book-\>page\_count);]

#strong[return book;]

#strong[}]

#strong[list.h] (связный список)

#strong[\#pragma once]

~

#strong[typedef] #strong[unsigned] #strong[long] #strong[long]
#strong[size\_t]\;

~

#strong[typedef] #strong[struct] #strong[node]

{

#strong[void]\* data;

#strong[struct] #strong[node]\* next;

} node;

~

#strong[typedef] #strong[struct] #strong[list]

{

node\* head;

node\* tail;

#strong[size\_t] count;

} list;

~

#emph[\/\/ Creates a new list.]

list\* #strong[list\_create]\(#strong[void]);

~

#emph[\/\/ Returns a data of the lists head.]

#strong[void]\* #strong[list\_get\_head]\(#strong[const] list\* list);

~

#emph[\/\/ Returns a data of the lists tail.]

#strong[void]\* #strong[list\_get\_tail]\(#strong[const] list\* list);

~

#emph[\/\/ Returns a data from the list at index.]

#strong[void]\* #strong[list\_get]\(#strong[const] list\* list,
#strong[size\_t] index);

~

#emph[\/\/ Returns a data from the list at index starting from end of
list.]

#strong[void]\* #strong[list\_get\_from\_end]\(#strong[const] list\*
list, #strong[size\_t] index);

~

#emph[\/\/ Converts a list to an array and returns a pointer to the
array.]

#emph[\/\/ Warning: a memory for an array is allocated with malloc.]

#emph[\/\/ Don\'t forget to free the array after use.]

#strong[void]\*\* #strong[list\_to\_array]\(#strong[const] list\* list);

~

#emph[\/\/ Adds a new element at the end of the list.]

#strong[int] #strong[list\_push\_back]\(list\* list, #strong[void]\*
data);

~

#emph[\/\/ Adds a new element at rhe start of the list]

#strong[int] #strong[list\_push\_front]\(list\* list, #strong[void]\*
data);

~

#emph[\/\/ Inserts a new element at a desired index.]

#strong[int] #strong[list\_insert]\(list\* list, #strong[void]\* data,
#strong[size\_t] index);

~

#emph[\/\/ Removes an element from the end of the list and returns ins
data]

#strong[void]\* #strong[list\_pop\_back]\(list\* list);

~

#emph[\/\/ Removes an element from the start of the list and returns ins
data]

#strong[void]\* #strong[list\_pop\_front]\(list\* list);

~

#emph[\/\/ Removes an element from the list at index.]

#strong[int] #strong[list\_remove\_at]\(list\* list, #strong[size\_t]
index);

~

#emph[\/\/ Removes an element from the list at indext starting from the
end.]

#strong[int] #strong[list\_remove\_at\_from\_end]\(list\* list,
#strong[size\_t] index);

~

#emph[\/\/ Applies a void function to every element of the list.]

#strong[void] #strong[list\_apply]\(#strong[const] list\* list,
#strong[void]\(\*func)(#strong[void]\*));

~

#emph[\/\/ Applies a void function to every element of the list and]

#emph[\/\/ saves the result to a new list.]

#emph[\/\/ Warning: the new list will be allocated with malloc.]

list\* #strong[list\_apply\_and\_save]\(#strong[const] list\* list,
#strong[void]\*(\*func)(#strong[void]\*));

~

#emph[\/\/ Deletes all the nodes of the list.]

#emph[\/\/ Warning: data inside the nodes will not be deleted.]

#strong[int] #strong[list\_delete]\(list\* list);

#strong[list.с]

#strong[\#include \"list.h\"]

~

#strong[\#include \<stdlib.h\>]

~

list\* #strong[list\_create]\(#strong[void])

{

list\* list = malloc(sizeof(#strong[struct] list));

list-\>count = 0;

list-\>head = NULL;

list-\>tail = NULL;

#strong[return] list;

}

~

#strong[void]\* #strong[list\_get\_head]\(#strong[const] list\* list)

{

#strong[return] list-\>head == NULL ? NULL : list-\>head-\>data;

}

~

#strong[void]\* #strong[list\_get\_tail]\(#strong[const] list\* list)

{

#strong[return] list-\>tail == NULL ? NULL : list-\>tail-\>data;

}

~

#strong[void]\* #strong[list\_get]\(#strong[const] list\* list,
#strong[const] #strong[size\_t] index)

{

#strong[if]\(index \>= list-\>count || index \< 0) #strong[return] NULL;

~

#strong[const] node\* tmp = list-\>head;

#strong[for]\(#strong[size\_t] i = 0; i \< index; i++)

{

tmp = tmp-\>next;

#strong[if]\(tmp == NULL) #strong[return] NULL;

}

~

#strong[return] tmp-\>data;

}

~

#strong[void]\* #strong[list\_get\_from\_end]\(#strong[const] list\*
list, #strong[const] #strong[size\_t] index)

{

#strong[return] list\_get(list, list-\>count - index);

}

~

#strong[void]\*\* #strong[list\_to\_array]\(#strong[const] list\* list)

{

#strong[if]\(list-\>count == 0) #strong[return] NULL;

#strong[void]\*\* array = malloc(sizeof(#strong[void]\*) \*
list-\>count);

~

#strong[const] node\* tmp = list-\>head;

#strong[for]\(#strong[size\_t] i = 0; i \< list-\>count; i++)

{

array\[i\] = tmp-\>data;

tmp = tmp-\>next;

}

~

#strong[return] array;

}

~

#strong[int] #strong[list\_push\_back]\(list\* list, #strong[void]\*
data)

{

node\* node\_ptr = malloc(sizeof(node));

node\_ptr-\>data = data;

#strong[if]\(list-\>count == 0)

list-\>head = node\_ptr;

#strong[else]

list-\>tail-\>next = node\_ptr;

list-\>tail = node\_ptr;

~

list-\>count++;

#strong[return] 1;

}

~

#strong[int] #strong[list\_push\_front]\(list\* list, #strong[void]\*
data)

{

#strong[if]\(list-\>count == 0)

{

#strong[return] list\_push\_back(list, data);

}

node\* new\_node = malloc(sizeof(node));

new\_node-\>data = data;

new\_node-\>next = list-\>head;

list-\>head = new\_node;

#strong[if]\(list-\>count == 1)

{

list-\>tail = list-\>head-\>next;

}

list-\>count++;

#strong[return] 1;

}

~

#strong[int] #strong[list\_insert]\(list\* list, #strong[void]\* data,
#strong[const] #strong[size\_t] index)

{

#strong[if]\(index \> list-\>count || index \< 0) #strong[return] 0;

#strong[if]\(index == list-\>count) #strong[return]
list\_push\_back(list, data);

#strong[if]\(index == 0) #strong[return] list\_push\_front(list, data);

~

node\* tmp = list-\>head;

node\* new\_node = malloc(sizeof(node));

new\_node-\>data = data;

#strong[for]\(#strong[size\_t] i = 0; i \< index - 1; i++)

{

tmp = tmp-\>next;

}

new\_node-\>next = tmp-\>next;

tmp-\>next = new\_node;

list-\>count++;

#strong[return] 1;

}

~

#strong[void]\* #strong[list\_pop\_back]\(list\* list)

{

#strong[if]\(list-\>count == 0) #strong[return] NULL;

#strong[void]\* return\_data = list-\>tail-\>data;

~

#strong[if]\(list-\>count == 1)

{

free(list-\>tail);

list-\>tail = NULL;

list-\>head = NULL;

list-\>count-\-;

#strong[return] return\_data;

}

~

node\* tmp = list-\>head;

#strong[for]\(#strong[size\_t] i = 0; i \< list-\>count - 2; i++)

{

tmp = tmp-\>next;

}

~

free(list-\>tail);

list-\>tail = tmp;

list-\>count-\-;

#strong[return] return\_data;

}

~

#strong[void]\* #strong[list\_pop\_front]\(list\* list)

{

#strong[if]\(list-\>count == 0) #strong[return] NULL;

#strong[if]\(list-\>count == 1) #strong[return] list\_pop\_back(list);

~

#strong[void]\* data = list-\>head-\>data;

node\* tmp = list-\>head;

list-\>head = list-\>head-\>next;

free(tmp);

list-\>count-\-;

#strong[return] data;

}

~

#strong[int] #strong[list\_remove\_at]\(list\* list, #strong[const]
#strong[size\_t] index)

{

#strong[if]\(list-\>count == 0 || index \< 0) #strong[return] 0;

#strong[if]\(index == 0)

{

list\_pop\_front(list);

#strong[return] 1;

}

#strong[if]\(index == list-\>count - 1)

{

list\_pop\_back(list);

#strong[return] 1;

}

~

#strong[if]\(list-\>count == 1)

{

free(list-\>head);

list-\>head = NULL;

list-\>tail = NULL;

#strong[return] 1;

}

~

node\* tmp = list-\>head;

#strong[for]\(#strong[size\_t] i = 0; i \< index - 1; i++)

{

tmp = tmp-\>next;

}

~

node\* removed = tmp-\>next;

tmp-\>next = removed-\>next;

free(removed);

list-\>count-\-;

#strong[return] 1;

}

~

#strong[int] #strong[list\_remove\_at\_from\_end]\(list\* list,
#strong[size\_t] index)

{

#strong[return] list\_remove\_at(list, list-\>count - index);

}

~

#strong[void] #strong[list\_apply]\(#strong[const] list\* list,
#strong[void]\(\* func)(#strong[void]\*))

{

#strong[const] node\* tmp = list-\>head;

#strong[for]\(#strong[size\_t] i = 0; i \< list-\>count; i++)

{

func(tmp-\>data);

tmp = tmp-\>next;

}

}

~

list\* #strong[list\_apply\_and\_save]\(#strong[const] list\* list,
#strong[void]\*(\* func)(#strong[void]\*))

{

#strong[struct] #strong[list]\* new\_list = list\_create();

#strong[if]\(list-\>count == 0) #strong[return] new\_list;

~

#strong[const] node\* tmp = list-\>head;

node\* tmp\_new = malloc(sizeof(node));

~

new\_list-\>head = tmp\_new;

new\_list-\>head-\>data = func(list-\>head-\>data);

#strong[for]\(#strong[size\_t] i = 0; i \< list-\>count - 1; i++)

{

tmp\_new-\>next = malloc(sizeof(node));

tmp\_new = tmp\_new-\>next;

tmp = tmp-\>next;

tmp\_new-\>data = func(tmp-\>data);

}

~

new\_list-\>tail = tmp\_new;

~

new\_list-\>count = list-\>count;

#strong[return] new\_list;

}

~

#strong[int] #strong[list\_delete]\(list\* list)

{

#strong[if]\(list-\>count == 0)

{

free(list);

#strong[return] 1;

}

#strong[if]\(list-\>count == 1)

{

free(list-\>head);

free(list);

#strong[return] 1;

}

node\* tmp = list-\>head;

#strong[for]\(#strong[size\_t] i = 0; i \< list-\>count; i++)

{

node\* tmp\_next = tmp-\>next;

free(tmp);

tmp = tmp\_next;

}

free(list);

#strong[return] 1;

}

#strong[booksfile.h] (функции для чтения из файла и запись в файл книг)

#strong[\#pragma once]

~

#strong[\#include \"list.h\"]

~

list\* #strong[get\_book\_list\_from\_file]\(#strong[const]
#strong[char]\* path);

~

#strong[int] #strong[write\_book\_list\_to\_file]\(#strong[char]\* path,
list\* list);

#strong[booksfile.с]

#strong[\#define \_CRT\_SECURE\_NO\_WARNINGS]

~

#strong[\#include \"booksfile.h\"]

~

#strong[\#include \<stdio.h\>]

#strong[\#include \<stdlib.h\>]

~

#strong[\#include \"book.h\"]

~

~

list\* #strong[get\_book\_list\_from\_file]\(#strong[const]
#strong[char]\* path)

{

FILE\* file = fopen(path, \"r\");

#strong[if]\(!file) #strong[return] NULL;

~

list\* book\_list = list\_create();

#strong[char] buf\[300\];

~

#strong[while]\(fgets(buf, 300, file))

{

book\* new\_book = malloc(sizeof(book));

#strong[int] idx = 0;

#strong[for]\(#strong[int] i = 0; i \< SURNAME\_CHAR\_NUMBER; i++,
idx++)

{

new\_book-\>surname\[i\] = buf\[idx\];

}

new\_book-\>surname\[SURNAME\_CHAR\_NUMBER\] = \'\\0\';

idx++;

#strong[for]\(#strong[int] i = 0; i \< THEME\_CHAR\_NUMBER; i++, idx++)

{

new\_book-\>theme\[i\] = buf\[idx\];

}

new\_book-\>theme\[THEME\_CHAR\_NUMBER\] = \'\\0\';

idx++;

#strong[char] num\_str\[5\];

#strong[for]\(#strong[int] i = 0; i \< 5; i++, idx++)

{

num\_str\[i\] = buf\[idx\];

}

idx++;

new\_book-\>year = atoi(num\_str);

#strong[for]\(#strong[int] i = 0; i \< 5; i++, idx++)

{

num\_str\[i\] = buf\[idx\];

}

new\_book-\>page\_count = atoi(num\_str);

~

list\_push\_back(book\_list, new\_book);

}

~

fclose(file);

#strong[return] book\_list;

}

~

#strong[int] #strong[write\_book\_list\_to\_file]\(#strong[char]\* path,
list\* list)

{

FILE\* file = fopen(path, \"w\");

#strong[if]\(!file) #strong[return] 0;

~

book\*\* book\_arr = list\_to\_array(list);

#strong[for]\(#strong[int] i = 0; i \< list-\>count; i++)

{

fprintf(file, BOOK\_FORMAT\"\\n\",

book\_arr\[i\]-\>surname,

book\_arr\[i\]-\>theme,

book\_arr\[i\]-\>year,

book\_arr\[i\]-\>page\_count

);

}

~

fclose(file);

free(book\_arr);

#strong[return] 1;

}

#strong[ \ ]

#strong[Отладка приложения]

#box(image("lab-6/assets/media/image1.png"))

#box(image("lab-6/assets/media/image2.png"))

#box(image("lab-6/assets/media/image3.png"))

#box(image("lab-6/assets/media/image4.png"))#strong[ \ ]

#strong[Содержимое файлов]

books.txt -- исходный файл, из которого считываются книги.

#box(image("lab-6/assets/media/image5.png"))
