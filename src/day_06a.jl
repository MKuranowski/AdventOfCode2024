# © Copyright 2024 Mikołaj Kuranowski
# SPDX-License-Identifier: MIT

include("day_06.jl")

function main()
    m = read_matrix()
    visited::Set{Tuple{Int, Int}} = Set()

    i, j = find_start(m)
    d = N
    while true
        push!(visited, (i, j))

        next_i, next_j = move(i, j, d)
        if !in_bounds(m, next_i, next_j)
            break
        end

        while m[next_i, next_j] == '#'
            d = cycle(d)
            next_i, next_j = move(i, j, d)
            if !in_bounds(m, next_i, next_j)
                break
            end
        end

        i, j = next_i, next_j
    end

    display(length(visited))
end

main()
