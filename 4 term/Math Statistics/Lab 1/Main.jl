P = factorial ∘ big
A(m, n) = P(n) // P(n - m)
C(m, n) = P(n) // (P(m) * P(n - m))

printres(res, n) = println("Problem $n: $res\n")

function problem_01()
    a = 0.7
    n = 1 - a
    #                   (A1 +  A2)  +      (A3 * A4 * A5)
    #              !   (!A1 * !A2)  +      (A3 * A4 * A5)
    #        !    (!   (!A1 * !A2)  *  !   (A3 * A4 * A5)) 
    result = 1 - ((1 - (n * n)) * (1 - (a * a * a)))
    printres(result, 1)
    println
end

function problem_02()
    result = (C(2, 2) * C(8, 98) + C(1, 2) + C(9, 98)) // C(10, 100)
    printres(float(result), 2)
end

function problem_03()
    p = [0.8, 0.9, 0.85]
    n = [1, 1, 1] - p
    result_a = p[1] * n[2] * n[3] + n[1] * p[2] * n[3] + n[1] * n[2] * p[3]
    result_b = n[1] * p[2] * p[3] + p[1] * n[2] * p[3] + p[1] * p[2] * n[3]
    result_c = 1 - n[1] * n[2] * n[3]
    println("Problem 3:")
    println("  a) $result_a")
    println("  b) $result_b")
    println("  c) $result_c\n")
end

function problem_04()
    result = (5 // 9) * (6 // 10) + (4 // 9) * (5 // 10)
    printres(result, 4)
end

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

    printres(p_b1_a, 5)
end

function problem_06()
    n = 10
    p = 0.6
    q = 0.4
    pn(m) = C(m, n) * p^m * q^(n - m)

    result_a = pn(4)
    result_b = sum(pn.(4:10))
    result_c = sum(pn.(4:6))
    result_d = filter(m -> n * p - q <= m <= n * p + p, 0:10)

    println("Problem 6:")
    println("  a) $result_a")
    println("  b) $result_b")
    println("  c) $result_c")
    println("  d) $result_d\n")
end

function problem_07()
    n = 400
    p = 0.6
    q = 0.4
    pn(m) = C(m, n) * p^m * q^(n - m)

    result_a = pn(245)
    result_b = sum(pn.(245:250))

    println("Problem 7:")
    println("  a) $result_a")
    println("  b) $result_b\n")
end


problem_01()
problem_02()
problem_03()
problem_04()
problem_05()
problem_06()
problem_07()
