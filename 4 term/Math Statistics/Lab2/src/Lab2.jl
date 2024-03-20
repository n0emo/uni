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
    p_a2_na = ()
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
    p = 0.6
    m = 213
    m1 = 196
    m2 = 225

    q = 1 - p

    pm(μ) = C(μ, n) * p^μ * q^(n - μ)

    println("μ = m: $(pm(m))")
    println("μ ≤ m: $(sum(pm.(0:m)))")
    println("m1 ≤ μ ≤ m2: $(sum(pm.(m1:m2)))")
end

function problem_5()
    n = 100
    p = big(0.003)
    m = 3
    m1 = 0
    m2 = 2

    q = 1 - p

    pm(μ) = C(μ, n) * p^μ * q^(n - μ)

    println(sum(pm.(0:100)))

    println("μ = m: $(pm(m))")
    println("μ ≤ m: $(sum(pm.(0:m)))")
    println("m1 ≤ μ ≤ m2: $(sum(pm.(m1:m2)))")
end
end # module Lab2
