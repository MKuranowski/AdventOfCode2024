# © Copyright 2024 Mikołaj Kuranowski
# SPDX-License-Identifier: MIT

@enum Direction NORTH=0 EAST=1 SOUTH=2 WEST=3

const Maze = Matrix{Char}
const Position = Tuple{Int, Int, Direction}
const Coordinates = Tuple{Int, Int}

function rotation_cost(a::Direction, b::Direction)::Int
    if a == b
        0
    elseif abs(Int(a) - Int(b)) == 2
        2000
    else
        1000
    end
end

function read_input()::Tuple{Maze, Position, Coordinates}
    maze = nothing
    start = nothing
    finish = nothing

    for (i, line) in enumerate(eachline())
        if isnothing(maze)
            maze = fill('#', length(line), length(line))
        end
        for (j, c) in enumerate(line)
            if c == 'S'
                @assert isnothing(start)
                start = (i, j, EAST)
                maze[i, j] = '.'
            elseif c == 'E'
                @assert isnothing(finish)
                finish = (i, j)
                maze[i, j] = '.'
            else
                maze[i, j] = c
            end
        end
    end

    @assert !isnothing(maze)
    @assert !isnothing(start)
    @assert !isnothing(finish)
    return maze, start, finish
end
