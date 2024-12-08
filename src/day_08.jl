# © Copyright 2024 Mikołaj Kuranowski
# SPDX-License-Identifier: MIT

function load_input()
    antennas = Dict{Char, Vector{Tuple{Int, Int}}}()
    bound = 0
    for (i, line) in enumerate(eachline())
        for (j, c) in enumerate(line)
            if c != '.' && c != '#'
                push!(get!(antennas, c, Vector{Tuple{Int, Int}}()), (i, j))
            end
        end
        bound = i
    end
    antennas, bound
end

function line_from_points(x1, y1, x2, y2)
    @assert x1 != x2
    a = (y1 - y2) / (x1 - x2)
    b = y1 - a * x1
    return a, b
end
