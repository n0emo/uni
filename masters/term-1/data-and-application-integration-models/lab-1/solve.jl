const LOTS = [
    (name = "П1", books = 36, ready = 1, deadline = 2),
    (name = "П2", books = 30, ready = 1, deadline = 2),
    (name = "П3", books = 24, ready = 3, deadline = 4),
    (name = "П4", books = 18, ready = 4, deadline = 5),
]

const SHIFTS = [
    (name = "С1", day = 1, capacity = 20),
    (name = "С2", day = 2, capacity = 25),
    (name = "С3", day = 3, capacity = 20),
    (name = "С4", day = 4, capacity = 22),
    (name = "С5", day = 5, capacity = 26),
]

function production_network(lots, shifts)
    source = 1
    lot_vertices = 2:(1 + length(lots))
    shift_vertices = (last(lot_vertices) + 1):(last(lot_vertices) + length(shifts))
    sink = last(shift_vertices) + 1
    capacity = zeros(Int, sink, sink)

    for (vertex, lot) in zip(lot_vertices, lots)
        capacity[source, vertex] = lot.books
    end
    for (vertex, shift) in zip(shift_vertices, shifts)
        capacity[vertex, sink] = shift.capacity
    end
    for (from, lot) in zip(lot_vertices, lots), (to, shift) in zip(shift_vertices, shifts)
        if lot.ready <= shift.day <= lot.deadline
            capacity[from, to] = lot.books
        end
    end

    names = vcat("s", [lot.name for lot in lots], [shift.name for shift in shifts], "t")
    return (; capacity, source, sink, lot_vertices, shift_vertices, names)
end

function residual_parents(residual, source)
    vertex_count = size(residual, 1)
    parent = zeros(Int, vertex_count)
    parent[source] = source
    queue = [source]
    head = 1
    while head <= length(queue)
        from = queue[head]
        head += 1
        for to in 1:vertex_count
            if parent[to] != 0 || residual[from, to] <= 0
                continue
            end
            parent[to] = from
            push!(queue, to)
        end
    end
    return parent
end

function edmonds_karp(capacity::Matrix{Int}, source, sink)
    # The production network has no pair of original arcs in opposite directions.
    residual = copy(capacity)
    value = 0
    augmentations = Tuple{Vector{Int}, Int}[]

    while true
        parent = residual_parents(residual, source)
        if parent[sink] == 0
            source_side = parent .!= 0
            flow = max.(capacity - residual, 0)
            return (; value, flow, source_side, augmentations)
        end

        # Пройти от стока к истоку и найти узкое место пути.
        path = [sink]
        amount = typemax(Int)
        to = sink
        while to != source
            from = parent[to]
            amount = min(amount, residual[from, to])
            push!(path, from)
            to = from
        end

        # Уменьшить прямую остаточную ёмкость и увеличить обратную.
        for index in 1:(length(path) - 1)
            to = path[index]
            from = path[index + 1]
            residual[from, to] -= amount
            residual[to, from] += amount
        end
        value += amount
        reverse!(path)
        push!(augmentations, (path, amount))
    end
end

function verify_certificate(capacity, source, sink, result)
    @assert all(0 .<= result.flow) && all(result.flow .<= capacity)
    for vertex in axes(capacity, 1)
        net_out = sum(result.flow[vertex, :]) - sum(result.flow[:, vertex])
        if vertex == source
            @assert net_out == result.value
        elseif vertex == sink
            @assert net_out == -result.value
        else
            @assert net_out == 0
        end
    end

    @assert result.source_side[source] && !result.source_side[sink]
    cut_capacity = sum(capacity[result.source_side, .!result.source_side])
    @assert cut_capacity == result.value
    return cut_capacity
end

function write_results(output_dir, network, result)
    mkpath(output_dir)
    open(joinpath(output_dir, "network.csv"), "w") do file
        println(file, "from,to,capacity,flow,cut")
        for from in axes(network.capacity, 1), to in axes(network.capacity, 2)
            capacity = network.capacity[from, to]
            capacity == 0 && continue
            crosses_cut = result.source_side[from] && !result.source_side[to]
            println(file, join((network.names[from], network.names[to], capacity,
                result.flow[from, to], Int(crosses_cut)), ","))
        end
    end
    open(joinpath(output_dir, "augmentations.csv"), "w") do file
        println(file, "step,path,books")
        for (step, (path, amount)) in enumerate(result.augmentations)
            println(file, join((step, join(network.names[path], " → "), amount), ","))
        end
    end
end

function main(output_dir)
    network = production_network(LOTS, SHIFTS)
    result = edmonds_karp(network.capacity, network.source, network.sink)
    cut_capacity = verify_certificate(network.capacity, network.source, network.sink, result)
    write_results(output_dir, network, result)

    total_books = sum(lot.books for lot in LOTS)
    println("Готово к сроку: $(result.value) из $total_books фотокниг.")
    println("Пропускная способность минимального разреза: $cut_capacity.")
    println("Вершины со стороны источника: ", join(network.names[result.source_side], ", "))
end

if abspath(PROGRAM_FILE) == @__FILE__
    length(ARGS) <= 1 || error("Запуск: julia solve.jl [каталог CSV]")
    default_output = joinpath(@__DIR__, "results")
    main(isempty(ARGS) ? default_output : only(ARGS))
end
