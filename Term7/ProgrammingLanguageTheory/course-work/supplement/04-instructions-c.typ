= Исходный код файла instruction.c <sup-instructions-c>

```c
#include "instructions.h"

#include "cpu.h"

void cpu_adc(Cpu *cpu, Addressing addressing, uint16_t operand) {
    uint8_t a = cpu->A;
    uint8_t m = addressing.load(cpu, operand);
    uint8_t c = cpu->C;
    cpu->A = a + m + c;
    cpu_set_zn(cpu, cpu->A);
    cpu->C = (int32_t)a + (int32_t)m + (int32_t)c > 0xFF;
    // cpu->V = u8sign(a ^ m) && u8sign(a ^ cpu->A);
    cpu->V = ((a ^ cpu->A) & (m ^ cpu->A) & 0x80) != 0;
}

void cpu_and(Cpu *cpu, Addressing addressing, uint16_t operand) {
    uint8_t b = addressing.load(cpu, operand);
    cpu->A = cpu->A & b;
    cpu_set_zn(cpu, cpu->A);
}

void cpu_asl(Cpu *cpu, Addressing addressing, uint16_t operand) {
    size_t a = addressing.load(cpu, operand);
    cpu->C = a & (1 << 7);
    a = a << 1;
    addressing.store(cpu, operand, a);
    cpu_set_zn(cpu, a);
}

void cpu_bcc(Cpu *cpu, Addressing addressing, uint16_t operand) {
    if (cpu->C == 0) {
        cpu->PC = addressing.address(cpu, operand);
    }
}

void cpu_bcs(Cpu *cpu, Addressing addressing, uint16_t operand) {
    if (cpu->C == 1) {
        cpu->PC = addressing.address(cpu, operand);
    }
}

void cpu_beq(Cpu *cpu, Addressing addressing, uint16_t operand) {
    if (cpu->Z != 0) {
        cpu->PC = addressing.address(cpu, operand);
    }
}

void cpu_bit(Cpu *cpu, Addressing addressing, uint16_t operand) {
    uint8_t value = addressing.load(cpu, operand);
    cpu->V = (value >> 6) & 1;
    cpu_set_z(cpu, value & cpu->A);
    cpu_set_n(cpu, value);
}

void cpu_bmi(Cpu *cpu, Addressing addressing, uint16_t operand) {
    if (cpu->N == 1) {
        cpu->PC = addressing.address(cpu, operand);
    }
}

void cpu_bne(Cpu *cpu, Addressing addressing, uint16_t operand) {
    if (cpu->Z == 0) {
        cpu->PC = addressing.address(cpu, operand);
    }
}

void cpu_bpl(Cpu *cpu, Addressing addressing, uint16_t operand) {
    if (cpu->N == 0) {
        cpu->PC = addressing.address(cpu, operand);
    }
}

void cpu_brk(Cpu *cpu, Addressing addressing, uint16_t operand) {
    UNUSED2(addressing, operand);
    cpu->B = 0;
}

void cpu_bvc(Cpu *cpu, Addressing addressing, uint16_t operand)
{
    if (cpu->V == 0) {
        cpu->PC = addressing.address(cpu, operand);
    }
}

void cpu_bvs(Cpu *cpu, Addressing addressing, uint16_t operand)
{
    if (cpu->V == 1) {
        cpu->PC = addressing.address(cpu, operand);
    }
}

void cpu_clc(Cpu *cpu, Addressing addressing, uint16_t operand)
{
    UNUSED2(addressing, operand);
    cpu->C = 0;
}

void cpu_cld(Cpu *cpu, Addressing addressing, uint16_t operand)
{
    UNUSED2(addressing, operand);
    cpu->D = 0;
}

void cpu_cli(Cpu *cpu, Addressing addressing, uint16_t operand)
{
    UNUSED2(addressing, operand);
    cpu->I = 0;
}

void cpu_clv(Cpu *cpu, Addressing addressing, uint16_t operand)
{
    UNUSED2(addressing, operand);
    cpu->V = 0;
}

void cpu_cmp(Cpu *cpu, Addressing addressing, uint16_t operand) {
    uint8_t a = cpu->A;
    uint8_t m = addressing.load(cpu, operand);
    cpu_set_zn(cpu, a - m);
    cpu->C = a >= m;
}

void cpu_cpx(Cpu *cpu, Addressing addressing, uint16_t operand) {
    uint8_t a = cpu->X;
    uint8_t m = addressing.load(cpu, operand);
    cpu_set_zn(cpu, a - m);
    cpu->C = a >= m;
}

void cpu_cpy(Cpu *cpu, Addressing addressing, uint16_t operand) {
    uint8_t a = cpu->Y;
    uint8_t b = addressing.load(cpu, operand);
    cpu_set_zn(cpu, a - b);
    cpu->C = a >= b;
}

void cpu_dec(Cpu *cpu, Addressing addressing, uint16_t operand) {
    uint8_t m = addressing.load(cpu, operand);
    m--;
    addressing.store(cpu, operand, m);
    cpu_set_zn(cpu, m);
}

void cpu_dex(Cpu *cpu, Addressing addressing, uint16_t operand) {
    UNUSED2(addressing, operand);
    cpu->X--;
    cpu_set_zn(cpu, cpu->X);
}

void cpu_dey(Cpu *cpu, Addressing addressing, uint16_t operand) {
    UNUSED2(addressing, operand);
    cpu->Y--;
    cpu_set_zn(cpu, cpu->Y);
}

void cpu_eor(Cpu *cpu, Addressing addressing, uint16_t operand) {
    uint8_t m = addressing.load(cpu, operand);
    cpu->A ^= m;
    cpu_set_zn(cpu, cpu->A);
}

void cpu_inc(Cpu *cpu, Addressing addressing, uint16_t operand) {
    uint8_t m = addressing.load(cpu, operand);
    m++;
    addressing.store(cpu, operand, m);
    cpu_set_zn(cpu, m);
}

void cpu_inx(Cpu *cpu, Addressing addressing, uint16_t operand) {
    UNUSED2(addressing, operand);
    cpu->X++;
    cpu_set_zn(cpu, cpu->X);
}

void cpu_iny(Cpu *cpu, Addressing addressing, uint16_t operand) {
    UNUSED2(addressing, operand);
    cpu->Y++;
    cpu_set_zn(cpu, cpu->Y);
}

void cpu_isc(Cpu *cpu, Addressing addressing, uint16_t operand) {
    UNUSED3(cpu, addressing, operand);
    abort();
}

void cpu_jam(Cpu *cpu, Addressing addressing, uint16_t operand) {
    UNUSED3(cpu, addressing, operand);
    abort();
}

void cpu_jmp(Cpu *cpu, Addressing addressing, uint16_t operand) {
    cpu->PC = addressing.address(cpu, operand);
}

void cpu_jsr(Cpu *cpu, Addressing addressing, uint16_t operand) {
    cpu_push16(cpu, cpu->PC - 1);
    cpu->PC = addressing.address(cpu, operand);
}

void cpu_lda(Cpu *cpu, Addressing addressing, uint16_t operand) {
    cpu->A = addressing.load(cpu, operand);
    cpu_set_zn(cpu, cpu->A);
}

void cpu_ldx(Cpu *cpu, Addressing addressing, uint16_t operand) {
    cpu->X = addressing.load(cpu, operand);
    cpu_set_zn(cpu, cpu->X);
}

void cpu_ldy(Cpu *cpu, Addressing addressing, uint16_t operand) {
    cpu->Y = addressing.load(cpu, operand);
    cpu_set_zn(cpu, cpu->Y);
}

void cpu_lsr(Cpu *cpu, Addressing addressing, uint16_t operand) {
    uint8_t m = addressing.load(cpu, operand);
    cpu->C = m & 1;
    m = (m >> 1);
    cpu_set_zn(cpu, m);
    addressing.store(cpu, operand, m);
}

void cpu_nop(Cpu *cpu, Addressing addressing, uint16_t operand) {
    UNUSED3(cpu, addressing, operand);
}

void cpu_ora(Cpu *cpu, Addressing addressing, uint16_t operand) {
    uint8_t m = addressing.load(cpu, operand);
    cpu->A |= m;
    cpu_set_zn(cpu, cpu->A);
}

void cpu_pha(Cpu *cpu, Addressing addressing, uint16_t operand) {
    UNUSED2(addressing, operand);
    cpu_push(cpu, cpu->A);
}

void cpu_php(Cpu *cpu, Addressing addressing, uint16_t operand) {
    UNUSED2(addressing, operand);
    cpu_push(cpu, cpu_get_status(cpu));
}

void cpu_pla(Cpu *cpu, Addressing addressing, uint16_t operand) {
    UNUSED2(addressing, operand);
    cpu->A = cpu_pull(cpu);
}

void cpu_plp(Cpu *cpu, Addressing addressing, uint16_t operand) {
    UNUSED2(addressing, operand);
    cpu_set_status(cpu, cpu_pull(cpu));
}

void cpu_rol(Cpu *cpu, Addressing addressing, uint16_t operand) {
    uint8_t m = addressing.load(cpu, operand);
    uint8_t old_carry = cpu->C;
    cpu->C = (m >> 7) & 1;
    m = (m << 1) | old_carry;
    addressing.store(cpu, operand, m);
    cpu_set_zn(cpu, m);
}

void cpu_ror(Cpu *cpu, Addressing addressing, uint16_t operand) {
    uint8_t m = addressing.load(cpu, operand);
    uint8_t old_carry = cpu->C;
    cpu->C = m & 1;
    m = (m >> 1) | (old_carry << 7);
    addressing.store(cpu, operand, m);
    cpu_set_zn(cpu, m);
}

void cpu_rti(Cpu *cpu, Addressing addressing, uint16_t operand) {
    UNUSED2(addressing, operand);
    cpu_set_status(cpu, cpu_pull(cpu));
    cpu->PC = cpu_pull16(cpu);
}

void cpu_rts(Cpu *cpu, Addressing addressing, uint16_t operand) {
    UNUSED2(addressing, operand);
    uint16_t address = cpu_pull16(cpu) + 1;
    cpu->PC = address;
}

// TODO: decimal mode
void cpu_sbc(Cpu *cpu, Addressing addressing, uint16_t operand) {
    uint8_t a = cpu->A;
    uint8_t m = addressing.load(cpu, operand);
    uint8_t c = cpu->C;
    cpu->A = a - m - (1 - c);
    cpu->C = (int32_t)a - (int32_t)m - (int32_t)(1 - c) >= 0;
    // cpu->V = u8sign(a ^ m) && u8sign(a ^ cpu->A);
    cpu->V = ((a ^ cpu->A) & (m ^ cpu->A) & 0x80) != 0;
    cpu_set_zn(cpu, cpu->A);
}

void cpu_sec(Cpu *cpu, Addressing addressing, uint16_t operand) {
    UNUSED2(addressing, operand);
    cpu->C = 1;
}

void cpu_sed(Cpu *cpu, Addressing addressing, uint16_t operand) {
    UNUSED2(addressing, operand);
    cpu->D = 1;
}

void cpu_sei(Cpu *cpu, Addressing addressing, uint16_t operand) {
    UNUSED2(addressing, operand);
    cpu->I = 1;
}

void cpu_sta(Cpu *cpu, Addressing addressing, uint16_t operand) {
    addressing.store(cpu, operand, cpu->A);
}

void cpu_stx(Cpu *cpu, Addressing addressing, uint16_t operand) { 
    addressing.store(cpu, operand, cpu->X);
}

void cpu_sty(Cpu *cpu, Addressing addressing, uint16_t operand) {
    addressing.store(cpu, operand, cpu->Y);
}

void cpu_tax(Cpu *cpu, Addressing addressing, uint16_t operand) {
    UNUSED2(addressing, operand);
    cpu->X = cpu->A;
    cpu_set_zn(cpu, cpu->A);
}

void cpu_tay(Cpu *cpu, Addressing addressing, uint16_t operand) {
    UNUSED2(addressing, operand);
    cpu->Y = cpu->A;
    cpu_set_zn(cpu, cpu->A);
}

void cpu_tsx(Cpu *cpu, Addressing addressing, uint16_t operand) {
    UNUSED2(addressing, operand);
    cpu->X = cpu->SP;
    cpu_set_zn(cpu, cpu->SP);
}

void cpu_txa(Cpu *cpu, Addressing addressing, uint16_t operand) {
    UNUSED2(addressing, operand);
    cpu->A = cpu->X;
    cpu_set_zn(cpu, cpu->A);
}

void cpu_tya(Cpu *cpu, Addressing addressing, uint16_t operand) {
    UNUSED2(addressing, operand);
    cpu->A = cpu->Y;
    cpu_set_zn(cpu, cpu->A);
}

void cpu_txs(Cpu *cpu, Addressing addressing, uint16_t operand) {
    UNUSED2(addressing, operand);
    cpu->SP = cpu->X;
}
```
