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

        # Count fence segments. A segment is identified by its
        # top left corner and a flag indicating if its a vertical segment
        segments = Set{Tuple{Int, Int, Bool}}()
        poles = Set{Tuple{Int, Int}}()

        # Find fence segments and the total area
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
                push!(segments, (x, y, true))
            elseif (nx, ny) ∉ visited
                push!(queue, (nx, ny))
            end

            # Try to expand south
            nx = x + 1
            ny = y
            if !in_bounds(m, nx, ny) || m[nx, ny] != c
                push!(segments, (x + 1, y, true))
            elseif (nx, ny) ∉ visited
                push!(queue, (nx, ny))
            end

            # Try to expand east
            nx = x
            ny = y - 1
            if !in_bounds(m, nx, ny) || m[nx, ny] != c
                push!(segments, (x, y, false))
            elseif (nx, ny) ∉ visited
                push!(queue, (nx, ny))
            end

            # Try to expand west
            nx = x
            ny = y + 1
            if !in_bounds(m, nx, ny) || m[nx, ny] != c
                push!(segments, (x, y + 1, false))
            elseif (nx, ny) ∉ visited
                push!(queue, (nx, ny))
            end
        end

        # println("$segments")

        # Detect sides
        sides = 0
        seg_q = copy(segments)
        while !isempty(seg_q)
            x, y, is_vertical = pop!(seg_q)
            # println("\t$x $y $is_vertical")

            if is_vertical
                # Try to go leftwards, unless it's an intersection with a horizontal fence
                ny = y - 1
                while (x, ny, true) ∈ seg_q && (x, ny+1, false) ∉ segments && (x-1, ny+1, false) ∉ segments
                    # println("\t\t$x $ny $is_vertical")
                    delete!(seg_q, (x, ny, true))
                    ny -= 1
                end

                # Try to go rightwards, unless it's an intersection with a horizontal fence
                ny = y + 1
                while (x, ny, true) ∈ seg_q && (x, ny, false) ∉ segments && (x-1, ny, false) ∉ segments
                    # println("\t\t$x $ny $is_vertical")
                    delete!(seg_q, (x, ny, true))
                    ny += 1
                end
            else
                # Try to go upwards, unless it's an intersection with a vertical fence
                nx = x - 1
                while (nx, y, false) ∈ seg_q && (nx+1, y, true) ∉ segments && (nx+1, y-1, true) ∉ segments
                    # println("\t\t$nx $y $is_vertical")
                    delete!(seg_q, (nx, y, false))
                    nx -= 1
                end

                # Try to go downwards, unless it's an intersection with a vertical fence
                nx = x + 1
                while (nx, y, false) ∈ seg_q && (nx, y, true) ∉ segments && (nx, y-1, true) ∉ segments
                    # println("\t\t$nx $y $is_vertical")
                    delete!(seg_q, (nx, y, false))
                    nx += 1
                end
            end

            sides += 1
        end

        # println("New area at $i $j ($c) area=$area sides=$sides")
        result += area * sides
    end

    display(result)
end

main()
