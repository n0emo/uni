#include "gnuplot.hpp"
// #include <cassert>
#include <cstdarg>
#include <cstdio>

Gnuplot::Gnuplot(bool persist)
{
    pipe = popen(persist ? "gnuplot -persist" : "gnuplot", "w");
    // assert(pipe != NULL);
}

Gnuplot::~Gnuplot()
{
    if (pipe)
    {
        flush();
        pclose(pipe);
    }
}

int Gnuplot::printf(const char *fmt, ...)
{
    if (!pipe)
        return 0;

    va_list args;
    va_start(args, fmt);
    int result = vfprintf(pipe, fmt, args);
    va_end(args);
    return result;
}
void Gnuplot::flush()
{
    fflush(pipe);
}
