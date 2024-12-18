# © Copyright 2024 Mikołaj Kuranowski
# SPDX-License-Identifier: MIT

using DataStructures: PriorityQueue, dequeue_pair!, setindex!

const Position = Tuple{Int, Int}

const TEST = false
const CORNER = TEST ? 6 : 70
const LIMIT = TEST ? 12 : 1024

const NEIGHBORS = [(-1, 0), (1, 0), (0, -1), (0, 1)]

function read_input_line(line::AbstractString)::Position
    x, y = split(line, ',', keepempty=false) .|> s -> parse(Int, s)
    x, y
end

function read_input(limit::Int = typemax(Int))::Set{Position}
    Set(Iterators.take(eachline(), limit) .|> read_input_line)
end

function in_bounds(p::Position)::Bool
    p[1] >= 0 && p[1] <= CORNER && p[2] >= 0 && p[2] <= CORNER
end

function find_shortest_path(obstacles::AbstractSet{Position})::Int
    @assert (0, 0) ∉ obstacles
    @assert (CORNER, CORNER) ∉ obstacles

    costs = Dict{Position, Int}((0, 0) => 0)
    queue = PriorityQueue{Position, Int}((0, 0) => 0)

    while !isempty(queue)
        p, cost = dequeue_pair!(queue)

        if p == (CORNER, CORNER)
            return cost
        end

        if cost > get(costs, p, typemax(Int))
            continue
        end

        for (dx, dy) in NEIGHBORS
            np = (p[1] + dx, p[2] + dy)
            if !in_bounds(np) || np ∈ obstacles
                continue
            end

            alt_cost = cost + 1
            known_cost = get(costs, np, typemax(Int))
            if alt_cost < known_cost
                costs[np] = alt_cost
                setindex!(queue, alt_cost, np)
            end
        end
    end

    error("No path found")
end

obstacles = read_input(LIMIT)
result = find_shortest_path(obstacles)
println(result)
