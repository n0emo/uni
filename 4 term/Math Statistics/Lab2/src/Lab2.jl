module Lab2

using SymPy

P = factorial ∘ big
A(m, n) = P(n) // P(n - m)
C(m, n) = P(n) // (P(m) * P(n - m))


n(p) = 1 - p

function problem_1()
    p(k) = 0.1(k + 1)
    b1 = p(2) * p(4)
    b2 = p(1) + n(p(1)) * n(p(2)) * n(p(3)) * n(p(4))
    println("B1 = $b1")
    println("B2 = $b2")
end

function problem_2()
    p_a_1 = 0.4
    p_a_2 = 0.6
    p_a = n(p_a_1) * p_a_2
    p_a2_na = (p_a_1 * p_a_2) / n(p_a)
    println("P(A) = $p_a")
    println("P(A2|!A) = $p_a2_na")
end

function problem_3()
    n = 10
    p = 0.6
    m = 3
    m1 = 3
    m2 = 5

    q = 1 - p

    pm(μ) = C(μ, n) * p^μ * q^(n - μ)
    println("μ = m: $(pm(m))")
    println("μ < m: $(sum(pm.(0:m-1)))")
    println("μ ≥ m: $(sum(pm.(m:n)))")
    println("m1 ≤ μ ≤ m2: $(sum(pm.(m1:m2)))")
end

function problem_4()
    n = 350
    p = big(0.6)
    m = 213
    m1 = 196
    m2 = 225

    q = 1 - p

    pn(μ) = C(μ, n) * p^μ * q^(n - μ)

    ϕ(x) = exp(-(x^2) / 2) / sqrt(2pi)
    xm(m) = (m - n * p) / sqrt(n * p * q)
    pn_appr(m) = ϕ(xm(m)) / sqrt(n * p * q)

    @syms u
    f(x) = exp(-(x^2) / 2)
    Φ0(x) = float(integrate(f(u), (u, 0, x)) / sqrt(2pi))
    pn_appr(a, b) = Φ0(xm(b)) - Φ0(xm(a))

    println("Exact answer:")
    println("  μ = m: $(pn(m))")
    println("  μ ≤ m: $(sum(pn.(0:m)))")
    println("  m1 ≤ μ ≤ m2: $(sum(pn.(m1:m2)))")

    println()
    println("Approximate answer (Laplace):")
    println("  μ = m: $(pn_appr(big(m)))")
    println("  μ ≤ m: $(pn_appr(big(0), m))")
    println("  m1 ≤ μ ≤ m2: $(pn_appr(big(m1), m2))")
end

function problem_5()
    n = 100
    p = big(0.003)
    m = 3
    m1 = 0
    m2 = 2

    q = 1 - p

    λ = n * p

    pn(μ) = C(μ, n) * p^μ * q^(n - μ)
    pn_appr(μ) = λ^μ / P(μ) * exp(-λ)

    println("Exact answer:")
    println("  μ = m: $(pn(m))")
    println("  μ ≤ m: $(sum(pn.(0:m)))")
    println("  m1 ≤ μ ≤ m2: $(sum(pn.(m1:m2)))")

    println()
    println("Approximate answer (Puasson):")
    println("  μ = m: $(pn_appr(m))")
    println("  μ ≤ m: $(sum(pn_appr.(0:m)))")
    println("  m1 ≤ μ ≤ m2: $(sum(pn_appr.(m1:m2)))")
end
end # module Lab2
