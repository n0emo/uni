cmake_minimum_required(VERSION 3.14)

project(programming-cpp CXX)

# Lab 1 is not built: main.cpp includes <windows.h> and calls SetConsoleCP /
# SetConsoleOutputCP, so it only compiles on Windows. It is kept as handed in;
# its report still lists it via read().
add_subdirectory(lab-2)
add_subdirectory(lab-3)
add_subdirectory(lab-4)
add_subdirectory(lab-5)
add_subdirectory(lab-6)
add_subdirectory(lab-7)
