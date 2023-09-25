cmake_minimum_required(VERSION 3.24)
project(c_lab_3_1 C)

set(CMAKE_C_STANDARD 23)

add_executable(c_lab_3_1 main.c  hanoisolve.h hanoisolve.c hanoicalcs.c hanoicalcs.h showhanoi.c showhanoi.h)
