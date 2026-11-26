include("data.jl")

# Соседние оценки, разделённые зазором не больше δ, входят в одну группу.
function grouped_ranks(values, threshold)
    order = sortperm(values)
    sorted_values = values[order]
    ranks = zeros(length(values))
    group_start = 1
    for position in eachindex(order)
        if position < length(order) &&
           sorted_values[position + 1] - sorted_values[position] <= threshold
            continue
        end
        average_rank = (group_start + position) / 2
        ranks[order[group_start:position]] .= average_rank
        group_start = position + 1
    end
    return ranks
end

function inverse_weights(values)
    reciprocal = 1 ./ values
    return reciprocal ./ sum(reciprocal)
end

function entropy_agreement(ranks)
    criteria_count, expert_count = size(ranks)
    entropy = 0.0
    for criterion_ranks in eachrow(ranks)
        for rank in 1:criteria_count
            frequency = count(==(rank), criterion_ranks)
            if frequency > 0
                probability = frequency / expert_count
                entropy -= probability * log(probability)
            end
        end
    end
    return 1 - entropy / (criteria_count * log(criteria_count))
end

function teacher_weights(ranks)
    criteria_count, expert_count = size(ranks)
    min(criteria_count, expert_count) >= 2 ||
        throw(ArgumentError("Нужно как минимум два эксперта и два критерия"))
    for column in eachcol(ranks)
        sort(column) == collect(1:criteria_count) ||
            throw(ArgumentError("Каждый эксперт задаёт перестановку целых рангов"))
    end

    threshold = 0.1 * (criteria_count^2 / (expert_count - 1))^0.25
    means = [sum(row) / expert_count for row in eachrow(ranks)]
    preliminary_ranks = grouped_ranks(means, threshold)
    distances = zeros(expert_count)
    for (expert, expert_ranks) in enumerate(eachcol(ranks))
        differences = expert_ranks .- preliminary_ranks
        distances[expert] = sum(abs2, differences)
    end
    if any(iszero, distances)
        throw(ArgumentError("Нулевая дистанция: нужна другая матрица рангов или взаимооценка"))
    end
    competence = inverse_weights(distances)
    weighted_means = [sum(criterion_ranks .* competence) for criterion_ranks in eachrow(ranks)]
    final_ranks = grouped_ranks(weighted_means, threshold)
    weights = inverse_weights(final_ranks)
    agreement = entropy_agreement(ranks)

    return (; threshold, means, preliminary_ranks, distances, competence,
            weighted_means, final_ranks, weights, agreement)
end

# Независимая проверка по Кендаллу, допускающая усреднённые связанные ранги.
function kendall_concordance(ranks)
    criteria_count, expert_count = size(ranks)
    min(criteria_count, expert_count) >= 2 ||
        throw(ArgumentError("Нужно как минимум два эксперта и два критерия"))

    tie_correction = 0
    for column in eachcol(ranks)
        column == grouped_ranks(column, 0) ||
            throw(ArgumentError("Связанным оценкам нужны средние ранги занятых мест"))
        for rank in unique(column)
            group_size = count(==(rank), column)
            tie_correction += group_size^3 - group_size
        end
    end
    rank_sums = vec(sum(ranks; dims=2))
    expected_sum = expert_count * (criteria_count + 1) / 2
    squares = sum(abs2, rank_sums .- expected_sum)
    denominator = expert_count^2 * (criteria_count^3 - criteria_count) -
                  expert_count * tie_correction
    denominator > 0 || throw(ArgumentError("Все ранги связаны, W не определён"))

    w = 12 * squares / denominator
    degrees_of_freedom = criteria_count - 1
    chi_squared = expert_count * degrees_of_freedom * w
    return (; rank_sums, expected_sum, squares, tie_correction, w,
            chi_squared, degrees_of_freedom)
end

