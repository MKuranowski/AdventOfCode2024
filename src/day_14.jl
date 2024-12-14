# © Copyright 2024 Mikołaj Kuranowski
# SPDX-License-Identifier: MIT

const TEST = false
const BOUNDS = TEST ? [11, 7] : [101, 103]

struct Robot
    position::Vector{Int}
    velocity::Vector{Int}
end

function read_input_line(line::AbstractString)::Robot
    px, py, vx, vy = eachmatch(r"-?[0-9]+", line) .|> m -> parse(Int, m.match)
    return Robot([px, py], [vx, vy])
end

function read_input()::Vector{Robot}
    eachline() .|> read_input_line |> collect
end

function move(robot::Robot, steps::Int)::Robot
    Robot(
        mod.(robot.position + mod.(steps * robot.velocity, BOUNDS), BOUNDS),
        robot.velocity,
    )
end
