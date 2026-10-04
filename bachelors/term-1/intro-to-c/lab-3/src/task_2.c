#include <stdio.h>

int main()
{
    double g = 9.8;
    double m = 2000;
    double V = 50;
    double V2 = 50;
    double L = 0.003;
    double L2 = 0.003;
    double dV = 10;
    double dL = 0.001;
    double V_k = 80;
    double L_k = 0.006;

    double V_i = V;
    while (V_i < V_k + dV * 0.5)
    {
        double L_j = L;
        do
        {
            double f_ij = (0.6 * V_i * L_j - V2 * L2) / (V2 - 0.6 * V_i);
            double N_ij = m * g * V_i * (L_j + f_ij);
            printf("if V1 = %2.0lf and L1 = %0.3lf, then f = %lf and N = %lf\n", V_i, L_j, f_ij, N_ij);

            L_j += dL;
        } while (L_j < L_k + dL * 0.5);
        V_i += dV;
    }

    return 0;
}
