
TARGET ?= web

ifeq ($(TARGET), web)
    CXX = emcc -std=c++20
	CFLAGS = `pkg-config glfw3 --cflags` -isysteminclude/emscripten -g
    LIBS = -sUSE_WEBGPU -sASYNCIFY -sUSE_GLFW=3
	OUTPUT = app.html
else
    CXX = clang++ -std=c++20
	CFLAGS = `pkg-config glfw3 --cflags` -isysteminclude/native -g
    LIBS = `pkg-config glfw3 --libs` -L lib -lwgpu_native
	OUTPUT = app
endif

web: build/$(OUTPUT)

native: build/$(OUTPUT)

.PHONY: web native

# WEB

build/glfw3webgpu.o: glfw3webgpu.cpp
	mkdir -p build
	$(CXX) $(CFLAGS) -c glfw3webgpu.cpp -o build/glfw3webgpu.o

build/$(OUTPUT): main.cpp build/glfw3webgpu.o
	mkdir -p build
	cp ./lib/* ./build/
	$(CXX) $(CFLAGS) build/glfw3webgpu.o main.cpp -o build/$(OUTPUT) $(LIBS)

run: build/app.html
	python3 -m http.server -d build
