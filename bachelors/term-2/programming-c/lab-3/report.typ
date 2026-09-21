МИНИСТЕРСТВО ТРАНСПОРТА РОССИЙСКОЙ ФЕДЕРАЦИИ

ФЕДЕРАЛЬНОЕ АГЕНТСТВО ЖЕЛЕЗНОДОРОЖНОГО ТРАНСПОРТА

Государственное бюджетное образовательное учреждение

высшего образования

«ПЕТЕРБУРГСКИЙ ГОСУДАРСТВЕННЫЙ УНИВЕРСИТЕТ

ПУТЕЙ СООБЩЕНИЯ ИМПЕРАТОРА АЛЕКСАНДРА I»

Кафедра «ИНФОРМАЦИОННЫЕ И ВЫЧИСЛИТЕЛЬНЫЕ СИСТЕМЫ»

Дисциплина: «Программирование(C)»

ОТЧЕТ

по лабораторной работе № 3

Вариант #emph[19]

Выполнил студент Шефнер А.

Факультета #emph[АИТ]

Группы #emph[ИВБ-211]

Санкт-Петербург

2023

#emph[#strong[ \ ]]

#strong[Постановка задачи]

#strong[Задание 1 по Ханойской башне]

a) Вычислить (по формуле !) сколько времени, в воспринимаемом измерении,
надо для перемещении 64 элементов Ханойской башни на современном
компьютере.

b) Добавить в программу код для подсчета числа произведенных
перемещений, сравнить с формулой.

c) Добавить в программу код для отображения номера уровня стека вызовов
и аргументов, переданных на этот уровень

d) Написать и отладить программу , в которой надо перенести элементы с A
на С, но передвигать можно только с А=\>B, B=\>C и C=\>B, B=\>A, но не
А=\>C или C=\>A.

e) Написать и отладить программу , в которой надо перенести элементы с A
на B, но передвигать можно только с А=\>B, B=\>C и C=\>B, B=A, но не
А=\>C или C=\>A.

Программа должна отображать состояние башен после каждого перемещения.

#strong[ \ ]

#strong[Задание 2]

a) Написать рекурсивную функцию нахождения максимума (минимума) массива,
среди элементов, отвечающих какому-либо условию. Функцию условия
передавать в виде параметра.

b) Написать рекурсивные функции нахождения суммы и произведения
элементов массива, среди элементов, отвечающих какому-либо условию.
Функцию условия передавать в виде параметра.

#strong[Задание 3]

Напишите рекурсивный алгоритм поиска корня уравнения методом
последовательных приближений. Функцию для нахождения корня передавать
как указатель. Продемонстрируйте работу алгоритма, например, на поиске
кубического корня или уравнения, подобного x\*x=sin(x) (начальное
приближение x0=1) или других.

Приведение кубического уравнения, к виду для решения методом
последовательных приближений можно сделать такими тождественными
преобразованиями:

x\*x\*x=a

x=a/(x\*x)

3\*x=2\*x+a/(x\*x)

x=1/3\*(2\*x+a/(x\*x))

#strong[Задание 4]

Рекурсивная функция соответствует известной вам функции, и приведённая
формула также вам известна.

Задание:

a) Написать программу вычисления этой рекурсивной функции на C (для x в
диапазоне \[-1.2,3\].

b) Найти корень уравнения rS(x)=0, при начальном приближении x=3.

c) Написать код вычисления этой функции методом итераций.

Примечание: для задач 2, 3 и 4 использовать мемоизацию. Мемоизация
(англ. memoization от англ. memory и англ. optimization) --- в
программировании сохранение результатов выполнения функций для
предотвращения повторных вычислений. Это один из способов оптимизации,
применяемый для увеличения скорости выполнения компьютерных программ.

#strong[ \ ]

#strong[Пояснения]

Ханойская башня выполнена нерекурсивным алгоритмом. Программа
руководствуется таким правилом, что после каждого хода есть только один
возможный следующий ход без обращения предыдущего.

#strong[ \ ]

#strong[Код программы (Задание по Ханойской башне)]

#strong[main.c]

#strong[\#include \<stdlib.h\>]

#strong[\#include \<stdio.h\>]

#strong[~]

#strong[\#include \"hanoisolve.h\"]

#strong[\#include \"hanoicalcs.h\"]

#strong[~]

#strong[void show\_info\_task();]

#strong[~]

#strong[void solve\_hanoi\_task();]

