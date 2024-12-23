# © Copyright 2024 Mikołaj Kuranowski
# SPDX-License-Identifier: MIT

function read_input()::Dict{String, Set{String}}
    adj = Dict{String, Set{String}}()
    for line in eachline()
        a, b = split(line, '-', limit=2)
        push!(get!(Set{String}, adj, a), b)
        push!(get!(Set{String}, adj, b), a)
    end
    adj
end

function main()
    adj = read_input()
    cliques_with_t = Set{NTuple{3, String}}()
    for a in keys(adj)
        if !startswith(a, 't')
            continue
        end

        for b in adj[a]
            for c in adj[a] ∩ adj[b]
                clique = tuple(sort([a, b, c])...)
                push!(cliques_with_t, clique)
            end
        end
    end

    display(cliques_with_t)
    println(length(cliques_with_t))
end

main()
