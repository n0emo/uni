cmake_minimum_required(VERSION 3.26)
project(cpp_lab_1)

set(CMAKE_CXX_FLAGS "-O3")
set(CMAKE_CXX_STANDARD 20)

add_executable(cpp_lab_1 main.cpp
        sort.cpp
        sort.h
        Csv.cpp
        Csv.h
        CsvParser.cpp
        CsvParser.h
        SortOptions.h)
