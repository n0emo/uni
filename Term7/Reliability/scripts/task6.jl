using SymPy

@syms t::positive λ₁::positive λ₂::positive λ₃::positive λ₄::positive λ₅::positive

λs = [3e-5, 4e-5, 2e-5, 3.6e-5, 9e-4]
λsv = [λ₁, λ₂, λ₃, λ₄, λ₅]
λz = collect(zip(λsv, λs))

γs = [0.90, 0.95, 0.99]

Pγ(λ, γ) = -log(γ) / λ

function reserved(ps, ms, t)
    zip(ps, ms) .|> (tup -> 1.0 - (1.0 - tup[1](t))^tup[2]) |> (ps -> reduce(*, ps))
end

exp_p(l, t) = exp(-l * t)
exp_ps(lams) = map(l -> (t -> exp_p(l, t)), lams)

print_task(n) = println("\n============= $n ==============")

print_task(1)
overall_pc(t) = exp(-sum(λs) * t)
println("Средняя наработка до отказа системы: ", integrate(overall_pc(t), (t, 0, Inf)))
println()

println("Гамма-процентная наработка:")
for γ in γs
    println("Pγ($γ) = $(Pγ(sum(λs), γ))")
end
println()

println("Требуемые ВБР:")
for γ in γs
    println("при γ=$γ: Pₜ=$(γ^(1/length(λs)))")
end

print_task(7)

(function approximate_optimal_1()
    t = 500
    ps = collect(exp_ps([λs[5], λs[5]]))

    min_m_sum_90 = Inf
    min_ms_90 = []
    min_m_sum_95 = Inf
    min_ms_95 = []
    min_m_sum_99 = Inf
    min_ms_99 = []

    for m1 in 0:0.001:5,
        m2 in 0:0.001:5

        ms = [m1, m2]
        p = reserved(ps, ms, t)
        m_sum = sum(ms)

        if p > 0.90
            if m_sum < min_m_sum_90
                min_m_sum_90 = m_sum
                min_ms_90 = ms
            end
        end

        if p > 0.95
            if m_sum < min_m_sum_95
                min_m_sum_95 = m_sum
                min_ms_95 = ms
            end
        end

        if p > 0.99
            if m_sum < min_m_sum_99
                min_m_sum_99 = m_sum
                min_ms_99 = ms
            end
        end
    end

    println("90%: $min_m_sum_90, $min_ms_90")
    println("95%: $min_m_sum_95, $min_ms_95")
    println("99%: $min_m_sum_99, $min_ms_99")
end)()

print_task(8)

(function approximate_optimal_2()
    t = 500
    ps = collect(exp_ps(λs[2:3]))

    min_m_sum_90 = Inf
    min_ms_90 = []
    min_m_sum_95 = Inf
    min_ms_95 = []
    min_m_sum_99 = Inf
    min_ms_99 = []

    for m2 in 0:0.001:5,
        m3 in 0:0.001:5

        ms = [m2, m3]
        p = reserved(ps, ms, t)
        m_sum = sum(ms)

        if p > 0.90
            if m_sum < min_m_sum_90
                min_m_sum_90 = m_sum
                min_ms_90 = ms
            end
        end

        if p > 0.95
            if m_sum < min_m_sum_95
                min_m_sum_95 = m_sum
                min_ms_95 = ms
            end
        end

        if p > 0.99
            if m_sum < min_m_sum_99
                min_m_sum_99 = m_sum
                min_ms_99 = ms
            end
        end
    end

    println("90%: $min_m_sum_90, $min_ms_90")
    println("95%: $min_m_sum_95, $min_ms_95")
    println("99%: $min_m_sum_99, $min_ms_99")
end)()

print_task(9)

(function approximate_optimal_3()
    t = 500
    ps = collect(exp_ps(λs[2:4] .* [2, 3, 4]))

    min_m_sum_90 = Inf
    min_ms_90 = []
    min_m_sum_95 = Inf
    min_ms_95 = []
    min_m_sum_99 = Inf
    min_ms_99 = []

    for m2 in 0:0.01:4,
        m3 in 0:0.01:4,
        m4 in 0:0.01:4

        ms = [m2, m3, m4]
        p = reserved(ps, ms, t)
        m_sum = sum(ms)

        if p > 0.90
            if m_sum < min_m_sum_90
                min_m_sum_90 = m_sum
                min_ms_90 = ms
            end
        end

        if p > 0.95
            if m_sum < min_m_sum_95
                min_m_sum_95 = m_sum
                min_ms_95 = ms
            end
        end

        if p > 0.99
            if m_sum < min_m_sum_99
                min_m_sum_99 = m_sum
                min_ms_99 = ms
            end
        end
    end

    println("90%: $min_m_sum_90, $min_ms_90")
    println("95%: $min_m_sum_95, $min_ms_95")
    println("99%: $min_m_sum_99, $min_ms_99")
end)()

print_task(10)

(function approximate_optimal_5()
    t = 500
    ps = collect(exp_ps(λs))

    min_m_sum_90 = Inf
    min_ms_90 = []
    min_m_sum_95 = Inf
    min_ms_95 = []
    min_m_sum_99 = Inf
    min_ms_99 = []

    for m1 in 0:0.05:2,
        m2 in 1:0.05:2,
        m3 in 1:0.05:2,
        m4 in 1:0.05:2,
        m5 in 2:0.05:6

        ms = [m1, m2, m3, m4, m5]
        p = reserved(ps, ms, t)
        m_sum = sum(ms)

        if p > 0.90
            if m_sum < min_m_sum_90
                min_m_sum_90 = m_sum
                min_ms_90 = ms
            end
        end

        if p > 0.95
            if m_sum < min_m_sum_95
                min_m_sum_95 = m_sum
                min_ms_95 = ms
            end
        end

        if p > 0.99
            if m_sum < min_m_sum_99
                min_m_sum_99 = m_sum
                min_ms_99 = ms
            end
        end
    end

    println("90%: $min_m_sum_90, $min_ms_90")
    println("95%: $min_m_sum_95, $min_ms_95")
    println("99%: $min_m_sum_99, $min_ms_99")
end)()
