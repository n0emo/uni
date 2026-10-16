include("Common.jl")

function problem_01()
    p(k) = 0.1(k + 1)
    b1 = p(2) * p(4)
    b2 = p(1) + n(p(1)) * n(p(2)) * n(p(3)) * n(p(4))
	(b1, b2)
end

function problem_02()
    p_a_1 = 0.4
    p_a_2 = 0.6
    p_a = n(p_a_1) * p_a_2
    p_a2_na = (p_a_1 * p_a_2) / n(p_a)
	(p_a, p_a2_na)
end

function problem_03()
    n = 10
    p = 0.6
    m = 3
    m1 = 3
    m2 = 5

    q = 1 - p

    pm(μ) = C(μ, n) * p^μ * q^(n - μ)
	(
		(pm(m)),
		(sum(pm.(0:m-1))),
		(sum(pm.(m:n))),
    	(sum(pm.(m1:m2)))
	)
end

function problem_04()
    n = 350
    p = 0.6
    m = 213
    m1 = 196
    m2 = 225
	
	pn = MakeBernulliExact(n, p)

	((pn(m)), (sum(pn.(0:m))), (sum(pn.(m1:m2))))

end

function problem_04_approx()
    n = 350
    p = 0.6
    m = 213
    m1 = 196
    m2 = 225

	pn_appr = MakeBernulliApprox(n, p)
	pn_appr_r = MakeBernulliApproxRange(n, p)

	(
		(pn_appr(big(m))),
		(pn_appr(big(0), m)),
		(pn_appr_r(big(m1), m2))
	)
    println("Approximate answer (Laplace):")
end

function problem_05()
    n = 100
    p = 0.003
    m = 3
    m1 = 0
    m2 = 2

	pn = MakeBernulliExact(n, p)

	(pn(m), sum(pn.(0:m)), sum(pn.(m1:m2)))
end

function problem_05_puasson()
    n = 100
    p = 0.003
    m = 3
    m1 = 0
    m2 = 2
	
	pn = MakeBernulliPuasson(n, p)

    println()
    println("Approximate answer (Puasson):")
	(
		pn(m),
		sum(pn.(0:m)),
		sum(pn.(m1:m2)),
	)
end

puns = ["μ = m:", "μ ≤ m:", "m1 ≤ μ ≤ m2:"]

problems = [
	(problem_01(), 1),
	(problem_02(), 2),
	(problem_03(), 3),
	(problem_04(), "4 Exact", puns),
	(problem_04(), "4 Laplace", puns),
	(problem_05(), "5 Exact", puns),
	(problem_05(), "5 Puasson", puns),
]

for args in problems
	printres(args...)
end
