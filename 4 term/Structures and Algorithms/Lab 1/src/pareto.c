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
    bool *suitable = malloc(sizeof(bool) * points->count);
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
    printf("Input:\n");
    for (size_t i = 0; i < points.count; i++)
    {
        Point p = points.items[i];
        printf("  %s [%.1lf, %.1lf]\n", p.name, p.x, p.y);
    }

    printf("\nPareto front:\n");

    Points front = get_pareto_front(&points);
    for (size_t i = 0; i < front.count; i++)
    {
        Point p = front.items[i];
        printf("  %s [%.1lf, %.1lf]\n", p.name, p.x, p.y);
    }

    return 0;
}
