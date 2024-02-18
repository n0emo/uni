#define ABUILD_IMPLEMENTATION
#include "../../../nbs/nbs.hpp"

using namespace nbs;

int main(int argc, char **argv)
{
    self_update(argc, argv, __FILE__);
    make_directory_if_not_exists("build");

    c::CompileOptions options
    {
        .compiler = c::GCC, 
        .flags = {"-Wall", "-Wextra", "-pedantic"},
        .libs = {"m"}
    };

    std::string subcommand = "";
    if (argc > 1)
        subcommand = argv[1];

    if (subcommand == "" || subcommand == "1")
    {
        log::info("Building task 1");
        options.exe_cmd(path({"build", "task_1"}), {path({"src", "task_1.c"})})
            .run_or_die("Error during compilation");
    }
    if (subcommand == "" || subcommand == "2")
    {
        log::info("Building task 2");
        options.exe_cmd(path({"build", "task_2"}), {path({"src", "task_2.c"})})
            .run_or_die("Error during compilation");
    }

    return 0;
}
