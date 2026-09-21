using SymPy

@syms t::positive λ₁::positive λ₂::positive λ₃::positive λ₄::positive λ₅::positive

λsv = [λ₁, λ₂, λ₃, λ₄, λ₅]
λz = collect(zip(λsv, [3e-5, 4e-5, 2e-5, 3.6e-5, 9e-4]))
ps = map(λ -> exp(-λ * t), λsv)
qs = map(λ -> 1 - exp(-λ * t), λsv)

paths = [
    [1, 2, 3],
    [1, 2, 4],
    [1, 2, 5],
    [1, 3, 4],
    [1, 3, 5],
    [1, 4, 5],
    [2, 3, 4],
    [2, 3, 5],
    [2, 4, 5],
    [3, 4, 5],
]

P(t) = 1 - reduce(*,
    map(p -> 1 - exp(-reduce(+,
            map(
                i -> λsv[i],
                p
            )
        ) * t),
        paths)
)

println("int  T = ", integrate(P(t), (t, 0, Inf)))
println("mean T = ", integrate(P(t).subs(λz), (t, 0, Inf)))
println("90%  T = ", nsolve(Eq(P(t).subs(λz), 0.9), 3000))
println()