#strong[~]

#strong[int main() {]

#strong[system(\"chcp 65001\");]

#strong[system(\"cls\");]

#strong[int task\_num;]

#strong[printf\_s(\"Введите номер желаемого действия:\\n\");]

#strong[printf\_s(\"1 - вывести информацию:\\n\");]

#strong[printf\_s(\"2 - решить ханойскую башню без ходов A=\>C и
C=\>A:\\n\");]

#strong[scanf\_s(\"%d\", &task\_num);]

#strong[switch (task\_num) {]

#strong[case 1:]

#strong[show\_info\_task();]

#strong[break;]

#strong[case 2:]

#strong[solve\_hanoi\_task();]

#strong[break;]

#strong[default:]

#strong[printf\_s(\"Неверный номер действия.\\n\");]

#strong[}]

#strong[~]

#strong[system(\"pause\");]

#strong[return 0;]

#strong[}]

#strong[~]

#strong[void show\_info\_task() {]

#strong[int disc\_count = 64;]

#strong[unsigned long long turn\_count =
calc\_turn\_count(disc\_count);]

#strong[printf\_s(\"Для %d дисков потребуется сделать %llu ходов.\\n\",
disc\_count, turn\_count);]

#strong[unsigned long long seconds = calc\_time(disc\_count);]

#strong[unsigned long long years = seconds / 60 / 60 / 24 / 365;]

#strong[printf(\"Это займёт %llu секунд или %llu лет.\\n\", seconds,
years );]

#strong[}]

#strong[~]

#strong[void solve\_hanoi\_task() {]

#strong[int disc\_count;]

#strong[printf\_s(\"Введите количество дисков.\\n\");]

#strong[scanf\_s(\"%d\", &disc\_count);]

#strong[if(disc\_count \<=0) {]

#strong[printf\_s(\"Количество дисков должно быть положительным.\");]

#strong[return;]

#strong[}]

#strong[~]

#strong[int dest;]

#strong[printf\_s(\"Введите номер стержня, на который надо переместить
диски (1 - B или 2 - C)\\n\");]

#strong[scanf\_s(\"%d\", &dest);]

#strong[if(dest \< 1 || dest \> 2) {]

#strong[printf\_s(\"Неверный номер.\");]

#strong[return;]

#strong[}]

#strong[~]

#strong[solve\_hanoi(disc\_count, dest);]

#strong[}]

#strong[ \ ]

#strong[hanoicalcs.h]

#strong[\#ifndef C\_LAB\_3\_1\_HANOICALCS\_H]

#strong[\#define C\_LAB\_3\_1\_HANOICALCS\_H]

#strong[~]

#strong[unsigned long long calc\_turn\_count(int disc\_count);]

#strong[~]

#strong[unsigned long long calc\_time(int disc\_count);]

#strong[~]

#strong[\#endif #emph[\/\/C\_LAB\_3\_1\_HANOICALCS\_H]]

#strong[ \ ]

#strong[hanoicalcs.c]

#strong[\#include \"hanoicalcs.h\"]

#strong[~]

#strong[unsigned long long calc\_turn\_count(int disc\_count) {]

#strong[if(disc\_count == 64) return ((unsigned long long)1 \<\< 64) -
1;]

#strong[return ((unsigned long long)1 \<\< disc\_count) - 1;]

#strong[}]

#strong[~]

#strong[unsigned long long calc\_time(int disc\_count) {]

#strong[unsigned long long turns\_per\_second = 309994085;]

#strong[return calc\_turn\_count(disc\_count) / turns\_per\_second;]

#strong[}]

#strong[ \ ]

#strong[hanoisolve.h]

#strong[\#ifndef C\_LAB\_3\_1\_HANOISOLVE\_H]

#strong[\#define C\_LAB\_3\_1\_HANOISOLVE\_H]

#strong[~]

#strong[typedef unsigned int uint;]

#strong[~]

#strong[typedef struct Rod {]

#strong[uint \*array;]

#strong[uint count;]

#strong[uint size;]

#strong[} Rod;]

#strong[~]

#strong[void solve\_hanoi(unsigned int disc\_count, unsigned int dest);]

#strong[~]

#strong[\#endif #emph[\/\/C\_LAB\_3\_1\_HANOISOLVE\_H]]

#strong[ \ ]

#strong[hanoisolve.c]

#strong[\#include \"hanoisolve.h\"]

#strong[\#include \"malloc.h\"]

