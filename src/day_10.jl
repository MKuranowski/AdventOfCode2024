# © Copyright 2024 Mikołaj Kuranowski
# SPDX-License-Identifier: MIT

function read_matrix()::Matrix{Int32}
    input = readlines()
    rows = length(input)
    columns = maximum(length.(input))
    matrix = fill(Int32(-1), rows, columns)
    for (i, line) in enumerate(input)
        for (j, char) in enumerate(line)
            matrix[i, j] = parse(Int32, char)
        end
    end
    matrix
end

function in_bounds(m, i, j)
    rows, cols = size(m)
    i >= 1 && i <= rows && j >= 1 && j <= cols
end
