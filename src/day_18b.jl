# © Copyright 2024 Mikołaj Kuranowski
# SPDX-License-Identifier: MIT

using DataStructures: PriorityQueue, dequeue_pair!, setindex!

const Position = Tuple{Int, Int}

const TEST = false
const CORNER = TEST ? 6 : 70

const NEIGHBORS = [(-1, 0), (1, 0), (0, -1), (0, 1)]

function read_input_line(line::AbstractString)::Position
    x, y = split(line, ',', keepempty=false) .|> s -> parse(Int, s)
    x, y
end

function read_input()::Vector{Position}
    eachline() .|> read_input_line |> collect
end

function in_bounds(p::Position)::Bool
    p[1] >= 0 && p[1] <= CORNER && p[2] >= 0 && p[2] <= CORNER
end

function path_exists(obstacles::AbstractSet{Position})::Bool
    @assert (0, 0) ∉ obstacles
    @assert (CORNER, CORNER) ∉ obstacles

    costs = Dict{Position, Int}((0, 0) => 0)
    queue = PriorityQueue{Position, Int}((0, 0) => 0)

    while !isempty(queue)
        p, cost = dequeue_pair!(queue)

        if p == (CORNER, CORNER)
            return true
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

    return false
end

function main()
    all_obstacles = read_input()
    for i in 1:length(all_obstacles)
        if !path_exists(Set(all_obstacles[begin:i]))
            println("$(all_obstacles[i][1]),$(all_obstacles[i][2])")
            return
        end
    end
    println("end is always reachable")
end

main()
