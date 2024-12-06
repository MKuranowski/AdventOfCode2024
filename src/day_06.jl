# © Copyright 2024 Mikołaj Kuranowski
# SPDX-License-Identifier: MIT

@enum Direction N E S W

function cycle(d::Direction)::Direction
    if d == N
        E
    elseif d == E
        S
    elseif d == S
        W
    else  # d == W
        N
    end
end

function move(i::Int, j::Int, d::Direction)::Tuple{Int, Int}
    if d == N
        i - 1, j
    elseif d == E
        i, j + 1
    elseif d == S
        i + 1, j
    else # d == W
        i, j - 1
    end
end

function read_matrix()::Matrix{Char}
    input = readlines()
    rows = length(input)
    columns = maximum(length.(input))
    matrix = fill('.', rows, columns)
    for (i, line) in enumerate(input)
        for (j, char) in enumerate(line)
            matrix[i, j] = char
        end
    end
    matrix
end

function find_start(m::Matrix{Char})::Tuple{Int, Int}
    rows, cols = size(m)
    for i in 1:rows, j in 1:cols
        if m[i, j] == '^'
            return i, j
        end
    end
    error("No '^' in input matrix")
end

function in_bounds(m::AbstractMatrix, i::Integer, j::Integer)::Bool
    rows, cols = size(m)
    i >= 1 && i <= rows && j >= 1 && j <= cols
end
