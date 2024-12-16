# © Copyright 2024 Mikołaj Kuranowski
# SPDX-License-Identifier: MIT

using DataStructures: PriorityQueue, dequeue_pair!

include("day_16.jl")

function move(i::Int, j::Int, d::Direction)::Tuple{Int, Int}
    if d == NORTH
        i-1, j
    elseif d == SOUTH
        i+1, j
    elseif d == WEST
        i, j-1
    elseif d == EAST
        i, j+1
    else
        error("unexpected direction: $d")
    end
end

function find_all_visited(prev::Dict{Position, Set{Position}}, finish::Coordinates)::Set{Coordinates}
    v = Set{Coordinates}()
    q = [(finish[1], finish[2], d) for d in instances(Direction)]

    while !isempty(q)
        i, j, d = pop!(q)
        push!(v, (i, j))
        if haskey(prev, (i, j, d))
            push!(q, prev[(i, j, d)]...)
        end
    end

    v
end

function find_best_tiles(m::Maze, start::Position, finish::Coordinates)::Set{Coordinates}
    cheapest_path = nothing
    costs = Dict{Position, Int}(start => 0)
    prev = Dict{Position, Set{Position}}()
    queue = PriorityQueue{Position, Int}(start => 0)

    while !isempty(queue)
        (i, j, d), cost = dequeue_pair!(queue)

        # Don't explore if the cheapest path's cost has been exceeded
        if (!isnothing(cheapest_path) && cost > cheapest_path) || cost > get(costs, (i, j, d), typemax(Int))
            continue
        end

        # End reached - stop exploring
        if (i, j) == finish
            if isnothing(cheapest_path)
                cheapest_path = cost
            else
                @assert cost == cheapest_path
            end
            continue
        end

        # Try to add neighbors
        for nd in instances(Direction)
            # Don't turn around - that node has already been visited
            rot_cost = rotation_cost(d, nd)
            if rot_cost == 2000
                continue
            end

            # Don't move into a wall
            ni, nj = move(i, j, nd)
            if m[ni, nj] == '#'
                continue
            end

            known_cost = get(costs, (ni, nj, nd), typemax(Int))
            alt_cost = cost + 1 + rot_cost
            if known_cost < alt_cost
                # Cheaper path to this node - don't explore
                continue
            elseif known_cost == alt_cost
                # We know of a path of the same cost to this node - just record it in `prev`
                push!(prev[(ni, nj, nd)], (i, j, d))
            else
                # This is the cheapest path to this node - overwrite `prev` and continue expanding
                prev[(ni, nj, nd)] = Set{Position}([(i,j,d)])
                costs[(ni, nj, nd)] = alt_cost
                setindex!(queue, alt_cost, (ni, nj, nd))
            end
        end
    end

    find_all_visited(prev, finish)
end

function main()
    maze, start, finish = read_input()
    result = find_best_tiles(maze, start, finish)
    display(length(result))
end

main()
