#define NBS_IMPLEMENTATION
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
    options.exe_cmd(path({"build", "lab1"}), {path({"src", "main.c"})})
        .run_or_die("Error during compilation");
    return 0;
}
