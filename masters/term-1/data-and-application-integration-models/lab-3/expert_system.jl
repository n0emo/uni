struct Criterion
    key::Symbol
    title::String
    options::Vector{Pair{Symbol,String}}
end

struct Rule
    id::Symbol
    conditions::Vector{Pair{Symbol,Symbol}}
    action::String
end

struct KnowledgeBase
    criteria::Vector{Criterion}
    rules::Vector{Rule}
    inconsistencies::Vector{Rule}
end

function assess(conditions, facts)
    missing = Symbol[]
    for (key, expected) in conditions
        if !haskey(facts, key)
            push!(missing, key)
        elseif facts[key] != expected
            return nothing
        end
    end
    return missing
end

function infer(base::KnowledgeBase, observations)
    facts = Dict{Symbol,Symbol}()
    criteria = Dict(criterion.key => criterion for criterion in base.criteria)

    for (key, value) in observations
        if !haskey(criteria, key)
            return (status=:invalid, message="Неизвестный критерий: $key.")
        end
        criterion = criteria[key]
        if !any(option -> first(option) == value, criterion.options)
            return (status=:invalid, message="Недопустимое значение $value для критерия «$(criterion.title)».")
        end
        if haskey(facts, key) && facts[key] != value
            return (status=:conflict, message="Для критерия «$(criterion.title)» указаны разные значения.")
        end
        facts[key] = value
    end

    for inconsistency in base.inconsistencies
        missing = assess(inconsistency.conditions, facts)
        if !isnothing(missing) && isempty(missing)
            return (status=:conflict, message=inconsistency.action)
        end
    end

    matches = Rule[]
    candidates = Tuple{Rule,Vector{Symbol}}[]
    for rule in base.rules
        missing = assess(rule.conditions, facts)
        if isnothing(missing)
            continue
        elseif isempty(missing)
            push!(matches, rule)
        else
            push!(candidates, (rule, missing))
        end
    end

    if length(matches) == 1
        return (status=:decision, rule=only(matches))
    elseif length(matches) > 1
        rules = join((rule.id for rule in matches), ", ")
        return (status=:conflict, message="Одновременно применимы несколько правил: $rules.")
    end

    for criterion in base.criteria
        needs_answer = any(criterion.key in missing for (_, missing) in candidates)
        if needs_answer
            alternatives = [rule for (rule, missing) in candidates if missing == [criterion.key]]
            return (status=:unknown, criterion=criterion, alternatives=alternatives)
        end
    end
    return (status=:uncovered, message="В базе знаний нет правила для такого сочетания фактов.")
end
