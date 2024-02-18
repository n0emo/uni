#define ABUILD_IMPLEMENTATION
#include "../../../nbs/nbs.hpp"

#include <optional>

using namespace nbs;
using namespace nbs::c;

std::optional<std::string> shift_args(int &argc, char **&argv)
{
    if (argc == 0)
    {
        return std::nullopt;
    }

    std::string result(*argv);
    argv++;
    argc--;
    return result;
}

bool build_sources_into(const std::string &output, const strvec &sources)
{
    CompileOptions options{.compiler = GCC, .flags = {"-Wall", "-Wextra"}, .include_paths = {"include"}};
    strvec objects;

    for (const auto &source : sources)
    {
        std::string input = path({"src", source});
        std::string output = path({"build", change_extension(source, "o")});

        if (!options.obj_cmd(output, input).run())
            return false;

        objects.emplace_back(output);
    }

    if (!options.exe_cmd(path({"build", output}), objects).run())
        return false;

    return true;
}

bool build(const std::string program)
{
    make_directory_if_not_exists("build");

    if (program == "all" || program == "knapstack")
    {
        if (!build_sources_into("knapstack", {"knapstack.c"}))
            return false;
    }
    if (program == "all" || program == "pareto")
    {
        if (!build_sources_into("pareto", {"pareto.c"}))
            return false;
    }

    return true;
}

int main(int argc, char **argv)
{
    self_update(argc, argv, __FILE__);

    std::string program = shift_args(argc, argv).value();
    std::string subcommand = shift_args(argc, argv).value_or("build");

    if (subcommand == "build")
    {
        std::string target = shift_args(argc, argv).value_or("all");
        if (target != "knapstack" && target != "pareto" && target != "all")
        {
            log::error("Please provide valid program name. Options are:\n"
                       "  knapstack\n"
                       "  pareto");
            return 1;
        }

        if (!build(target))
        {
            log::error("Error during compilation");
            return 1;
        }
        log::info("Compilation successful");
    }
    if (subcommand == "run")
    {
        std::string target = shift_args(argc, argv).value_or("all");
        if (target != "knapstack" && target != "pareto")
        {
            log::error("Please provide valid program name. Options are:\n"
                       "  knapstack\n"
                       "  pareto");
            return 1;
        }

        if (!build(target))
        {
            log::error("Error during compilation");
            return 1;
        }

        if (!Cmd(path({".", "build", target})).run())
        {
            log::error("Error running executable");
            return 1;
        }
    }

    return 0;
}