#strong[\#include \"stdio.h\"]

#strong[\#include \"showhanoi.h\"]

#strong[\#include \"windows.h\"]

#strong[~]

#strong[\#define CLEAR 1]

#strong[\#define WAIT\_TIME 0]

#strong[~]

#strong[~]

#strong[void init\_rods(Rod\* rods, uint disc\_count);]

#strong[void find\_legal\_move(Rod\* rods\_state, int\* current\_move);]

#strong[uint check\_move(Rod\* a, Rod\* b);]

#strong[uint is\_empty(Rod\* rod);]

#strong[uint is\_full(Rod\* rod);]

#strong[void make\_move(Rod\* rods, const int\* move);]

#strong[uint check\_for\_solved(Rod\* rod);]

#strong[~]

#strong[void wait() {]

#strong[\#if WAIT\_TIME]

#strong[Sleep(WAIT\_TIME);]

#strong[\#else]

#strong[system(\"pause\");]

#strong[\#endif]

#strong[\#if CLEAR]

#strong[system(\"cls\");]

#strong[\#endif]

#strong[}]

#strong[~]

#strong[void solve\_hanoi(uint disc\_count, uint dest) {]

#strong[system(\"cls\");]

#strong[char\* aliases = \"ABC\";]

#strong[Rod rods\[3\];]

#strong[init\_rods(rods, disc\_count);]

#strong[~]

#strong[int current\_move\[2\];]

#strong[current\_move\[0\] = -1;]

#strong[current\_move\[1\] = -1;]

#strong[~]

#strong[show\_rods(rods, aliases);]

#strong[do {]

#strong[wait();]

#strong[find\_legal\_move(rods, current\_move);]

#strong[make\_move(rods, current\_move);]

#strong[show\_rods(rods, aliases);]

#strong[show\_move(aliases\[current\_move\[0\]\],
aliases\[current\_move\[1\]\], disc\_count);]

#strong[} while (!check\_for\_solved(&rods\[dest\]));]

#strong[}]

#strong[~]

#strong[void init\_rods(Rod\* rods, uint disc\_count) {]

#strong[rods\[0\].size = disc\_count;]

#strong[rods\[0\].count = disc\_count;]

#strong[rods\[0\].array = (uint \*)malloc(disc\_count \* sizeof
(uint));]

#strong[for(int i = 0; i \< disc\_count; i++) {]

#strong[rods\[0\].array\[i\] = disc\_count - i;]

#strong[}]

#strong[rods\[1\].size = rods\[2\].size = disc\_count;]

#strong[rods\[1\].count = rods\[2\].count = 0;]

#strong[rods\[1\].array = (uint \*)malloc(disc\_count \* sizeof
(uint));]

#strong[rods\[2\].array = (uint \*)malloc(disc\_count \* sizeof
(uint));]

#strong[for(int i = 0; i \< disc\_count; i++) {]

#strong[rods\[1\].array\[i\] = rods\[2\].array\[i\] = 0;]

#strong[}]

#strong[}]

#strong[~]

#strong[uint check\_for\_solved(Rod\* rod) {]

#strong[for(int i = 0; i \< rod -\> size; i++) {]

#strong[if(rod-\>array\[i\] != rod -\> size - i) return 0;]

#strong[}]

#strong[return 1;]

#strong[}]

#strong[~]

#strong[uint check\_move\_and\_change\_if\_legal(Rod\* rods, int
\*current\_move, int from, int to) {]

#strong[if((current\_move\[0\] != to || current\_move\[1\] != from) &&
check\_move(&rods\[from\], &rods\[to\])) {]

#strong[current\_move\[0\] = from;]

#strong[current\_move\[1\] = to;]

#strong[return 1;]

#strong[}]

#strong[return 0;]

#strong[}]

#strong[~]

#strong[void find\_legal\_move(Rod\* rods, int \*current\_move) {]

#strong[if(check\_move\_and\_change\_if\_legal(rods, current\_move, 0,
1)) return;]

#strong[if(check\_move\_and\_change\_if\_legal(rods, current\_move, 1,
0)) return;]

#strong[if(check\_move\_and\_change\_if\_legal(rods, current\_move, 1,
2)) return;]

#strong[if(check\_move\_and\_change\_if\_legal(rods, current\_move, 2,
1)) return;]

#strong[}]

#strong[~]

#strong[uint check\_move(Rod\* a, Rod\* b) {]

