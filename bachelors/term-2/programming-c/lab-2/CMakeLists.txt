add_executable(lab-2 src/main.c src/funcs.c)
target_compile_features(lab-2 PRIVATE c_std_11)
target_link_libraries(lab-2 PRIVATE m)
