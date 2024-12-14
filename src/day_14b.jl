# © Copyright 2024 Mikołaj Kuranowski
# SPDX-License-Identifier: MIT

include("day_14.jl")

function find_cycle(step, side_length)
    side_length ÷ gcd(step, side_length)
end

function find_robot_cycle(position)
    lcm(find_cycle(position[1], BOUNDS[1]), find_cycle(position[2], BOUNDS[2]))
end

function find_board_cycle(robots)
    cycle = 1
    for robot in robots
        cycle = lcm(cycle, find_robot_cycle(robot.position))
    end
    cycle
end

function display_board(robots; io::IO = stdout)
    positions = Set(tuple(r.position...) for r in robots)
    for row in 0:BOUNDS[2]-1
        for col in 0:BOUNDS[1]-1
            print(io, (col, row) ∈ positions ? '#' : '.')
        end
        print(io, '\n')
    end
end

function has_christmas_tree(robots)::Union{String, Nothing}
    buffer = IOBuffer()
    display_board(robots, io=buffer)
    image = String(take!(buffer))
    contains(image, "#########") ? image : nothing
end

function main()
    robots = read_input()
    upper_bound = find_board_cycle(robots)

    for i in 1:upper_bound
        robots = robots .|> (r -> move(r, 1)) |> collect
        tree = has_christmas_tree(robots)
        if !isnothing(tree)
            println("$tree$i")
        end
    end
end

main()
