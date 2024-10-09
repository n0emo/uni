cmake_minimum_required(VERSION 3.24)
project(cpp_lab_5)

set(CMAKE_CXX_STANDARD 20)

add_executable(cpp_lab_5 main.cpp liquids/BaseLiquid.h liquids/Petrol.cpp liquids/Petrol.h liquids/BaseLiquid.cpp liquids/FizzyDrink.cpp liquids/FizzyDrink.h liquids/AlcoholDrink.cpp liquids/AlcoholDrink.h)
