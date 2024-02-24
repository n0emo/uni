#define NBS_IMPLEMENTATION
#include "../../../nbs/nbs.hpp"

using namespace nbs;
using namespace os;

int main(int argc, char **argv)
{
    self_update(argc, argv, __FILE__);
    make_directory_if_not_exists("build");

    c::CompileOptions options
    {
        .compiler = c::GCC, 
        .flags = {"-Wall", "-Wextra", "-pedantic"},
        .libs = {Path("m")}
    };
    options.exe_cmd("build/lab5", {"src/main.c"})
        .run_or_die("Error during compilation");
    return 0;
}
