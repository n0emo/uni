CMAKE_MINIMUM_REQUIRED(VERSION 3.27)

project(
    cpp_lab_3
    VERSION 0.1
    LANGUAGES CXX
    DESCRIPTION "Own containers in c++"
)

message("Updating lists for " ${PROJECT_NAME})

set(CMAKE_CXX_STANDARD 23)

include_directories(${PROJECT_SOURCE_DIR})

add_executable(${PROJECT_NAME}
    main.cpp
    ДощечкаМешанины.hpp
)
