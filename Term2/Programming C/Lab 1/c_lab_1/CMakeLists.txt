cmake_minimum_required(VERSION 3.24)
project(c_lab_1 C)

set(CMAKE_C_STANDARD 23)

add_executable(c_lab_1 main.c strfuncs.h strfuncs.c tests.c tests.h)
