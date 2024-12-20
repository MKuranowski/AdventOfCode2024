# © Copyright 2024 Mikołaj Kuranowski
# SPDX-License-Identifier: MIT

# NOTE: The input is just a single very long path

const Pos = Tuple{Int, Int}
const Maze = Set{Pos}

taxicab(a::Pos, b::Pos)::UInt32 = UInt32(abs(a[1] - b[1]) + abs(a[2] - b[2]))

function read_input()::Tuple{Maze, Pos, Pos}
    maze = Set{Pos}()
    start = nothing
    finish = nothing

    for (i, line) in enumerate(eachline())
        for (j, c) in enumerate(line)
            if c == 'S' || c == 'E' || c == '.'
                if c == 'S'
                    @assert isnothing(start)
                    start = i, j
                elseif c == 'E'
                    @assert isnothing(finish)
                    finish = i, j
                end
                push!(maze, (i, j))
            end
        end
    end

    @assert !isnothing(start)
    @assert !isnothing(finish)
    maze, start, finish
end

function calc_distances(maze::Maze, finish::Pos)::Dict{Pos, UInt32}
    head = finish
    cost = UInt32(0)
    distances = Dict{Pos, UInt32}()

    while !isnothing(head)
        distances[head] = cost
        cost += 1

        next_head = nothing
        for neighbor_delta in [(-1, 0), (1, 0), (0, -1), (0, 1)]
            neighbor = head .+ neighbor_delta
            if neighbor ∉ maze || haskey(distances, neighbor)
                continue
            else
                @assert isnothing(next_head) "maze contains multiple paths"
                next_head = neighbor
            end
        end
        head = next_head
    end

    @assert maze == Set(keys(distances)) "the whole maze should be visited by the walk"
    distances
end

function tally_shortcut_savings(
    maze::Maze,
    distances_to_end::Dict{Pos, UInt32},
    standard_dist::UInt32,
    max_cheat_dist::UInt32
)::Dict{UInt32, UInt32}
    savings_tally = Dict{UInt32, UInt32}()
    distance_to_start(pos) = length(maze) - distances_to_end[pos] - 1

    for a in maze, b in maze
        # Don't cheat by going backwards
        if distances_to_end[a] < distances_to_end[b]
            continue
        end

        shortcut_len = taxicab(a, b)
        if shortcut_len < 2 || shortcut_len > max_cheat_dist
            continue
        end

        # Calculate the alternative cost
        alt_dist = distance_to_start(a) + distances_to_end[b] + shortcut_len

        if alt_dist < standard_dist
            saving = standard_dist - alt_dist
            savings_tally[saving] = get(savings_tally, saving, 0) + 1
        end
    end

    savings_tally
end

function main_parametrized(saving_threshold, max_cheat_dist)
    maze, start, finish = read_input()
    distances = calc_distances(maze, finish)
    savings_tally = tally_shortcut_savings(maze, distances, distances[start], UInt32(max_cheat_dist))

    result = UInt32(0)
    for (saving, tally) in savings_tally
        if saving >= saving_threshold
            result += tally
        end
    end
    return result
end
