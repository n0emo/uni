cmake_minimum_required(VERSION 3.24)
project(lab_3)

set(CMAKE_CXX_STANDARD 17)

add_executable(lab_3 main.cpp employees/employees.cpp employees/EmployeeCinFactory.cpp employees/EmployeeCinFactory.h employees/EmployeeFactory.h Application.cpp Application.h)
