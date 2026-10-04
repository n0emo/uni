include("Common.jl")

function problem_02()
	P(10) * 6 * 2 // P(12)
end

function problem_03()
	N = C(10, 40)
	n_a = C(5, 15) * C(5, 25)
	n_b = C(10, 15) * C(0, 25)
	[
		("p_a", float(n_a / N)),
		("p_b", float(n_b / N)),
	]
end

function problem_04()
	p = [0.2, 0.5, 0.6, 0.8]
	q = ((s -> 1 - s)).(p)

	1 - (q[1]*q[2]*q[3]*p[4] + 
		 q[1]*q[2]*p[3]*q[4] + 
		 q[1]*p[2]*q[3]*q[4] + 
		 p[1]*q[2]*q[3]*q[4] +
		 q[1]*q[2]*q[3]*q[4])
end

problem_05() = Int(ceil(log(0.4, 0.1)))

function problem_06()
	n = 6
	p = 0.7
	pn = MakeBernulliExactRange(n, p)

	pn(3, 6)	
end

function problem_08()
	qs = [0.6, 0.3, 0.1] 
	ps = [0.95, 0.98, 0.97]
	ns = n.(ps)

	p_b = sum((*).(qs, ns))

	pa_i = map(p -> (p[1] * p[2]) / p_b, zip(ns, qs))
	(pa_i, sum(pa_i))
end

answers = [
	(problem_02(), 2)
	(problem_03(), 3)
	(problem_04(), 4)
	(problem_05(), 5)
	(problem_06(), 6)
	(problem_08(), 8)
]

for ans in answers
	printres(ans...)
end

