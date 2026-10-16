add_executable(lab-1-knapsack src/knapsack/knapsack.cpp)
target_include_directories(lab-1-knapsack PRIVATE include/solver)

add_executable(lab-1-pareto src/pareto/pareto.cpp src/pareto/gnuplot.cpp)
target_include_directories(lab-1-pareto PRIVATE include)

add_executable(lab-1-sat src/sat/sat.cpp src/sat/token.cpp src/sat/lexer.cpp src/sat/tree.cpp)
target_include_directories(lab-1-sat PRIVATE include/sat)

add_executable(lab-1-set-cover src/set_cover/set_cover.cpp)
target_include_directories(lab-1-set-cover PRIVATE include/solver)

foreach(target lab-1-knapsack lab-1-pareto lab-1-sat lab-1-set-cover)
  target_compile_features(${target} PRIVATE cxx_std_20)
endforeach()
