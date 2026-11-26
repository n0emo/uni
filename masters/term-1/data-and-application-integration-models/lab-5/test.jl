using Test
include("solve.jl")

@testset "Расчёт по программе преподавателя" begin
    # Эталон получен вызовом численных функций исходной программы на тех же данных.
    teacher = teacher_weights(CRITERION_RANKS)
    @test teacher.threshold ≈ 0.14142135623730953
    @test teacher.means ≈ [1, 2.6, 2.6, 3.8]
    @test teacher.preliminary_ranks == [1, 2.5, 2.5, 4]
    @test teacher.distances == [0.5, 0.5, 0.5, 0.5, 3.5]
    @test teacher.competence ≈ [7, 7, 7, 7, 1] ./ 29
    @test teacher.weighted_means ≈ [1, 2.3103448275862064, 2.7241379310344827, 3.96551724137931]
    @test teacher.final_ranks == [1, 2, 3, 4]
    @test teacher.weights ≈ [0.48, 0.24, 0.16, 0.12]
    @test teacher.agreement ≈ 0.6170213395254125

    values = project_values()
    @test values[1, :] ≈ [90, 100, 10.5]
    projects = evaluate_projects(values, MINIMIZE, teacher.weights)
    @test projects.normalized ≈ [
        0.888268156424581 1 0
        1/3               1 0
        0                 1 0.25
        0.5853658536585366 0 1
    ]
    @test projects.scores ≈ [0.5766126175228234, 0.88, 0.16]
    @test projects.order == [2, 1, 3]
end

@testset "Независимая проверка по Кендаллу" begin
    kendall = kendall_concordance(CRITERION_RANKS)
    @test kendall.rank_sums == [5, 13, 13, 19]
    @test kendall.squares == 99
    @test kendall.tie_correction == 0
    @test kendall.w ≈ 0.792
    @test kendall.chi_squared ≈ 11.88
    @test kendall.degrees_of_freedom == 3

    tied = kendall_concordance([1.5 1; 1.5 2; 3 3])
    @test tied.tie_correction == 6
    @test tied.w ≈ 13 / 14
    @test_throws ArgumentError kendall_concordance([1 1; 1 2; 3 3])
    @test_throws ArgumentError kendall_concordance([1.5 1.5; 1.5 1.5])
end

@testset "Границы алгоритма" begin
    @test grouped_ranks([1.0, 1.125, 1.25, 1.5], 0.125) == [2, 2, 2, 4]
    @test_throws ArgumentError teacher_weights([1 1; 2 2])
    @test_throws ArgumentError evaluate_projects([1 1; 3 2], (false, true), [0.5, 0.5])
end
