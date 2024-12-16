# © Copyright 2024 Mikołaj Kuranowski
# SPDX-License-Identifier: MIT

using DataStructures: PriorityQueue, dequeue_pair!


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

function try_push!(
    m::Maze,
    queue::PriorityQueue{Position, Int},
    costs::Dict{Position, Int},
    i::Int,
    j::Int,
    d::Direction,
    previous_cost::Int,
    previous_d::Direction,
)
    if m[i, j] == '#'
        return
    end

    cost = previous_cost + 1 + rotation_cost(d, previous_d)
    if !haskey(costs, (i, j, d)) || costs[(i, j, d)] > cost
        costs[(i, j, d)] = cost
        setindex!(queue, cost, (i, j, d))
    end
end

function find_cheapest(m::Maze, start::Position, finish::Coordinates)::Int
    costs = Dict{Position, Int}(start => 0)
    queue = PriorityQueue{Position, Int}(start => 0)

    while !isempty(queue)
        (i, j, direction), cost = dequeue_pair!(queue)

        # Check if the end was reached
        if (i, j) == finish
            return cost
        end

        # Skip if a cheaper path from start to (i, j) was already explored
        if cost > get(costs, (i, j, direction), Inf)
            continue
        end

        try_push!(m, queue, costs, i-1, j, NORTH, cost, direction)
        try_push!(m, queue, costs, i+1, j, SOUTH, cost, direction)
        try_push!(m, queue, costs, i, j-1, WEST, cost, direction)
        try_push!(m, queue, costs, i, j+1, EAST, cost, direction)
    end

    error("no path from start to finish")
end
