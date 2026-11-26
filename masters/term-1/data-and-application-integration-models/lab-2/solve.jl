const STOPS = ["Фотомастерская", "Школа А", "Школа Б", "Школа В", "Школа Г", "Школа Д"]

# Условные дорожные расстояния в километрах. Строка — откуда, столбец — куда.
const DISTANCES = [
    Inf  2    8    5    5    7
    3    Inf  7    7    4    8
    7    6    Inf  5    3    4
    4    6    5    Inf  6    3
    5    4    2    6    Inf  6
    6    7    4    2    6    Inf
]

struct SearchNode
    matrix::Matrix{Float64}
    rows::Vector{Int}
    columns::Vector{Int}
    successor::Vector{Int}
    predecessor::Vector{Int}
    bound::Float64
end

function reduce_matrix!(matrix)
    reduction = 0.0
    # Сначала вычитаем минимумы строк, затем минимумы столбцов.
    for lines in (eachrow(matrix), eachcol(matrix))
        for line in lines
            minimum_cost = minimum(line)
            isfinite(minimum_cost) || return Inf
            line .-= minimum_cost
            reduction += minimum_cost
        end
    end
    return reduction
end

function alternative_cost(costs, excluded)
    best = Inf
    for index in eachindex(costs)
        if index != excluded
            best = min(best, costs[index])
        end
    end
    return best
end

function branching_zero(matrix)
    best_penalty = -Inf
    chosen_row = 0
    chosen_column = 0
    for row in axes(matrix, 1), column in axes(matrix, 2)
        matrix[row, column] == 0 || continue
        row_alternative = alternative_cost(view(matrix, row, :), column)
        column_alternative = alternative_cost(view(matrix, :, column), row)
        penalty = row_alternative + column_alternative
        if penalty > best_penalty
            best_penalty = penalty
            chosen_row = row
            chosen_column = column
        end
    end
    return chosen_row, chosen_column, best_penalty
end

function include_arc(node, row, column)
    from = node.rows[row]
    to = node.columns[column]
    successor = copy(node.successor)
    predecessor = copy(node.predecessor)
    successor[from] = to
    predecessor[to] = from

    remaining_rows = setdiff(axes(node.matrix, 1), row)
    remaining_columns = setdiff(axes(node.matrix, 2), column)
    matrix = node.matrix[remaining_rows, remaining_columns]
    rows = node.rows[remaining_rows]
    columns = node.columns[remaining_columns]

    if length(rows) > 1
        # Найти концы объединённой цепочки и запретить её замыкание в подцикл.
        first_vertex = from
        while predecessor[first_vertex] != 0
            first_vertex = predecessor[first_vertex]
        end
        last_vertex = to
        while successor[last_vertex] != 0
            last_vertex = successor[last_vertex]
        end
        closing_row = findfirst(==(last_vertex), rows)
        closing_column = findfirst(==(first_vertex), columns)
        matrix[closing_row, closing_column] = Inf
    end
    new_bound = node.bound + node.matrix[row, column] + reduce_matrix!(matrix)
    return SearchNode(matrix, rows, columns, successor, predecessor, new_bound)
end

function exclude_arc(node, row, column)
    matrix = copy(node.matrix)
    matrix[row, column] = Inf
    new_bound = node.bound + reduce_matrix!(matrix)
    return SearchNode(matrix, node.rows, node.columns, node.successor, node.predecessor, new_bound)
end

function cycle_order(successor)
    order = [1]
    for _ in 1:length(successor)
        push!(order, successor[last(order)])
    end
    @assert last(order) == 1 && length(unique(order[1:end-1])) == length(successor)
    return order
end

route_cost(distances, route) =
    sum(distances[from, to] for (from, to) in zip(route[1:end-1], route[2:end]))

