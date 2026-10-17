#define NBS_IMPLEMENTATION
#include "../nbs/nbs.hpp"

int main(int argc, char **argv) {
    nbs::self_update(argc, argv, __FILE__);

    nbs::os::make_directory_if_not_exists("build");

    // Программа использует Windows API и conio.h, поэтому вне Windows
    // она собирается кросс-компилятором MinGW и запускается через Wine.
#ifdef _MSC_VER
    nbs::c::CompileOptions options;
    options.compiler = nbs::c::Compiler::MSVC;
    options.flags = {"-nologo", "-W4"};
    options.exe_cmd("build/app.exe", {"src/main.c", "src/thrdpool.c"}).run_or_die("Compilation failed");
#else
    nbs::os::Cmd({"x86_64-w64-mingw32-gcc", "-Wall", "-Wextra", "-o", "build/app.exe", "src/main.c", "src/thrdpool.c"})
        .run_or_die("Compilation failed");
#endif
}
