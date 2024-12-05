# © Copyright 2024 Mikołaj Kuranowski
# SPDX-License-Identifier: MIT

const Rule = Tuple{Int32, Int32}
const Rules = Vector{Rule}

const Update = Dict{Int32, Int32}
const Updates = Vector{Update}

function load_input()::Tuple{Rules, Updates}
    rules::Rules = []
    updates::Updates = []

    for line in eachline()
        if line == ""
            continue
        elseif '|' ∈ line
            x = split(line, '|')
            a = parse(Int32, x[1])
            b = parse(Int32, x[2])
            push!(rules, (a, b))
        elseif ',' ∈ line
            update::Update = Dict(
                parse(Int32, page_str) => Int32(i)
                for (i, page_str) in enumerate(eachsplit(line, ','))
            )
            push!(updates, update)
        end
    end

    (rules, updates)
end

function conforms(r::Rule, u::Update)::Bool
    a = get(u, r[1], nothing)
    b = get(u, r[2], nothing)
    isnothing(a) || isnothing(b) || a < b
end

function conforms(r::Rules, u::Update)::Bool
    all(conforms(rule, u) for rule in r)
end

function find_middle(u::Update)::Int32
    mid = cld((u |> values |> maximum), 2)
    for (number, index) in u
        if index == mid
            return number
        end
    end
    error("Update without a middle value; expected idx=$mid in $u")
end
