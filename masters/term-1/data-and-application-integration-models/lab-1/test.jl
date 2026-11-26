using Test

include("solve.jl")

function exhaustive_min_cut(capacity, source, sink)
    inner_vertices = setdiff(axes(capacity, 1), [source, sink])
    best_capacity = sum(capacity)
    for mask in 0:(2^length(inner_vertices) - 1)
        source_side = falses(size(capacity, 1))
        source_side[source] = true
        for (bit, vertex) in enumerate(inner_vertices)
            source_side[vertex] = isodd(mask >> (bit - 1))
        end
        best_capacity = min(best_capacity, sum(capacity[source_side, .!source_side]))
    end
    return best_capacity
end

@testset "Партии фотокниг" begin
    network = production_network(LOTS, SHIFTS)
    result = edmonds_karp(network.capacity, network.source, network.sink)
    @test verify_certificate(network.capacity, network.source, network.sink, result) == 87
    @test result.value == exhaustive_min_cut(network.capacity, network.source, network.sink)
    @test network.names[result.source_side] == ["s", "П1", "П2", "С1", "С2"]
    @test result.flow[network.lot_vertices, network.shift_vertices] == [
        20 16 0 0 0
        0 9 0 0 0
        0 0 20 4 0
        0 0 0 18 0
    ]
end

@testset "Перераспределение по обратной дуге" begin
    lots = [(name = "П1", books = 1, ready = 1, deadline = 2),
            (name = "П2", books = 1, ready = 1, deadline = 1)]
    shifts = [(name = "С1", day = 1, capacity = 1),
              (name = "С2", day = 2, capacity = 1)]
    network = production_network(lots, shifts)
    result = edmonds_karp(network.capacity, network.source, network.sink)
    @test verify_certificate(network.capacity, network.source, network.sink, result) == 2
    @test network.names[result.augmentations[2][1]] == ["s", "П2", "С1", "П1", "С2", "t"]
end
