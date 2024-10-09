using SymPy
include("Common.jl")

function problem_01()
    a = 0.7
    n = 1 - a
    #               (A1 +  A2)  +      (A3 * A4 * A5)
    #             !(!A1 * !A2)  +      (A3 * A4 * A5)
    #        !    ((!A1 * !A2)  *  !   (A3 * A4 * A5)) 
    1 - ( (n   *  n)  * (1 - (a * a * a)))
end

problem_02() = float((C(2, 2) * C(8, 98) + C(1, 2) + C(9, 98)) // C(10, 100))

function problem_03()
    p = [0.8, 0.9, 0.85]
    n = [1, 1, 1] - p
	
	(
		p[1]*n[2]*n[3] + n[1]*p[2]*n[3] + n[1]*n[2]*p[3],
		n[1]*p[2]*p[3] + p[1]*n[2]*p[3] + p[1]*p[2]*n[3],
		1 - n[1]*n[2]*n[3]
	)
end

problem_04() = (5 // 9) * (6 // 10) + (4 // 9) * (5 // 10)

function problem_05()
    # Вероятность попасть к первому преподавателю
    p_b1 = 0.6
    # Вероятность попасть к первому преподавателю
    p_b2 = 0.4
    # Вероятность того, что первый преподаватель заметит шпаргалку
    p_a_b1 = 0.6
    # Вероятность того, что второй преподаватель заметит шпаргалку
    p_a_b2 = 0.7

    # Общая вероятность того, что шпаргалку заметят
    p_a = p_a_b1 * p_b1 + p_a_b2 * p_b2

    # Вероятность, что студент попал к первому преподавателю
    # (теорема Байеса)
    p_b1_a = p_b1 * p_a_b1 / p_a

    p_b1_a
end

function problem_06()
    n = 10
    p = 0.6
	q = 1 - p
    pn = MakeBernulliExact(n, p)

	(
		pn(4),
    	sum(pn.(4:10)),
    	sum(pn.(4:6)),
		BernulliMostProbable(n, p)
	)
end

function problem_07()
    n = 400
    p = 0.6
	pn = MakeBernulliExact(n, p)

	(pn(245), sum(pn.(245:250)))
end

function problem_07_limits()
    n = 400
    p = 0.6
	Pn = MakeBernulliApprox(n, p)
	Pn_r = MakeBernulliApproxRange(n, p)

	(Pn(245), Pn_r(245, 250))
end


problems = [
	(1, problem_01),
	(2, problem_02),
	(3, problem_03),
	(4, problem_04),
	(5, problem_05),
	(6, problem_06),
	(7, problem_07),
	("7 (limits)", problem_07_limits),
]

for (n, p) in problems
	printres(p(), n)
end