#strong[if(is\_empty(a)) return 0;]

#strong[if(is\_full(b)) return 0;]

#strong[if(is\_empty(b)) return 1;]

#strong[return a-\>array\[a-\>count - 1\] \< b-\>array\[b-\>count -
1\];]

#strong[}]

#strong[~]

#strong[uint is\_empty(Rod\* rod) { return rod-\>count == 0; }]

#strong[~]

#strong[uint is\_full(Rod\* rod) { return rod-\>count == rod-\>size; }]

#strong[~]

#strong[void make\_move(Rod\* rods, const int\* move) {]

#strong[Rod\* a = &rods\[move\[0\]\];]

#strong[Rod\* b = &rods\[move\[1\]\];]

#strong[b-\>array\[b-\>count++\] = a-\>array\[-\-a-\>count\];]

#strong[a-\>array\[a-\>count\] = 0;]

#strong[}]

#strong[ \ ]

#strong[showhanoi.h]

#strong[\#ifndef C\_LAB\_3\_1\_SHOWHANOI\_H]

#strong[\#define C\_LAB\_3\_1\_SHOWHANOI\_H]

#strong[~]

#strong[\#include \"hanoisolve.h\"]

#strong[~]

#strong[void show\_rods(Rod \*rods, char\* aliases);]

#strong[~]

#strong[void show\_move(char from, char to, uint disc\_max);]

#strong[~]

#strong[\#endif #emph[\/\/C\_LAB\_3\_1\_SHOWHANOI\_H]]

#strong[ \ ]

#strong[showhanoi.c]

#strong[\#include \<stdio.h\>]

#strong[\#include \"showhanoi.h\"]

#strong[\#include \"malloc.h\"]

#strong[\#define DISC\_SYMBOL \'\_\']

#strong[\#define BASE\_SYMBOL \'=\']

#strong[~]

#strong[char\* get\_disc\_str(uint size, uint max) {]

#strong[uint len = max \* 2 + 1;]

#strong[char\* str = (char\*)malloc(len + 1);]

#strong[for(int i = 0; i \< len; i++) {]

#strong[str\[i\] = i \< max - size + 1 || i \> max + size - 1 ? \' \' :
DISC\_SYMBOL;]

#strong[}]

#strong[str\[len\] = \'\\0\';]

#strong[return str;]

#strong[}]

#strong[~]

#strong[char\* get\_base\_str(uint max, char alias) {]

#strong[uint len = max \* 2 + 3;]

#strong[char\* str = (char\*)malloc(len + 1);]

#strong[for(int i = 0; i \< len; i++) {]

#strong[str\[i\] = BASE\_SYMBOL;]

#strong[}]

#strong[str\[max + 1\] = alias;]

#strong[str\[len\] = \'\\0\';]

#strong[return str;]

#strong[}]

#strong[~]

#strong[void print\_line(Rod \*rods, uint line) {]

#strong[uint max = rods-\>size;]

#strong[for(int i = 0; i \< 3; i++) {]

#strong[char\* str = get\_disc\_str(rods\[i\].array\[max - line - 1\],
max);]

#strong[printf\_s(\" %s \", str);]

#strong[free(str);]

#strong[}]

#strong[printf\_s(\"\\n\");]

#strong[}]

#strong[~]

#strong[void print\_bases(uint max, char\* aliases) {]

#strong[for(int i = 0; i \< 3; i++) {]

#strong[char\* str = get\_base\_str(max, aliases\[i\]);]

#strong[printf\_s(\" %s \", str);]

#strong[free(str);]

#strong[}]

#strong[printf\_s(\"\\n\\n\");]

#strong[}]

#strong[~]

#strong[void show\_rods(Rod \*rods, char\* aliases) {]

#strong[uint disc\_count = rods-\>size;]

#strong[for(int i = 0; i \< disc\_count; i++) {]

#strong[print\_line(rods, i);]

#strong[}]

#strong[print\_bases(disc\_count, aliases);]

#strong[}]

#strong[~]

#strong[void show\_move(char from, char to, uint disc\_max) {]

#strong[uint spaces = disc\_max \* 3 + 4;]

#strong[for(int i = 0; i \< spaces; i++) {]

#strong[printf\_s(\" \");]

#strong[}]

#strong[printf\_s(\"%c -\-\> %c\\n\\n\\n\", from, to);]

#strong[}]

#strong[ \ ]

#strong[Код программы (Задания 2-4)]

