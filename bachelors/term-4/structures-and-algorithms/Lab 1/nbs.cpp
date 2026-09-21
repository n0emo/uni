#define NBS_IMPLEMENTATION
#include "../../../nbs/nbs.hpp"

using namespace nbs;
using namespace nbs::c;
using namespace nbs::os;
using namespace nbs::str;

const Path build_d("build");

bool build_sources_into(const std::string &output, const strvec &sources)
{
    Path src_d("src");
    src_d = src_d + output;
    CompileOptions options{
        .compiler = GXX,
        .standard = "c++20",
        .flags = {"-Wall", "-Wextra", /* "-O3", */ "-g"},
        .include_paths = {Path("include"), Path("include") + output, Path("include") + "solver"}};
    pathvec objects;

    for (const auto &source : sources)
    {
        Path input = src_d + source;
        Path output = build_d + change_extension(source, "o");

        if (!options.obj_cmd(output, input).run())
            return false;

        objects.emplace_back(output);
    }

    if (!options.exe_cmd(build_d + output, objects).run())
        return false;

    return true;
}

bool build(const std::string program)
{
    make_directory_if_not_exists(build_d);
    if (!Cmd({"cp", "-r", "data", (build_d + "data").str()}).run())
        return false;

    if (program == "all" || program == "knapsack")
    {
        if (!build_sources_into("knapsack", {"knapsack.cpp"}))
            return false;
    }
    if (program == "all" || program == "pareto")
    {
        if (!build_sources_into("pareto", {"pareto.cpp", "gnuplot.cpp"}))
            return false;
    }

    if (program == "all" || program == "sat")
    {
        if (!build_sources_into("sat", {"sat.cpp", "token.cpp", "lexer.cpp", "tree.cpp"}))
            return false;
    }

    if (program == "all" || program == "set_cover")
    {
        if (!build_sources_into("set_cover", {"set_cover.cpp"}))
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
        if (target != "knapsack" && target != "pareto" && target != "sat" && target != "set_cover" && target != "all")
        {
            log::error("Please provide valid program name. Options are:\n"
                       "  knapsack\n"
                       "  pareto\n"
                       "  sat\n"
                       "  set_cover");
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
        if (target != "knapsack" && target != "pareto" && target != "sat" && target != "set_cover")
        {
            log::error("Please provide valid program name. Options are:\n"
                       "  knapsack\n"
                       "  pareto");
            return 1;
        }

        if (!build(target))
        {
            log::error("Error during compilation");
            return 1;
        }

        if (!Cmd((Path(".") + build_d + target).str()).run())
        {
            log::error("Error running executable");
            return 1;
        }
    }

    return 0;
}
