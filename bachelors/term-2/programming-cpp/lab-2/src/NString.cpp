#include "NString.h"
#include <cstring>

NString::NString(const char *string) {
    this->string = std::unique_ptr<const char[]>(string);
}

size_t NString::size() const {
    return strlen(this->get());
}

NString NString::to_lowercase() const {
    size_t size = this->size() + 1;
    char *new_string = new char[size];
    for (int i = 0; i < size - 1; i++) {
        char tmp = this->string[i];
        if (tmp >= 'A' && tmp <= 'Z') {
            tmp += 32;
        }
        new_string[i] = tmp;
    }
    new_string[size - 1] = 0;
    return NString(new_string);
}

NString NString::concatenate(NString second_string) const {
    const char *result_str = cstr_concatenation(this->get(), second_string.get());
    return NString(result_str);
}

NString NString::capitalize() const {
    size_t size = this->size() + 1;
    char *new_string = new char[size];
    bool need_capitalize = true;

    for (int i = 0; i < size - 1; i++) {
        char tmp = this->string[i];
        if (this->string[i] == '.') {
            need_capitalize = true;
        } else if (need_capitalize) {
            if (tmp >= 'a' && tmp <= 'z') {
                tmp -= 32;
            } else if (tmp != ' ') {
                need_capitalize = false;
            }
        } else {
            if (tmp >= 'A' && tmp <= 'Z') {
                tmp += 32;
            }
        }
        new_string[i] = tmp;
    }

    new_string[size - 1] = 0;
    return NString(new_string);
}

char *NString::cstr_concatenation(const char *str_a, const char *str_b) {
    size_t size_a = strlen(str_a);
    size_t size_b = strlen(str_b);
    size_t size = size_a + size_b + 1;
    char *new_string = new char[size];

    int index = 0;
    for (int i = 0; i < size_a; i++, index++) {
        new_string[index] = str_a[i];
    }
    for (int i = 0; i < size_b; i++, index++) {
        new_string[index] = str_b[i];
    }

    new_string[size - 1] = 0;
    return new_string;
}

NString NString::fill(const char new_symbol) const {
    size_t size = this->size() + 1;
    char *new_string = new char[size];
    for (int i = 0; i < size; i++) {
        if (this->get()[i] == ' ') {
            new_string[i] = new_symbol;
        } else {
            new_string[i] = this->get()[i];
        }
    }
    return NString(new_string);
}

NString NString::reverse() const {
    size_t count = this->size();
    char *new_string = new char[count + 1];
    for (int i = 0; i < count; i++) {
        new_string[i] = this->get()[count - i - 1];
    }
    new_string[count] = '\0';
    return NString(new_string);
}

NString NString::caesar_cypher(const int amount) const {
    size_t size = this->size() + 1;
    char *new_string = new char[size];
    for (int i = 0; i < size; i++) {
        char tmp = this->get()[i];
        if (tmp >= 'a' && tmp <= 'z') {
            tmp -= 'a';
            tmp += amount;
            tmp = trimChar(tmp);
            tmp += 'a';
        }
        if (tmp >= 'A' && tmp <= 'Z') {
            tmp -= 'A';
            tmp += amount;
            tmp = trimChar(tmp);
            tmp += 'A';
        }
        new_string[i] = tmp;
    }
    return NString(new_string);
}

NString NString::replace_numbers(const char new_symbol) const {
    size_t size = this->size() + 1;
    char *new_string = new char[size];
    for (int i = 0; i < size; i++) {
        char tmp = this->get()[i];
        if (tmp >= '0' && tmp <= '9') {
            tmp = new_symbol;
        }
        new_string[i] = tmp;
    }
    return NString(new_string);
}

NString NString::operator+(const NString &right) const {
    const char *result_str = cstr_concatenation(this->get(), right.get());
    return NString(result_str);
}

char NString::trimChar(char c) {
    if (c >= 26) c -= 26;
    else if (c < 0) c += 26;
    return c;
}
