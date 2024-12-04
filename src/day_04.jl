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
