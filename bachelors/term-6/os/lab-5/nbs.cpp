#define NBS_IMPLEMENTATION
#include "nbs.hpp"

#include <map>

using namespace nbs;
using namespace std;
using p = os::path;

int main(int argc, char **argv) {
    // Пересобрать исполняемый файл nbs.exe в случае изменения nbs.cpp
    self_update(argc, argv, __FILE__);
    log::info("Starting building project");

    os::make_directory_if_not_exists("build");
    log::info("Created build directory");

    // Для сборки будет использован компилятор в составе
    // Visual Studio Build Tools - MSVC
    c::CompileOptions options;
    options.compiler = c::MSVC;
    options.include_paths = {"src"};
    options.other_flags = {"-nologo"};

    // Этот словарь отражает, от каких файлов зависит каждый файл
    // исходного кода.
    const map<string, vector<p>> sources({
        {"src\\a.cpp", {p("src\\a.hpp")}},
        {"src\\b.cpp", {p("src\\b.hpp")}},
        {"src\\main.cpp", {p("src\\a.hpp"), p("src\\b.hpp")}},
    });

    target::TargetMap project;
    std::vector<p> objects;

    // Определить цели сборки объектных файлов
    for (const auto &source : sources) {
        const p path(source.first);
        const string file = path.file_name();
        const p obj("build\\" + str::change_extension(file, "obj"));
        objects.push_back(obj);
        const os::Cmd cmd = options.obj_cmd(obj, source.first);
        project.insert(target::Target(obj, cmd, source.second));
    }

    // Определить цель сборки для итогового исполняемого файла
    const p out = p("build\\app.exe");
    project.insert(target::Target(
        out,
        options.exe_cmd(out, objects),
        objects
    ));

    // Запустить сборку
    project.build_if_needs(out.buf);

    return 0;
}
