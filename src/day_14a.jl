# © Copyright 2024 Mikołaj Kuranowski
# SPDX-License-Identifier: MIT

include("day_14.jl")

const BOUNDS_HALF = BOUNDS .÷ 2

function quadrant(position::AbstractVector{<:Real})::Union{Int, Nothing}
    if position[1] < BOUNDS_HALF[1] && position[2] < BOUNDS_HALF[2]
        1
    elseif position[1] > BOUNDS_HALF[1] && position[2] < BOUNDS_HALF[2]
        2
    elseif position[1] < BOUNDS_HALF[1] && position[2] > BOUNDS_HALF[2]
        3
    elseif position[1] > BOUNDS_HALF[1] && position[2] > BOUNDS_HALF[2]
        4
    else
        nothing
    end
end

function safety_factor(robots)
    counts = [0, 0, 0, 0]
    for robot in robots
        q = quadrant(robot.position)
        if !isnothing(q)
            counts[q] += 1
        end
    end
    reduce(*, counts)
end

result = safety_factor(read_input() .|> r -> move(r, 100))
display(result)
