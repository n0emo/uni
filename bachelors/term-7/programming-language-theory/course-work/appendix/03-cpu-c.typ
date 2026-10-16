= Исходный код файла cpu.c <sup-cpu-c>

```c
#include "cpu.h"
#include "instructions.h"
#include "int.h"

#include <stdio.h>

void cpu_print(Cpu *cpu) {
    Instruction inst = get_instruction_by_opcode(mem_read(cpu->mem, cpu->PC));
    printf(
        "Instruction: %s\n"
        "PC=0x%.4x, SP=0x%.2x\n"
        "AC=0x%.2x, X=0x%.2x, Y=0x%.2x\n"
        "NV-BDIZC\n"
        "%d%d%d%d%d%d%d%d\n\n",
        cpu_inst_name(inst.type),
        cpu->PC,
        cpu->SP,
        cpu->A,
        cpu->X,
        cpu->Y,
        cpu->N,
        cpu->V,
        cpu->U,
        cpu->B,
        cpu->D,
        cpu->I,
        cpu->Z,
        cpu->C
    );
}

void cpu_init(Cpu *cpu, Memory *mem) {
    cpu->mem = mem;

    cpu->PC = 0;
    cpu->A = 0;
    cpu->X = 0;
    cpu->Y = 0;
    cpu->SP = 0;

    cpu->N = 0;
    cpu->V = 0;
    cpu->B = 0;
    cpu->D = 0;
    cpu->I = 0;
    cpu->Z = 0;
    cpu->C = 0;
}

void cpu_reset(Cpu *cpu) {
    uint8_t pc_fst = mem_read(cpu->mem, CPU_RESET_VECTOR_1);
    uint8_t pc_snd = mem_read(cpu->mem, CPU_RESET_VECTOR_2);
    cpu->PC = (pc_snd << 8) | pc_fst;
    printf("PC resetted to 0x%hx\n", cpu->PC);
}

void cpu_execute(Cpu *cpu) {
    uint8_t inst_code = mem_read(cpu->mem, cpu->PC);
    Instruction instruction = get_instruction_by_opcode(inst_code);
    Addressing addressing = get_addressing(instruction.address_mode);

    size_t inst_size = addressing.size;
    uint16_t data = mem_read16(cpu->mem, cpu->PC + 1);
    if (instruction.increment_pc)
    {
        cpu->PC += inst_size;
    }
    get_instruction_func(instruction.type)(cpu, addressing, data);
}

void cpu_set_z(Cpu *cpu, uint8_t value) { cpu->Z = value == 0; }

void cpu_set_n(Cpu *cpu, uint8_t value) { cpu->N = u8sign(value); }

void cpu_set_zn(Cpu *cpu, uint8_t value) {
    cpu_set_z(cpu, value);
    cpu_set_n(cpu, value);
}

uint8_t cpu_get_status(Cpu *cpu) {
    return (cpu->N & 1) << 7 | (cpu->V & 1) << 6 | 1 << 5 | 1 << 4 | (cpu->D & 1) << 3 | (cpu->I & 1) << 2 |
           (cpu->Z & 1) << 1 | (cpu->C & 1) << 0;
}

void cpu_push(Cpu *cpu, uint8_t value) {
    mem_write(cpu->mem, 0x100 | cpu->SP, value);
    cpu->SP--;
}

void cpu_push16(Cpu *cpu, uint16_t value) {
    cpu_push(cpu, u16_hi(value));
    cpu_push(cpu, u16_lo(value));
}

uint8_t cpu_pull(Cpu *cpu) {
    cpu->SP++;
    return mem_read(cpu->mem, 0x100 | cpu->SP);
}

uint16_t cpu_pull16(Cpu *cpu) {
    uint8_t lo = cpu_pull(cpu);
    uint8_t hi = cpu_pull(cpu);
    return u16_from_lohi(lo, hi);
}

void cpu_set_status(Cpu *cpu, uint8_t status) {
    cpu->N = 1 & (status >> 7);
    cpu->V = 1 & (status >> 6);
    cpu->U = 1;
    cpu->B = 1;
    cpu->D = 1 & (status >> 3);
    cpu->I = 1 & (status >> 2);
    cpu->Z = 1 & (status >> 1);
    cpu->C = 1 & (status >> 0);
}
```
