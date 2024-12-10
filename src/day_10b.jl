# © Copyright 2024 Mikołaj Kuranowski
# SPDX-License-Identifier: MIT

include("day_10.jl")

function trailhead_score(m::Matrix{Int32}, start_i::Int, start_j::Int)::Int
    queue = Vector{Tuple{Int, Int}}()
    result = 0
    push!(queue, (start_i, start_j))

    while !isempty(queue)
        i, j = pop!(queue)
        next_h = m[i, j] + 1

        # Check if a hilltop was reached
        if next_h == 10
            result += 1
            continue
        end

        # Try to move north
        if in_bounds(m, i - 1, j) && m[i - 1, j] == next_h
            push!(queue, (i - 1, j))
        end

        # Try to move south
        if in_bounds(m, i + 1, j) && m[i + 1, j] == next_h
            push!(queue, (i + 1, j))
        end

        # Try to move west
        if in_bounds(m, i, j - 1) && m[i, j - 1] == next_h
            push!(queue, (i, j - 1))
        end

        # Try to move east
        if in_bounds(m, i, j + 1) && m[i, j + 1] == next_h
            push!(queue, (i, j + 1))
        end
    end

    result
end

matrix = read_matrix()
rows, cols = size(matrix)
result = sum(
    trailhead_score(matrix, i, j)
    for i in 1:rows, j in 1:cols
    if matrix[i, j] == 0
)
display(result)
