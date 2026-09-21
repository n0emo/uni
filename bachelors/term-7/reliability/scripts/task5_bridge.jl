using SymPy

@syms t::positive λ₁::positive λ₂::positive λ₃::positive λ₄::positive λ₅::positive

λsv = [λ₁, λ₂, λ₃, λ₄, λ₅]
λz = collect(zip(λsv, [3e-5, 4e-5, 2e-5, 3.6e-5, 9e-4]))

P(t) =
    (1 - (1 - exp(-(λ₁ + λ₂ + λ₃ + λ₄) * t))^2 *
         (1 - exp(-(λ₁ + λ₂ + λ₃ + λ₄ + λ₅) * t))^2)

println("  Base system:")
println("mean T = ", integrate(P(t).subs(λz), (t, 0, Inf)))
println("90%  T = ", nsolve(Eq(P(t).subs(λz), 0.9), 3000))
println()

println("  with 1 off:")
P(t) =
    (1 - (1 - exp(-(λ₁ + λ₂) * t))) *
    (
        1 - (1 - exp(-(λ₃ + λ₄ + λ₅) * t)) *
            (1 - exp(-(λ₃ + λ₄) * t))
    )
println("mean T = ", integrate(P(t).subs(λz), (t, 0, Inf)))
println("90%  T = ", nsolve(Eq(P(t).subs(λz), 0.9), 3000))
println()

println("  with 5 off:")
P(t) = 1 - (1 - exp(-(λ₁ + λ₂ + λ₃ + λ₄) * t))^2
println("mean T = ", integrate(P(t).subs(λz), (t, 0, Inf)))
println("90%  T = ", nsolve(Eq(P(t).subs(λz), 0.9), 3000))
