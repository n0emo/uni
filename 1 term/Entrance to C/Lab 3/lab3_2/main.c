#include <stdio.h>

int main() {
    double V_i, L_j, f_ij, N_ij;

    double
            g = 9.8,
            m = 2000,
            V = 50,
            V2 = 50,
            L = 0.003,
            L2 = 0.003,
            dV = 10,
            dL = 0.001,
            V_k = 80,
            L_k = 0.006;

    V_i = V;
    while (V_i < V_k + dV * 0.5) {
        L_j = L;
        do {
            f_ij = (0.6 * V_i * L_j - V2 * L2) / (V2 - 0.6 * V_i);
            N_ij = m * g * V_i * (L_j + f_ij);
            printf_s("if V1 = %2.0lf and L1 = %0.3lf, then f = %lf and N = %lf\n", V_i, L_j, f_ij, N_ij);
            L_j += dL;
        } while (L_j < L_k + dL * 0.5);
        V_i += dV;
    }

    return 0;
}
