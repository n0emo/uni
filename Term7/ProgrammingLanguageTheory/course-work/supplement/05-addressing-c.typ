= Исходный код файла addressing.c <sup-addressing-c>

```c
#include "addressing.h"

#include "cpu.h"
#include "int.h"

uint8_t cpu_load_absolute(Cpu *cpu, uint16_t operand) {
    uint16_t address = cpu_address_absolute(cpu, operand);
    return mem_read(cpu->mem, address);
}

uint8_t cpu_load_absolute_x(Cpu *cpu, uint16_t operand) {
    uint16_t address = cpu_address_absolute_x(cpu, operand);
    return mem_read(cpu->mem, address);
}

uint8_t cpu_load_absolute_y(Cpu *cpu, uint16_t operand) {
    uint16_t address = cpu_address_absolute_y(cpu, operand);
    return mem_read(cpu->mem, address);
}

uint8_t cpu_load_accumulator(Cpu *cpu, uint16_t operand) {
    UNUSED(operand);
    return cpu->A;
}

uint8_t cpu_load_immediate(Cpu *cpu, uint16_t operand) {
    UNUSED(cpu);
    return u16_lo(operand);
}

uint8_t cpu_load_implied(Cpu *cpu, uint16_t operand) {
    UNUSED2(cpu, operand);
    return 0;
}

uint8_t cpu_load_indirect(Cpu *cpu, uint16_t operand) {
    uint16_t address = cpu_address_indirect(cpu, operand);
    return mem_read(cpu->mem, address);
}

uint8_t cpu_load_indirect_x(Cpu *cpu, uint16_t operand) {
    uint16_t address = cpu_address_indirect_x(cpu, operand);
    return mem_read(cpu->mem, address);
}

uint8_t cpu_load_indirect_y(Cpu *cpu, uint16_t operand) {
    uint16_t address = cpu_address_indirect_y(cpu, operand);
    return mem_read(cpu->mem, address);
}

uint8_t cpu_load_relative(Cpu *cpu, uint16_t operand) {
    uint16_t address = cpu_address_relative(cpu, operand);
    return mem_read(cpu->mem, address);
}

uint8_t cpu_load_zeropage(Cpu *cpu, uint16_t operand) {
    uint8_t address = cpu_address_zeropage(cpu, operand);
    return mem_read(cpu->mem, address);
}

uint8_t cpu_load_zeropage_x(Cpu *cpu, uint16_t operand) {
    uint8_t address = cpu_address_zeropage_x(cpu, operand);
    return mem_read(cpu->mem, address);
}

uint8_t cpu_load_zeropage_y(Cpu *cpu, uint16_t operand) {
    uint8_t address = cpu_address_zeropage_y(cpu, operand);
    return mem_read(cpu->mem, address);
}

void cpu_store_absolute(Cpu *cpu, uint16_t operand, uint8_t value) {
    uint16_t address = cpu_address_absolute(cpu, operand);
    mem_write(cpu->mem, address, value);
}

void cpu_store_absolute_x(Cpu *cpu, uint16_t operand, uint8_t value) {
    uint16_t address = cpu_address_absolute_x(cpu, operand);
    mem_write(cpu->mem, address, value);
}

void cpu_store_absolute_y(Cpu *cpu, uint16_t operand, uint8_t value) {
    uint16_t address = cpu_address_absolute_y(cpu, operand);
    mem_write(cpu->mem, address, value);
}

void cpu_store_accumulator(Cpu *cpu, uint16_t operand, uint8_t value) {
    UNUSED(operand);
    cpu->A = value;
}

void cpu_store_immediate(Cpu *cpu, uint16_t operand, uint8_t value) { 
    UNUSED3(cpu, operand, value);
}

void cpu_store_implied(Cpu *cpu, uint16_t operand, uint8_t value) {
    UNUSED3(cpu, operand, value);
}

void cpu_store_indirect(Cpu *cpu, uint16_t operand, uint8_t value) {
    uint8_t address = cpu_address_indirect(cpu, operand);
    mem_write(cpu->mem, address, value);
}

void cpu_store_indirect_x(Cpu *cpu, uint16_t operand, uint8_t value) {
    uint16_t address = cpu_address_indirect_x(cpu, operand);
    mem_write(cpu->mem, address, value);
}

void cpu_store_indirect_y(Cpu *cpu, uint16_t operand, uint8_t value) {
    uint16_t address = cpu_address_indirect_y(cpu, operand);
    mem_write(cpu->mem, address, value);
}

void cpu_store_relative(Cpu *cpu, uint16_t operand, uint8_t value) {
    uint16_t address = cpu_address_relative(cpu, operand);
    mem_write(cpu->mem, address, value);
}

void cpu_store_zeropage(Cpu *cpu, uint16_t operand, uint8_t value) {
    uint8_t address = cpu_address_zeropage(cpu, operand);
    mem_write(cpu->mem, address, value);
}

void cpu_store_zeropage_x(Cpu *cpu, uint16_t operand, uint8_t value) {
    uint8_t address = cpu_address_zeropage_x(cpu, operand);
    mem_write(cpu->mem, address, value);
}

void cpu_store_zeropage_y(Cpu *cpu, uint16_t operand, uint8_t value) {
    uint8_t address = cpu_address_zeropage_y(cpu, operand);
    mem_write(cpu->mem, address, value);
}

uint16_t cpu_address_absolute(Cpu *cpu, uint16_t operand) {
    UNUSED(cpu);
    return operand;
}

uint16_t cpu_address_absolute_x(Cpu *cpu, uint16_t operand) { 
    return operand + cpu->X; 
}

uint16_t cpu_address_absolute_y(Cpu *cpu, uint16_t operand) { 
    return operand + cpu->Y; 
}

uint16_t cpu_address_accumulator(Cpu *cpu, uint16_t operand) {
    UNUSED2(cpu, operand);
    return 0;
}

uint16_t cpu_address_immediate(Cpu *cpu, uint16_t operand) {
    UNUSED2(cpu, operand);
    return 0;
}

uint16_t cpu_address_implied(Cpu *cpu, uint16_t operand) {
    UNUSED2(cpu, operand);
    return 0;
}

uint16_t cpu_address_indirect(Cpu *cpu, uint16_t operand) { 
    return mem_read16(cpu->mem, operand); 
}

uint16_t cpu_address_indirect_x(Cpu *cpu, uint16_t operand) {
    uint8_t address_to_address = u16_lo(operand + cpu->X);
    return mem_read16(cpu->mem, address_to_address);
}

uint16_t cpu_address_indirect_y(Cpu *cpu, uint16_t operand) {
    uint16_t addr = u16_lo(operand);
    return mem_read16(cpu->mem, addr) + cpu->Y;
}

uint16_t cpu_address_relative(Cpu *cpu, uint16_t operand) {
    uint16_t offset = u16_lo(operand);
    if (offset < 0x80) {
        return cpu->PC + offset;
    }
    else {
        return cpu->PC + offset - 0x100;
    }
}

uint16_t cpu_address_zeropage(Cpu *cpu, uint16_t operand) {
    UNUSED(cpu);
    return u16_lo(operand);
}

uint16_t cpu_address_zeropage_x(Cpu *cpu, uint16_t operand) {
    return u16_lo(operand) + cpu->X;
}

uint16_t cpu_address_zeropage_y(Cpu *cpu, uint16_t operand) { 
    return u16_lo(operand) + cpu->Y;
}

```
