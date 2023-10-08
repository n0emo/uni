#ifndef CPP_LAB_1_APP_H
#define CPP_LAB_1_APP_H


#include "Csv.h"


class App {
private:
    typedef std::vector<std::string> str_vec;


    struct UserParams {
        Csv csv;
        std::string field;
        bool reverse;
        sort_mode mode;
    };

    struct Sort {
        std::string name;

        void (*func)(str_vec *, str_vec *, std::function<int(str_vec &, str_vec &)>);

        Sort(const char *_name, void(*_func)(str_vec *, str_vec *, std::function<int(str_vec &, str_vec &)>)) {
            name = _name;
            func = _func;
        }
    };

private:
    std::vector<Sort> sorts;

    void (*default_sort)(str_vec *, str_vec *, std::function<int(str_vec &, str_vec &)>);

public:
    App();

    int run();

    void add_sort(const char *name, void(*func)(str_vec *, str_vec *, std::function<int(str_vec &, str_vec &)>));

    void set_default_sort(void(*func)(str_vec *, str_vec *, std::function<int(str_vec &, str_vec &)>));

private:
    void sort_file();

    void test_all_sorts();

    static UserParams get_user_params();

    static std::string get_path(const char *prompt);

    static Csv get_csv();

    static std::string get_field();

    static bool prompt();

    static bool get_reverse();

    static sort_mode get_mode();


    static void test_sort(App::UserParams &params, App::Sort &sort, Csv &csv);
};


#endif //CPP_LAB_1_APP_H
