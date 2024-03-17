#include "gnuplot.hpp"
#include <algorithm>
#include <cstdio>
#include <fstream>
#include <gnuplot.hpp>
#include <ranges>
#include <string>
#include <vector>

#define NBS_IMPLEMENTATION
#include "../../../../nbs/nbs.hpp"

template <size_t N>
struct Point
{
    const std::array<double, N> coordinates;
    const std::string name;
    double operator[](size_t index) const
    {
        return coordinates[index];
    }
};

template <size_t N>
std::vector<Point<N>> get_points_from_file(const std::filesystem::path &path)
{
    std::vector<Point<N>> points;
    std::ifstream fin(path);
    std::string line;
    while (std::getline(fin, line))
    {
        std::vector<std::string> tokens = nbs::str::split(line, " ");
        assert(tokens.size() == N + 1);
        std::array<double, N> coordinates;
        std::transform(tokens.begin(), tokens.end() - 1, coordinates.begin(),
                       [](auto s) { return std::stod(s); });
        points.emplace_back(Point{coordinates, tokens.back()});
    }

    return points;
}

template <size_t N>
std::vector<Point<N>> get_pareto_front(
    const std::vector<Point<N>> &points,
    const std::array<bool, N> negative_criteria = std::array<bool, N>())
{
    const size_t count = points.size();
    std::vector<bool> suitable(count, true);
    for (size_t i = 0; i < count; i++)
    {
        if (!suitable[i])
            continue;

        for (size_t j = 0; j < points.size(); j++)
        {
            if (!suitable[j] || i == j)
                continue;

            if (std::ranges::none_of(
                    std::ranges::views::iota(0u, N),
                    [&](auto k) {
                        return negative_criteria[k]
                                   ? points[j][k] > points[i][k]
                                   : points[j][k] < points[i][k];
                    }))
            {
                suitable[i] = false;
            }
        }
    }
    std::vector<Point<N>> front;
    for (size_t i = 0; i < count; i++)
    {
        if (suitable[i])
            front.emplace_back(points[i]);
    }

    return front;
}

template <size_t N>
void write_points_to_file(
    const std::filesystem::path &path,
    const std::vector<Point<N>> &points)
{
    std::ofstream fout(path);
    for (const auto &p : points)
    {
        for (const auto &c : p.coordinates)
        {
            fout << c << " ";
        }
        fout << p.name << '\n';
    }
}

void plot_pareto_2(const std::filesystem::path &source, bool png = false)
{
    auto points = get_points_from_file<2>(source);
    auto front = get_pareto_front<2>(points);
    write_points_to_file<2>("output.txt", front);

    auto gnuplot = Gnuplot(!png);
    if (png)
    {
        gnuplot.printf("set term png\n"
                       "set putput 'plot.png'\n");
    }
    else
    {
        gnuplot.printf("set term qt\n");
    }
    gnuplot.printf(
        "set title \"Pareto\"\n"
        "plot 'data/pareto.txt' with points pt 6, "
        "'output.txt' with labels point pt 7 offset char 1,1 notitle\n");
}

void plot_pareto_3(const std::filesystem::path &source, bool png = false)
{
    auto points = get_points_from_file<3>(source);
    auto front = get_pareto_front<3>(points, {false, true, false});
    write_points_to_file<3>("output.txt", front);

    auto gnuplot = Gnuplot(!png);
    if (png)
    {
        gnuplot.printf("set term png\n"
                       "set putput 'plot.png'\n");
    }
    else
    {
        gnuplot.printf("set term qt\n");
    }
    gnuplot.printf(
        "set title \"Pareto\"\n"

        "set dgrid3d 30, 30 qnorm 5\n"
        "splot '%s' using 1:2:3 with points pt 6 nogrid, "
        "'%s' using 1:2:3:4 with labels point pt 7 offset char 1,1 nogrid\n"
        "replot '%s' using 1:2:3 with lines\n"
        "pause mouse close\n",

        source.c_str(),
        "output.txt",
        "output.txt");
}

int main()
{
    // plot_pareto_2("data/pareto.txt");
    plot_pareto_3("data/pareto3.txt");
    return 0;
}