#strong[main.c]

#strong[\#include \<stdio.h\>]

#strong[\#include \<malloc.h\>]

#strong[~]

#strong[\#include \"num2.h\"]

#strong[\#include \"num3.h\"]

#strong[\#include \"num4.h\"]

#strong[~]

#strong[int condition(int x);]

#strong[~]

#strong[int main() {]

#emph[#strong[\/\/ Number 1]]

#strong[printf(\"Number 2.\\n\\n\");]

#strong[int arr\[18\] = {2, 7, 5, 2, 67,]

#strong[3, 45, 23, 5, 56,]

#strong[23, 45, 566, 4, 5,]

#strong[2, 54, 67};]

#strong[for(int i = 0; i \< 18; i++) {]

#strong[printf(\"%d \", arr\[i\]);]

#strong[}]

#strong[printf(\"\\nMax: %d, sum: %d, product: %d.\\n\\n\",]

#strong[find\_max(arr, arr + 18, condition),]

#strong[sum\_func(arr, arr + 18, condition),]

#strong[product\_func(arr, arr + 18, condition));]

#strong[~]

#emph[#strong[\/\/ Number 2]]

#strong[printf(\"Number 3.\\n\\n\");]

#strong[printf(\"Root for func 1: %lf.\\n\", find\_root(1, func\_1,
0.01));]

#strong[printf(\"Root for func 2: %lf.\\n\\n\", find\_root(1, func\_2,
0.01));]

#strong[~]

#emph[#strong[\/\/ Number 3]]

#strong[printf(\"Number 3.\\n\\n\");]

#strong[~]

#strong[double integ = 0;]

#strong[for(double x = -1.2; x \<= 3; x += 0.0001)]

#strong[integ += func\_rs\_iterative(x);]

#strong[integ \*= 0.0001;]

#strong[printf(\"Integral from, -1.2 to 3 of rS: %lf\\n\", integ);]

#strong[printf(\"rS recursive: %lf\\n\",
find\_root(3,func\_rs\_recursive, 0.01));]

#strong[printf(\"rS iterative: %lf\\n\\n\",
find\_root(3,func\_rs\_iterative, 0.01));]

#strong[~]

#strong[return 0;]

#strong[}]

#strong[~]

#strong[int condition(int x) {]

#strong[static int \*cache = NULL;]

#strong[if(cache == NULL) {]

#strong[cache = (int \*) calloc(\_\_INT16\_MAX\_\_, 4);]

#strong[}]

#strong[if(x \<= \_\_INT16\_MAX\_\_ ) {]

#strong[if(cache\[x\] == 0) {]

#strong[cache\[x\] = (x % 2 == 1 && x \> 5 && x % 3 != 2) + 1;]

#strong[}]

#strong[return cache\[x\] - 1;]

#strong[}]

#strong[return (x % 2 == 1 && x \> 5 && x % 3 != 2);]

#strong[}]

#strong[ \ ]

#strong[num2.h]

#strong[\#ifndef C\_LAB\_3\_2\_NUM2\_H]

#strong[\#define C\_LAB\_3\_2\_NUM2\_H]

#strong[~]

#strong[int find\_max(int\* start, int\* end, int(\*cond)(int));]

#strong[~]

#strong[int sum\_func(int\* start, int\* end, int (\*cond)(int));]

#strong[~]

#strong[int product\_func(int\* start, int\* end, int (\*cond)(int));]

#strong[~]

#strong[\#endif #emph[\/\/C\_LAB\_3\_2\_NUM2\_H]]

#strong[ \ ]

#strong[num2.c]

#strong[\#include \"num2.h\"]

#strong[~]

#strong[\#define INT\_MIN (-2147483648)]

#strong[~]

#strong[void find\_max\_step(const int \*start, const int \*end, int
(\*cond)(int), int \*max\_elem) {]

#strong[if(start \> end) return;]

#strong[if(\*start \> \*max\_elem && cond(\*start))\*max\_elem =
\*start;]

#strong[find\_max\_step(++start, end, cond, max\_elem);]

#strong[}]

#strong[~]

#strong[int find\_max(int \*start, int \*end, int (\*cond)(int)) {]

#strong[int max\_elem = INT\_MIN;]

#strong[find\_max\_step(start, end, cond, &max\_elem);]

#strong[return max\_elem;]

#strong[}]

#strong[~]

