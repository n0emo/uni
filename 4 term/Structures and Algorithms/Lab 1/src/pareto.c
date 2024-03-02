#include "da.h"
#include <stdbool.h>
#include <stdio.h>
#include <string.h>

typedef struct
{
    double x, y;
    char *name;
} Point;

typedef struct
{
    Point *items;
    size_t count;
    size_t capacity;
} Points;

Points get_points_from_file(char *path)
{
    Points points = {0};
    FILE *file = fopen(path, "r");
    char *line = NULL;
    size_t size = 0;
    int chars;
    while ((chars = getline(&line, &size, file)) != -1)
    {
        // TODO: Error handling
        line[chars - 1] = 0;
        Point p = {0};
        sscanf(line, "%lf %lf", &p.x, &p.y);
        // skip two spaces
        char *name = strstr(line, " ") + 1;
        name = strstr(name, " ") + 1;

        p.name = strdup(name);
        da_append(points, p);
    }
    free(line);
    fclose(file);

    return points;
}

Points get_pareto_front(Points *points)
{
    bool suitable[points->count];
    for (size_t i = 0; i < points->count; i++)
    {
        suitable[i] = true;
    }

    for (size_t i = 0; i < points->count; i++)
    {
        if (!suitable[i])
            continue;

        Point current = points->items[i];
        for (size_t j = 0; j < points->count; j++)
        {
            if (!suitable[j] || i == j)
                continue;

            Point p = points->items[j];
            if (p.x <= current.x && p.y <= current.y)
                suitable[j] = false;
        }
    }

    Points front = {0};
    for (size_t i = 0; i < points->count; i++)
    {
        if (suitable[i])
            da_append(front, points->items[i]);
    }

    return front;
}

int main()
{
    Points points = get_points_from_file("data/pareto.txt"); // never freed
    Points front = get_pareto_front(&points);

    FILE *output = fopen("output.txt", "w");
    assert(output != NULL);

    for (size_t i = 0; i < front.count; i++)
    {
        Point p = front.items[i];
        fprintf(output, "%lf %lf %s\n", p.x, p.y, p.name);
    }

    fclose(output);

    FILE *gnuplot = popen("gnuplot", "w");
    assert(gnuplot != NULL);

    fprintf(gnuplot, "set term png\n");
    fprintf(gnuplot, "set output 'plot.png\n");
    fprintf(gnuplot, "set title \"Pareto\"\n");
    fprintf(gnuplot, "plot 'data/pareto.txt' with points pt 6"
                     ", 'output.txt' with labels point pt 7 offset char 1,1 notitle"
                     "\n");
    fflush(gnuplot);

    return 0;
}
