#define NBS_IMPLEMENTATION
#include "nbs.hpp"

#ifdef _MSC_VER
#define OBJECT "obj"
#else
#define OBJECT "o"
#endif

int main(int argc, char **argv) {
    nbs::self_update(argc, argv, __FILE__);

    nbs::os::make_directory_if_not_exists("build");

    nbs::c::CompileOptions options;
    options.include_paths = {nbs::os::path("include")};
#ifdef _MSC_VER
    options.flags = {"-nologo", "-W4"};
    options.compiler = nbs::c::MSVC;
#else
    options.flags = {"-Wall", "-Wextra", "-pedantic", "-g"};
    options.compiler = nbs::c::CLANG;
#endif

    options.obj_cmd("build/main." OBJECT, "src/main.c").run();
    options.obj_cmd("build/greet." OBJECT, "src/greet.c").run();
    options.exe_cmd("build/app", {"build/main." OBJECT, "build/greet." OBJECT}).run();
}
