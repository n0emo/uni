include("photo_orders.jl")

const SCHOOL_3 = [:segment => :school, :season_design => :ready, :photos => :selected]
const SCHOOL_4 = [SCHOOL_3; :mockup => :ready]
const SCHOOL_5 = [SCHOOL_4; :preview => :approved]

const DEMOS = [
    "3 критерия" => SCHOOL_3,
    "4 критерия" => SCHOOL_4,
    "5 критериев" => SCHOOL_5,
    "6 критериев" => [SCHOOL_5; :production => :prepared],
    "Ожидание согласования" => [SCHOOL_4; :preview => :waiting],
    "Военнослужащие" => [:segment => :soldiers, :production => :assembled, :video => :recorded],
    "Обычный заказ" => [
        :segment => :ordinary, :client_brief => :agreed,
        :design_source => :library, :design => :pending,
    ],
]

function describe(base, facts)
    criteria = Dict(criterion.key => criterion for criterion in base.criteria)
    descriptions = String[]
    for (key, value) in facts
        criterion = criteria[key]
        options = Dict(criterion.options)
        push!(descriptions, "$(criterion.title) — $(options[value])")
    end
    return join(descriptions, ", ")
end

function print_result(io, base, result)
    if result.status == :decision
        println(io, "Рекомендация. ", result.rule.action)
        println(io, "Правило ", result.rule.id, " применимо при условиях: ",
                describe(base, result.rule.conditions), ".")
    elseif result.status == :unknown
        criterion = result.criterion
        println(io, "Уточните «", criterion.title, "».")
        for rule in result.alternatives
            condition = only(pair for pair in rule.conditions if first(pair) == criterion.key)
            println(io, "Если ", describe(base, [condition]), ": ", rule.action)
        end
    else
        println(io, result.message)
    end
end

function demo(io, base; tsv=false)
    if tsv
        println(io, "Сценарий\tЧисло фактов\tРезультат")
    end
    for (title, facts) in DEMOS
        result = infer(base, facts)
        if tsv
            description = chomp(sprint(print_result, base, result))
            println(io, title, '\t', length(facts), '\t', replace(description, '\n' => ' '))
        else
            println(io, title)
            println(io, "Факты: ", describe(base, facts), ".")
            print_result(io, base, result)
            println(io)
        end
    end
end

function parse_observations(entries)
    facts = Pair{Symbol,Symbol}[]
    for entry in entries
        parts = split(entry, '='; limit=2)
        if length(parts) != 2 || any(isempty, parts)
            throw(ArgumentError("Ожидается критерий=значение: $entry."))
        end
        push!(facts, Symbol(parts[1]) => Symbol(parts[2]))
    end
    return facts
end

function print_criteria(io, base)
    for criterion in base.criteria
        options = join((string(key, " — ", title) for (key, title) in criterion.options), ", ")
        println(io, criterion.key, " (", criterion.title, "): ", options)
    end
end

function interactive(input, output, base)
    observations = Pair{Symbol,Symbol}[]
    println(output, "Экспертная система фотостудии.")
    while true
        result = infer(base, observations)
        print_result(output, base, result)
        result.status == :unknown || return
        criterion = result.criterion
        for (index, (_, title)) in enumerate(criterion.options)
            println(output, "  ", index, ". ", title)
        end
        println(output, "Введите номер варианта или 0 для выхода.")
        flush(output)
        eof(input) && return
        answer = tryparse(Int, strip(readline(input)))
        answer == 0 && return
        if isnothing(answer) || !(1 <= answer <= length(criterion.options))
            println(output, "Выберите номер из списка.")
            continue
        end
        push!(observations, criterion.key => first(criterion.options[answer]))
    end
end

function main(args)
    base = photo_knowledge_base()
    if isempty(args) || args == ["--demo"]
        demo(stdout, base)
    elseif args == ["--demo-tsv"]
        demo(stdout, base; tsv=true)
    elseif args == ["--interactive"]
        interactive(stdin, stdout, base)
    elseif args == ["--criteria"]
        print_criteria(stdout, base)
    elseif first(args) == "--order"
        observations = parse_observations(args[2:end])
        print_result(stdout, base, infer(base, observations))
    else
        println("Использование: julia solve.jl [--demo | --demo-tsv | --interactive | --criteria | --order критерий=значение …]")
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    try
        main(ARGS)
    catch error
        error isa ArgumentError || rethrow()
        showerror(stderr, error)
        println(stderr)
        exit(1)
    end
end
