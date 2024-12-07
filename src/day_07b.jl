# © Copyright 2024 Mikołaj Kuranowski
# SPDX-License-Identifier: MIT

include("day_07.jl")


function concat(x::Int, y::Int)::Int
    parse(Int, string(x) * string(y))
end

function can_be_reached(target::Int, so_far::Int, rest::Vector{Int})::Bool
    if isempty(rest)
        return target == so_far
    end

    if so_far > target
        return false
    end

    return can_be_reached(target, so_far + rest[1], rest[2:end]) ||
        can_be_reached(target, so_far * rest[1], rest[2:end]) ||
        can_be_reached(target, concat(so_far, rest[1]), rest[2:end])
end

function can_be_reached(target::Int, rest::Vector{Int})::Bool
    can_be_reached(target, rest[1], rest[2:end])
end

result = sum(load_input() .|> input -> can_be_reached(input[1], input[2]) * input[1])
display(result)