function evaluate_projects(values, minimize, weights)
    size(values, 2) >= 2 || throw(ArgumentError("Нужно минимум две альтернативы"))
    size(values, 1) == length(minimize) == length(weights) ||
        throw(ArgumentError("Для каждой строки нужны направление и вес"))
    all(isfinite, values) || throw(ArgumentError("Оценки должны быть конечными"))

    normalized = zeros(size(values))
    for (criterion, criterion_values) in enumerate(eachrow(values))
        low, high = extrema(criterion_values)
        range = high - low
        range > 0 || throw(ArgumentError("Нулевой размах оценок критерия $criterion"))
        if minimize[criterion]
            normalized[criterion, :] .= (high .- criterion_values) ./ range
        else
            normalized[criterion, :] .= (criterion_values .- low) ./ range
        end
    end

    contributions = normalized .* weights
    scores = [sum(column) for column in eachcol(contributions)]
    order = sortperm(scores; rev=true)
    return (; normalized, contributions, scores, order)
end

function csv_field(value)
    return string(value)
end

function csv_field(value::AbstractString)
    return string('"', replace(value, '"' => "\"\""), '"')
end

function write_csv(path, header, rows)
    open(path, "w") do io
        println(io, join(header, ","))
        for row in rows
            println(io, join(map(csv_field, row), ","))
        end
    end
end

function write_results(output_dir, values, teacher, kendall, projects)
    mkpath(output_dir)
    rank_header = ("criterion_id", ("expert_$j" for j in eachindex(EXPERTS))...)
    rank_rows = ((i, row...) for (i, row) in enumerate(eachrow(CRITERION_RANKS)))
    write_csv(joinpath(output_dir, "ranks.csv"), rank_header, rank_rows)
    expert_header = ("expert", "distance", "competence")
    expert_rows = zip(EXPERTS, teacher.distances, teacher.competence)
    write_csv(joinpath(output_dir, "experts.csv"), expert_header, expert_rows)

    directions = [minimize ? "min" : "max" for minimize in MINIMIZE]
    criterion_header = (
        "criterion", "direction", "mean", "preliminary_rank", "weighted_mean", "final_rank", "weight",
    )
    criterion_rows = zip(
        CRITERIA, directions, teacher.means, teacher.preliminary_ranks,
        teacher.weighted_means, teacher.final_ranks, teacher.weights,
    )
    write_csv(joinpath(output_dir, "criteria.csv"), criterion_header, criterion_rows)

    value_header = ("project_id", "criterion_id", "value", "normalized", "contribution")
    value_rows = Tuple[]
    for project in eachindex(PROJECTS), criterion in eachindex(CRITERIA)
        raw_value = values[criterion, project]
        normalized = projects.normalized[criterion, project]
        contribution = projects.contributions[criterion, project]
        push!(value_rows, (project, criterion, raw_value, normalized, contribution))
    end
    write_csv(joinpath(output_dir, "values.csv"), value_header, value_rows)

    project_header = ("place", "project_id", "project", "ope")
    project_rows = Tuple[]
    for (place, project) in enumerate(projects.order)
        push!(project_rows, (place, project, PROJECTS[project], projects.scores[project]))
    end
    write_csv(joinpath(output_dir, "projects.csv"), project_header, project_rows)

    agreement_header = (
        "delta", "entropy_agreement", "kendall_w", "rank_sum_squares", "chi_squared", "degrees_of_freedom",
    )
    agreement_row = (
        teacher.threshold, teacher.agreement, kendall.w,
        kendall.squares, kendall.chi_squared, kendall.degrees_of_freedom,
    )
    write_csv(joinpath(output_dir, "agreement.csv"), agreement_header, [agreement_row])
end

function main(output_dir)
    values = project_values()
    teacher = teacher_weights(CRITERION_RANKS)
    kendall = kendall_concordance(CRITERION_RANKS)
    projects = evaluate_projects(values, MINIMIZE, teacher.weights)
    write_results(output_dir, values, teacher, kendall, projects)

    println("Согласие по Николаеву–Темнову: ", round(teacher.agreement; digits=4))
    println("Коэффициент конкордации Кендалла: ", round(kendall.w; digits=4))
    for (place, j) in enumerate(projects.order)
        println(place, ". ", PROJECTS[j], " — ", round(projects.scores[j]; digits=4))
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    length(ARGS) <= 1 || error("Запуск: julia solve.jl [каталог CSV]")
    default_output = joinpath(@__DIR__, "results")
    main(isempty(ARGS) ? default_output : only(ARGS))
end
