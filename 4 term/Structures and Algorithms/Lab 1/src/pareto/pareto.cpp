#include "gnuplot.hpp"
#include <fstream>
#include <gnuplot.hpp>
#include <sstream>
#include <string>
#include <vector>

struct Point
{
    double x, y;
    std::string name;
};

std::vector<Point> get_points_from_file(const std::string &path)
{
    std::vector<Point> points;
    std::ifstream fin(path);
    std::string line;
    while (std::getline(fin, line))
    {
        // TODO: Error handling
        Point p;
        std::istringstream line_stream(line);
        line_stream >> p.x >> p.y;
        line_stream.ignore(1);
        std::getline(line_stream, p.name);
        points.emplace_back(p);
    }

    return points;
}

std::vector<Point> get_pareto_front(const std::vector<Point> &points)
{
    std::vector<bool> suitable(points.size());
    for (size_t i = 0; i < points.size(); i++)
    {
        suitable[i] = true;
    }

    for (size_t i = 0; i < points.size(); i++)
    {
        if (!suitable[i])
            continue;

        Point current = points[i];
        for (size_t j = 0; j < points.size(); j++)
        {
            if (!suitable[j] || i == j)
                continue;

            Point p = points[j];
            if (p.x <= current.x && p.y <= current.y)
                suitable[j] = false;
        }
    }

    std::vector<Point> front;
    for (size_t i = 0; i < points.size(); i++)
    {
        if (suitable[i])
            front.emplace_back(points[i]);
    }

    return front;
}

int main()
{
    auto points = get_points_from_file("data/pareto.txt"); // never freed
    auto front = get_pareto_front(points);

    std::ofstream fout("output.txt");

    for (const Point &p : front)
    {
        fout << p.x << " " << p.y << " " << p.name << "\n";
    }
    fout.close();

    Gnuplot gnuplot;

    gnuplot.printf("set term png\n");
    gnuplot.printf("set output 'plot.png\n");
    gnuplot.printf("set title \"Pareto\"\n");
    gnuplot.printf("plot 'data/pareto.txt' with points pt 6"
                   ", 'output.txt' with labels point pt 7 offset char 1,1 notitle"
                   "\n");

    return 0;
}
