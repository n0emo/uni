#include <iostream>
#include "NString.h"

bool check_str(NString *str);
void process_str(NString *str);
NString get_string();
void clear();
void pause();

char tmp[80];

int main() {
    while (true) {
        clear();
        // мне не хочется придумывать пустой конструктор
        // имея умный указатель, как я понял это будет
        // боль на 100+ строчек, поэтому сделать
        // глобальную переменную str не выйдет.
        NString str = get_string();
        if (!check_str(&str)) break;
        process_str(&str);
        pause();
    }
    return 0;
}

// лучше дать имя в коде, чем писать комментарий что делает эта строчка
void clear() {
    system("cls");
}

NString get_string() {
    std::cout << "Enter a string (80 char max):\n";
    std::cin.getline(tmp, 80);
    return NString(tmp);
}

// проверка на то, являются ли 2 последних символа числами
bool check_str(NString *str) {
    size_t len = str->size();
    if (len <= 1) {
        return true;
    }
    return !(str->get()[len - 1] >= '0' && str->get()[len - 1] <= '9' && str->get()[len - 2] >= '0' &&
             str->get()[len - 2] <= '9');
}

// вывести все методы, которые я смог придумать
void process_str(NString *str) {
    std::cout << str->get() << std::endl;
    std::cout << str->to_lowercase().get() << std::endl;
    std::cout << str->capitalize().get() << std::endl;
    std::cout << str->fill('_').get() << std::endl;
    std::cout << str->reverse().get() << std::endl;
    std::cout << str->caesar_cypher(5).get() << std::endl;
    std::cout << str->caesar_cypher(5).caesar_cypher(-5).get() << std::endl;
    std::cout << str->replace_numbers('#').get() << std::endl;
}

void pause() {
    system("pause");
}

void free() {

}
