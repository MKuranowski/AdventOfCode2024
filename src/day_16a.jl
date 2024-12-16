# © Copyright 2024 Mikołaj Kuranowski
# SPDX-License-Identifier: MIT

include("day_16.jl")

function main()
    maze, start, finish = read_input()
    cost = find_cheapest(maze, start, finish)
    display(cost)
end

main()
