#define WEBGPU_CPP_IMPLEMENTATION
#include <webgpu/webgpu.hpp>
#include <GLFW/glfw3.h>
#ifdef __EMSCRIPTEN__
#include <emscripten.h>
#endif

#include <iostream>

#include "glfw3webgpu.h"

wgpu::Adapter createAdapter(wgpu::Instance &instance, wgpu::Surface &surface) {
    wgpu::RequestAdapterOptions options;
    options.compatibleSurface = surface;
    wgpu::Adapter adapter = instance.requestAdapter(options);
    return adapter;
}

wgpu::Device createDevice(wgpu::Adapter &adapter) {
    wgpu::DeviceDescriptor deviceDescriptor;
    wgpu::Device device = adapter.requestDevice(deviceDescriptor);
    return device;
}

wgpu::RenderPipeline createPipeline(wgpu::Device &device) {
    wgpu::RenderPipelineDescriptor desc;
    desc.label = "My pipeline";
    desc.vertex.buffers = nullptr;
    desc.vertex.bufferCount = 0;
    wgpu::RenderPipeline pipeline = device.createRenderPipeline(desc);
    return pipeline;
}

int main() {
    // Init GLFW
    glfwInit();
    glfwWindowHint(GLFW_CLIENT_API, GLFW_NO_API);
    GLFWwindow* window = glfwCreateWindow(640, 480, "Hello from WebGPU", nullptr, nullptr);

    wgpu::Instance instance = wgpuCreateInstance(nullptr);
    std::cout << "Created WebGPU Instance: " << instance << std::endl;

    wgpu::Surface surface = glfwGetWGPUSurface(instance, window);
    std::cout << "Created WebGPU Surface: " << surface << std::endl;

    wgpu::Adapter adapter = createAdapter(instance, surface);
    std::cout << "Created WebGPU Adapter: " << adapter << std::endl;

    wgpu::Device device = createDevice(adapter);
    std::cout << "Created WebGPU Device: " << device << std::endl;

    auto mainLoop = [](){
        glfwPollEvents();
    };

#ifdef __EMSCRIPTEN__
    emscripten_set_main_loop(mainLoop, 0, true);
#else
    while (!glfwWindowShouldClose(window))
        mainLoop();
#endif

    glfwDestroyWindow(window);
    glfwTerminate();

    return 0;
}

void main_loop() {
}
