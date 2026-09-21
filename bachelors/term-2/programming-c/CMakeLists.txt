cmake_minimum_required(VERSION 3.14)

project(programming-c C)

# Labs 4-6 are not built: their sources are MSVC-era and do not compile with a
# standards-conforming compiler. They are kept as handed in; their reports still
# list them via read(). See the lab directories for the sources.
add_subdirectory(lab-1)
add_subdirectory(lab-2)
add_subdirectory(lab-3)
