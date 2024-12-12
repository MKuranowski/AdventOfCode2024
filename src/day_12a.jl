# © Copyright 2024 Mikołaj Kuranowski
# SPDX-License-Identifier: MIT

function read_matrix()::Matrix{Char}
    input = readlines()
    rows = length(input)
    columns = maximum(length.(input))
    matrix = fill('\0', rows, columns)
    for (i, line) in enumerate(input)
        for (j, char) in enumerate(line)
            matrix[i, j] = char
        end
    end
    matrix
end

function in_bounds(m, i, j)
    rows, cols = size(m)
    i >= 1 && i <= rows && j >= 1 && j <= cols
end

function main()
    m = read_matrix()
    visited = Set{Tuple{Int, Int}}()
    rows, cols = size(m)
    result = 0

    for i in 1:rows, j in 1:cols
        # Not a new plot - skip
        if (i, j) ∈ visited
            continue
        end

        c = m[i, j]
        queue = Vector{Tuple{Int, Int}}()
        push!(queue, (i, j))
        area = 0
        perimeter = 0

        while !isempty(queue)
            x, y = pop!(queue)
            if (x, y) ∈ visited
                continue
            end
            push!(visited, (x, y))
            area += 1

            # Try to expand north
            nx = x - 1
            ny = y
            if !in_bounds(m, nx, ny) || m[nx, ny] != c
                perimeter += 1
            elseif (nx, ny) ∉ visited
                push!(queue, (nx, ny))
            end

            # Try to expand south
            nx = x + 1
            ny = y
            if !in_bounds(m, nx, ny) || m[nx, ny] != c
                perimeter += 1
            elseif (nx, ny) ∉ visited
                push!(queue, (nx, ny))
            end

            # Try to expand east
            nx = x
            ny = y - 1
            if !in_bounds(m, nx, ny) || m[nx, ny] != c
                perimeter += 1
            elseif (nx, ny) ∉ visited
                push!(queue, (nx, ny))
            end

            # Try to expand west
            nx = x
            ny = y + 1
            if !in_bounds(m, nx, ny) || m[nx, ny] != c
                perimeter += 1
            elseif (nx, ny) ∉ visited
                push!(queue, (nx, ny))
            end
        end

        result += area * perimeter
    end

    display(result)
end

main()
