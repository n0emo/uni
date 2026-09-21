add_executable(lab-5 src/main.cpp src/liquids/BaseLiquid.cpp src/liquids/AlcoholDrink.cpp src/liquids/FizzyDrink.cpp src/liquids/Petrol.cpp)
target_compile_features(lab-5 PRIVATE cxx_std_20)
