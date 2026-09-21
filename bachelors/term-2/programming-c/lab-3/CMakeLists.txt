add_executable(lab-3-1
  src/task-1/main.c
  src/task-1/hanoicalcs.c
  src/task-1/hanoisolve.c
  src/task-1/showhanoi.c
)
target_compile_features(lab-3-1 PRIVATE c_std_11)

add_executable(lab-3-2
  src/task-2/main.c
  src/task-2/num2.c
  src/task-2/num3.c
  src/task-2/num4.c
)
target_compile_features(lab-3-2 PRIVATE c_std_11)
target_link_libraries(lab-3-2 PRIVATE m)
