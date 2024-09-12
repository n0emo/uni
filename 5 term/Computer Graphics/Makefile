EMXX = emcc -std=c++20
EMFLAGS = -sUSE_WEBGPU -sASYNCIFY -sUSE_GLFW=3
CFLAGS = -isysteminclude -g

default: build/app.html

.PHONY: default

build/glfw3webgpu.o: glfw3webgpu.cpp
	mkdir -p build
	$(EMXX) $(CFLAGS) -c glfw3webgpu.cpp -o build/glfw3webgpu.o

build/app.html: main.cpp build/glfw3webgpu.o
	mkdir -p build
	$(EMXX) $(CFLAGS) $(EMFLAGS) build/glfw3webgpu.o main.cpp -o build/app.html

run: build/app.html
	python3 -m http.server -d build