function little(distances)
    count = size(distances, 1)
    matrix = Float64.(distances)
    for vertex in 1:count
        matrix[vertex, vertex] = Inf
    end
    root_bound = reduce_matrix!(matrix)
    nodes = [SearchNode(matrix, collect(1:count), collect(1:count),
        zeros(Int, count), zeros(Int, count), root_bound)]

    best_cost = Inf
    best_route = Int[]
    branches = NamedTuple[]
    pruned = 0
    while !isempty(nodes)
        _, index = findmin(node -> node.bound, nodes)
        node = popat!(nodes, index)
        if !isfinite(node.bound) || node.bound >= best_cost
            pruned += 1
            continue
        end
        if isempty(node.rows)
            best_route = cycle_order(node.successor)
            best_cost = route_cost(distances, best_route)
            continue
        end

        row, column, penalty = branching_zero(node.matrix)
        included = include_arc(node, row, column)
        excluded = exclude_arc(node, row, column)
        push!(branches, (from = node.rows[row], to = node.columns[column],
            bound = node.bound, penalty = penalty, include_bound = included.bound,
            exclude_bound = excluded.bound))
        push!(nodes, included, excluded)
    end
    return (; best_cost, best_route, root_bound, branches, pruned)
end

function exhaustive_tours(distances)
    route = [1]
    vertex_count = size(distances, 1)
    visited = falses(vertex_count)
    visited[1] = true
    best_cost = Inf
    best_route = Int[]
    examined = 0
    optima = 0

    function visit()
        if length(route) == vertex_count
            tour = [route; 1]
            cost = route_cost(distances, tour)
            examined += 1
            if cost < best_cost
                best_cost = cost
                best_route = tour
                optima = 1
            elseif isfinite(cost) && cost == best_cost
                optima += 1
            end
            return
        end

        for vertex in 2:vertex_count
            visited[vertex] && continue
            visited[vertex] = true
            push!(route, vertex)
            visit()
            pop!(route)
            visited[vertex] = false
        end
    end

    visit()
    return (; best_cost, best_route, examined, optima)
end

function write_results(output_dir, result)
    mkpath(output_dir)
    open(joinpath(output_dir, "distances.csv"), "w") do file
        println(file, join(vcat("from/to", STOPS), ","))
        for (index, name) in enumerate(STOPS)
            costs = [isfinite(cost) ? string(Int(cost)) : "—" for cost in DISTANCES[index, :]]
            println(file, join(vcat(name, costs), ","))
        end
    end
    open(joinpath(output_dir, "route.csv"), "w") do file
        println(file, "step,from,to,km")
        route = result.best_route
        for (step, (from, to)) in enumerate(zip(route[1:end-1], route[2:end]))
            println(file, join((step, STOPS[from], STOPS[to], Int(DISTANCES[from, to])), ","))
        end
    end
    open(joinpath(output_dir, "branches.csv"), "w") do file
        println(file, "step,from,to,bound,penalty,include_bound,exclude_bound")
        format_bound(value) = isfinite(value) ? string(Int(value)) : "∞"
        for (step, branch) in enumerate(result.branches)
            println(file, join((step, STOPS[branch.from], STOPS[branch.to],
                format_bound(branch.bound), format_bound(branch.penalty),
                format_bound(branch.include_bound), format_bound(branch.exclude_bound)), ","))
        end
    end
end

function main(output_dir)
    result = little(DISTANCES)
    check = exhaustive_tours(DISTANCES)
    @assert result.best_cost == check.best_cost && check.examined == 120
    write_results(output_dir, result)
    println(join(STOPS[result.best_route], " → "))
    println("Длина маршрута: $(Int(result.best_cost)) км. Нижняя оценка в корне: $(Int(result.root_bound)) км.")
    alphabetical = [collect(eachindex(STOPS)); 1]
    baseline = route_cost(DISTANCES, alphabetical)
    println("По алфавиту: $(Int(baseline)) км. Экономия: $(Int(baseline - result.best_cost)) км.")
    println("Перебор проверил $(check.examined) маршрутов. Оптимальных маршрутов: $(check.optima).")
end

if abspath(PROGRAM_FILE) == @__FILE__
    length(ARGS) <= 1 || error("Запуск: julia solve.jl [каталог CSV]")
    default_output = joinpath(@__DIR__, "results")
    main(isempty(ARGS) ? default_output : only(ARGS))
end
