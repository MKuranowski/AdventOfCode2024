# © Copyright 2024 Mikołaj Kuranowski
# SPDX-License-Identifier: MIT

using DataStructures: PriorityQueue, dequeue_pair!

include("day_16.jl")

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

function main()
    maze, start, finish = read_input()
    cost = find_cheapest(maze, start, finish)
    display(cost)
end

main()