#strong[void sum\_step(const int \*start, const int \*end,
int(\*cond)(int), int \*sum) {]

#strong[if(start \> end) return;]

#strong[if(cond(\*start))\*sum += \*start;]

#strong[sum\_step(start + 1, end, cond, sum);]

#strong[}]

#strong[~]

#strong[int sum\_func(int\* start, int\* end, int (\*cond)(int)) {]

#strong[int sum = 0;]

#strong[sum\_step(start, end, cond, &sum);]

#strong[return sum;]

#strong[}]

#strong[~]

#strong[void product\_step(int \*start, int \*end, int(\*cond)(int), int
\*product) {]

#strong[if(start \> end) return;]

#strong[if(cond(\*start)) \*product \*= \*start;]

#strong[product\_step(start + 1, end, cond, product);]

#strong[}]

#strong[~]

#strong[int product\_func(int\* start, int\* end, int (\*cond)(int)) {]

#strong[int product = 1;]

#strong[product\_step(start, end, cond, &product);]

#strong[return product;]

#strong[}]

#strong[num3.h]

#strong[\#ifndef C\_LAB\_3\_2\_NUM3\_H]

#strong[\#define C\_LAB\_3\_2\_NUM3\_H]

#strong[~]

#strong[double func\_1(double x);]

#strong[~]

#strong[double func\_2(double x);]

#strong[~]

#strong[double find\_root(double start\_x, double (\*func) (double x),
double delta);]

#strong[~]

#strong[\#endif #emph[\/\/C\_LAB\_3\_2\_NUM3\_H]]

#strong[num3.c]

#strong[\#include \"num3.h\"]

#strong[~]

#strong[\#include \<math.h\>]

#strong[~]

#strong[double func\_1(double x) {]

#strong[return x \* x - sin(x);]

#strong[}]

#strong[~]

#strong[double func\_2(double x) {]

#strong[return x \* x \* x - 1.728;]

#strong[}]

#strong[~]

#strong[double find\_root(double start\_x, double (\*func) (double x),
double delta) {]

#strong[if(round(func(start\_x) \* 100) == 0) {]

#strong[return start\_x;]

#strong[}]

#strong[~]

#strong[double f1 = round(func(start\_x - delta) \* 100);]

#strong[double f2 = round(func(start\_x + delta) \* 100);]

#strong[~]

#strong[if(fabs(f1) \<= fabs(f2)) {]

#strong[return find\_root(start\_x - delta, func, delta);]

#strong[}]

#strong[return find\_root(start\_x + delta, func, delta);]

#strong[}]

#strong[num4.h]

#strong[\#ifndef C\_LAB\_3\_2\_NUM4\_H]

#strong[\#define C\_LAB\_3\_2\_NUM4\_H]

#strong[~]

#strong[double func\_rs\_recursive(double x);]

#strong[~]

#strong[double func\_rs\_iterative(double x);]

#strong[~]

#strong[\#endif #emph[\/\/C\_LAB\_3\_2\_NUM4\_H]]

#strong[ \ ]

#strong[num4.c]

#strong[\#include \"num4.h\"]

#strong[~]

#strong[\#include \<math.h\>]

#strong[~]

#strong[double func\_rs\_recursive(double x) {]

#strong[if(x \< 0.01) {]

#strong[return x;]

#strong[}]

#strong[~]

#strong[double r = func\_rs\_recursive(x / 2);]

#strong[return 2 \* r \* sqrt(1 - r \* r);]

#strong[}]

#strong[~]

#strong[double func\_rs\_iterative(double x) {]

#strong[int depth = 0;]

#strong[double ans = x;]

#strong[~]

#strong[while(ans \>= 0.01) {]

#strong[depth++;]

#strong[ans /= 2;]

#strong[}]

#strong[~]

#strong[for(int i = 0; i \< depth; i++) {]

#strong[ans = 2 \* ans \* sqrt(1 - ans \* ans);]

#strong[}]

#strong[~]

#strong[return ans;]

#strong[}]

#strong[Отладка приложения (Задание по Ханойской башне):]

#box(image("assets/media/image1.png"))

#box(image("assets/media/image2.png"))

#box(image("assets/media/image3.png"))

#box(image("assets/media/image4.png"))

#box(image("assets/media/image5.png"))

#box(image("assets/media/image6.png"))

#box(image("assets/media/image7.png"))

#strong[Отладка приложения (Задания 2-4):]

#box(image("assets/media/image8.png"))
