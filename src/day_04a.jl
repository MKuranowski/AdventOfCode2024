# © Copyright 2024 Mikołaj Kuranowski
# SPDX-License-Identifier: MIT

include("day_04.jl")

@enum Direction begin
    NW
    N
    NE
    W
    E
    SW
    S
    SE
end

struct QueueElement
    pos::Tuple{Int, Int}
    dir::Direction
end

function step(e::QueueElement)::QueueElement
    x = if e.dir == NW || e.dir == N || e.dir == NE
            e.pos[1] - 1
    elseif e.dir == E || e.dir == W
        e.pos[1]
    else # e.dir == SW || e.dir == S || e.dir == SE
        e.pos[1] + 1
    end

    y = if e.dir == NW || e.dir == W || e.dir == SW
        e.pos[2] - 1
    elseif e.dir == N || e.dir == S
        e.pos[2]
    else # e.dir == NE || e.dir == E || e.dir == SE
        e.pos[2] + 1
    end

    return QueueElement((x, y), e.dir)
end

function try_push!(q::Vector{QueueElement}, m::Matrix{Char}, c::Char, e::Union{Nothing, QueueElement})
    # Check if new element exists
    if isnothing(e)
        return
    end

    # Check if the index is valid
    rows, cols = size(m)
    if e.pos[1] < 1 || e.pos[1] > rows || e.pos[2] < 1 || e.pos[2] > cols
        return
    end

    # Check if the neighbor follows the expected character
    if m[e.pos[1], e.pos[2]] != c
        return
    end

    # Add to queue
    push!(q, e)
end

function main()
    m::Matrix{Char} = read_matrix()
    rows, cols = size(m)
    q::Vector{QueueElement} = []
    result::Int = 0

    # Add all 'X' to the queue
    for i in 1:rows
        for j in 1:cols
            if m[i, j] == 'X'
                push!(q, QueueElement((i, j), NW))
                push!(q, QueueElement((i, j), N))
                push!(q, QueueElement((i, j), NE))
                push!(q, QueueElement((i, j), W))
                push!(q, QueueElement((i, j), E))
                push!(q, QueueElement((i, j), SW))
                push!(q, QueueElement((i, j), S))
                push!(q, QueueElement((i, j), SE))
            end
        end
    end

    # Expand the queue
    while !isempty(q)
        e = pop!(q)
        current_c = m[e.pos[1], e.pos[2]]

        # Check if the end of a word was reached
        if current_c == 'S'
            result += 1
            continue
        end

        # Select next character
        next_c = if current_c == 'A'
            'S'
        elseif current_c == 'M'
            'A'
        else # current_c == 'X'
            'M'
        end

        try_push!(q, m, next_c, step(e))
    end

    display(result)
end

main()
