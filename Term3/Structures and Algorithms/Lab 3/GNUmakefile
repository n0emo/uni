cxxflags = -g -std=gnu++20 -O3
cc = gcc
cxx = g++
fortran = gfortran
include = -I include

.PHONY: default
default: prog

plot: plot.o HHashTable.o pyplot_module.o
	$(fortran) -lstdc++ plot.o HHashTable.o pyplot_module.o -o plot 

plot.o: fplot/plot.f90
	$(fortran) fplot/plot.f90 -c

pyplot_module.o: lib/pyplot_module.f90
	$(fortran) lib/pyplot_module.f90 -c

cmain: cmain.o HHashTable.o
	$(cxx) $(include) $(cxxflags) cmain.o HHashTable.o -o cmain 

cmain.o: cmain.c
	$(cc) cmain.c -c

HHashTable.o: interface/HHashTable.cpp
	$(cxx) $(cxxflags) interface/HHashTable.cpp -c

prog: prog.o
	$(cxx) $(cxxflags) -o prog -I include prog.o

prog.o: prog.cpp
	$(cxx) $(cxxflags) -c prog.cpp

.PHONY: clean
clean:
	rm *.o *.png prog cmain plot -f

