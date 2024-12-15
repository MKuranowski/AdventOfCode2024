# © Copyright 2024 Mikołaj Kuranowski
# SPDX-License-Identifier: MIT

@enum Move UP RIGHT DOWN LEFT

function read_input()::Tuple{Matrix{Char}, Vector{Move}, Tuple{Int, Int}}
    board = nothing
    row = 1
    moves = Move[]
    robot = nothing

    for line in eachline()
        if startswith(line, '#')
            if isnothing(board)
                board = fill('.', length(line), length(line))
            end
            for (col, c) in enumerate(line)
                board[row, col] = c
                if c == '@'
                    @assert isnothing(robot)
                    robot = row, col
                end
            end
            row += 1
        else
            for c in line
                if c == '^'
                    push!(moves, UP)
                elseif c == '>'
                    push!(moves, RIGHT)
                elseif c == 'v'
                    push!(moves, DOWN)
                elseif c == '<'
                    push!(moves, LEFT)
                end
            end
        end
    end

    @assert !isnothing(board)
    @assert !isnothing(robot)
    board, moves, robot
end

function move!(board::Matrix{Char}, robot::Tuple{Int, Int}, m::Move)::Tuple{Int, Int}
    i, j = robot
    @assert board[i, j] == '@'

    if m == UP
        empty = findprev(c -> c == '.' || c == '#', board[:, j], i)
        if !isnothing(empty) && board[empty, j] == '.'
            for x in empty:i-1
                board[x, j] = board[x+1, j]
            end
            board[i, j] = '.'
            return i-1, j
        end
    elseif m == DOWN
        empty = findnext(c -> c == '.' || c == '#', board[:, j], i)
        if !isnothing(empty) && board[empty, j] == '.'
            for x in range(empty, i+1, step=-1)
                board[x, j] = board[x-1, j]
            end
            board[i, j] = '.'
            return i+1, j
        end
    elseif m == LEFT
        empty = findprev(c -> c == '.' || c == '#', board[i, :], j)
        if !isnothing(empty) && board[i, empty] == '.'
            for y in empty:j-1
                board[i, y] = board[i, y+1]
            end
            board[i, j] = '.'
            return i, j-1
        end
    elseif m == RIGHT
        empty = findnext(c -> c == '.' || c == '#', board[i, :], j)
        if !isnothing(empty) && board[i, empty] == '.'
            for y in range(empty, j+1, step=-1)
                board[i, y] = board[i, y-1]
            end
            board[i, j] = '.'
            return i, j+1
        end
    else
        @assert false "unexpected Move value"
    end
    return robot
end

function main()
    board, moves, robot = read_input()
    for move in moves
        robot = move!(board, robot, move)
    end

    result = 0
    rows, cols = size(board)
    for i in 1:rows, j in 1:cols
        if board[i, j] == 'O'
            result += 100 * (i - 1) + j - 1
        end
    end

    display(result)
end

main()
