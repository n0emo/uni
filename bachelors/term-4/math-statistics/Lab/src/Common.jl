using SymPy


P = factorial ∘ big

A(m, n) = P(n) // P(n - m)

C(m, n) = P(n) // (P(m) * P(n - m))

n(p) = 1 - p

MakeBernulliExact(n, p) = (m) ->  C(m, n) * p^m * (1 - p)^(n - m)

function MakeBernulliExactRange(n, p) 
	p = MakeBernulliExact(n, p)
	(a, b) -> sum(p.(a:b))
end

function MakeBernulliApprox(n, p)
	q = 1 - p
    ϕ(x) = exp(-(x^2) / 2) / sqrt(2pi)
    xm(m) = (m - n * p) / sqrt(n * p * q)
    (m) -> ϕ(xm(m)) / sqrt(n * p * q)
end

function MakeBernulliApproxRange(n, p)
	@syms u
	q = 1 - p

	f(x) = exp(-(x^2) / 2)
	Φ0(x) = float(integrate(f(u), (u, 0, x)) / sqrt(2pi))
    xm(m) = (m - n * p) / sqrt(n * p * q)
	(a, b) -> Φ0(xm(b)) - Φ0(xm(a))
end

function MakeBernulliPuasson(n, p)
    λ = n * p
    (μ) -> λ^μ / P(μ) * exp(-λ)
end

function BernulliMostProbable(n, p)
	q = 1 - p
	first(filter(m -> n * p - q <= m <= n * p + p, 0:n))
end

printres(res, n) = println("Problem $n: $res\n")

const Alphabet = 'a':'z'

Iter = Union{AbstractArray, Tuple}

function printres(res::Iter, n) 
	println("Problem $n:")
	for (i, ans) in enumerate(res)
		println("  $(Alphabet[i])) $ans")
	end
	println()
end

function printres(res::Iter, n, puns::Iter)
	println("Problem $n:")
	for (i, ans) in enumerate(res)
		println("  $(puns[i]) $ans")
	end
	println()
end

