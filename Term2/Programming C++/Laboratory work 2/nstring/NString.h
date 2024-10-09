#ifndef NSTRING_NSTRING_H
#define NSTRING_NSTRING_H

#include <memory>


class NString {
public:
    explicit NString(const char *string);

    //~NString() = default;

    const char *get() const {
        return string.get();
    }

    size_t size() const;

    NString capitalize() const;

    NString to_lowercase() const;

    NString concatenate(NString second_string) const;

    NString fill(char new_symbol) const;

    NString reverse() const;

    NString caesar_cypher(int amount) const;

    NString replace_numbers(char new_symbol) const;

    NString operator+(const NString &right) const;

private:
    std::unique_ptr<const char[]> string;

    static char *cstr_concatenation(const char *str_a, const char *str_b);

    static char trimChar(char c);
};


#endif //NSTRING_NSTRING_H
