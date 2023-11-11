# pylint: skip-file


def is_power_of_two(num: int) -> bool:
    return num > 0 and (num - 1) & num == 0


# very optimized whink that i don't understand
def number_of_set_bits(i):
    i = i - ((i >> 1) & 0x55555555)
    i = (i & 0x33333333) + ((i >> 2) & 0x33333333)
    return (((i + (i >> 4)) & 0x0F0F0F0F) * 0x01010101) >> 24


def binary_dot_product(a, b):
    return number_of_set_bits(a & b) % 2


def xor(a, b):
    return (a + b) & 1
