#define NBS_IMPLEMENTATION
#include "../nbs/nbs.hpp"

#include <map>

using namespace nbs;
using namespace std;
using p = os::path;

#ifdef _MSC_VER
#define OBJECT "obj"
#define EXE ".exe"
#else
#define OBJECT "o"
#define EXE ""
#endif

int main(int argc, char **argv) {
    // Пересобрать исполняемый файл nbs.exe в случае изменения nbs.cpp
    self_update(argc, argv, __FILE__);
    log::info("Starting building project");

    os::make_directory_if_not_exists("build");
    log::info("Created build directory");

    // Для сборки в Windows будет использован компилятор в составе
    // Visual Studio Build Tools - MSVC, в остальных системах - c++
    c::CompileOptions options;
#ifdef _MSC_VER
    options.compiler = c::Compiler::MSVC;
    options.other_flags = {"-nologo"};
#else
    options.compiler = c::Compiler::CXX;
#endif
    options.include_paths = {"src"};

    // Этот словарь отражает, от каких файлов зависит каждый файл
    // исходного кода.
    const map<string, vector<p>> sources({
        {"src/a.cpp", {p("src/a.hpp")}},
        {"src/b.cpp", {p("src/b.hpp")}},
        {"src/main.cpp", {p("src/a.hpp"), p("src/b.hpp")}},
    });

    target::TargetMap project;
    std::vector<p> objects;

    // Определить цели сборки объектных файлов
    for (const auto &source : sources) {
        const string file = source.first.substr(source.first.rfind('/') + 1);
        const p obj("build/" + str::change_extension(file, OBJECT));
        objects.push_back(obj);
        const os::Cmd cmd = options.obj_cmd(obj, source.first);
        target::Target target(obj, cmd, source.second);
        project.insert(target);
    }

    // Определить цель сборки для итогового исполняемого файла
    const p out = p("build/app" EXE);
    target::Target app(out, options.exe_cmd(out, objects), objects);
    project.insert(app);

    // Запустить сборку
    project.build_if_needs(out.buf);

    return 0;
}
