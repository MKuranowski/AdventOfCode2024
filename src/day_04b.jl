# © Copyright 2024 Mikołaj Kuranowski
# SPDX-License-Identifier: MIT

include("day_04.jl")

function main()
    m = read_matrix()
    rows, cols = size(m)
    result = 0

    for i in 2:rows-1
        for j in 2:cols-1
            result += (
                m[i, j] == 'A'
                && ((m[i-1, j-1] == 'M' && m[i+1, j+1] == 'S')
                    || (m[i-1, j-1] == 'S' && m[i+1, j+1] == 'M'))
                && ((m[i-1, j+1] == 'M' && m[i+1, j-1] == 'S')
                    || (m[i-1, j+1] == 'S' && m[i+1, j-1] == 'M'))
            )
        end
    end

    display(result)
end

main()
