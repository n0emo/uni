using Test

include("solve.jl")

@testset "Объезд пяти школ" begin
    solution = little(DISTANCES)
    check = exhaustive_tours(DISTANCES)
    @test solution.best_route == [1, 2, 5, 3, 6, 4, 1]
    @test solution.best_cost == check.best_cost == 18
    @test route_cost(DISTANCES, [1, 2, 3, 4, 5, 6, 1]) == 32
    @test check.examined == 120
    @test check.optima == 1
    @test solution.root_bound < solution.best_cost
    @test solution.pruned > 0
end

@testset "Множество оптимумов" begin
    distances = ones(4, 4)
    solution = little(distances)
    check = exhaustive_tours(distances)
    @test solution.best_cost == check.best_cost == 4
    @test check.examined == check.optima == 6
end

@testset "Недопустимые дуги" begin
    distances = [
        Inf 1 Inf
        Inf Inf 2
        3 Inf Inf
    ]
    @test little(distances).best_route == [1, 2, 3, 1]
    distances[3, 1] = Inf
    @test little(distances).best_cost == Inf
end
