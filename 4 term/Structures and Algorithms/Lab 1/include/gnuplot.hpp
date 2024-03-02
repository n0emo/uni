#ifndef GNUPLOT_HPP
#define GNUPLOT_HPP

#include <cstdio>

class Gnuplot
{
  private:
    FILE *pipe;

  public:
    Gnuplot(bool persist = false);
    ~Gnuplot();
    int printf(const char *fmt, ...);
    void flush();
};

#endif // GNUPLOT_HPP
