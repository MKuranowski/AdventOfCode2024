# © Copyright 2024 Mikołaj Kuranowski
# SPDX-License-Identifier: MIT

using Base.Threads

include("day_06.jl")

function loops(m::Matrix{Char}, i::Int, j::Int)::Bool
    visited::Set{Tuple{Int, Int, Direction}} = Set()
    d = N

    while true
        # Check if this state was visited
        if (i, j, d) ∈ visited
            return true
        end
        push!(visited, (i, j, d))

        # Try to move in the current direction
        next_i, next_j = move(i, j, d)
        if !in_bounds(m, next_i, next_j)
            return false
        end

        # Avoid any obstacles
        while m[next_i, next_j] == '#'
            d = cycle(d)
            next_i, next_j = move(i, j, d)
            if !in_bounds(m, next_i, next_j)
                return false
            end
        end

        i, j = next_i, next_j
    end
end

function main()
    result = Atomic{Int}(0)
    m = read_matrix()
    start_i, start_j = find_start(m)

    Threads.@threads for i in eachindex(m)
        if m[i] == '.'
            m_copy = copy(m)
            m_copy[i] = '#'
            if loops(m_copy, start_i, start_j)
                atomic_add!(result, 1)
            end
        end
    end

    display(result[])
end

main()
