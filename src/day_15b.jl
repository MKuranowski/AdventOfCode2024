# © Copyright 2024 Mikołaj Kuranowski
# SPDX-License-Identifier: MIT

function read_input()::Tuple{Matrix{Char}, Vector{Char}, Tuple{Int, Int}}
    board = nothing
    row = 1
    moves = Char[]
    robot = nothing

    for line in eachline()
        if startswith(line, '#')
            if isnothing(board)
                board = fill('.', length(line), 2 * length(line))
            end
            for (col, c) in enumerate(line)
                if c == '@'
                    @assert isnothing(robot)
                    robot = row, 2col-1
                    board[row, 2col-1] = '@'
                elseif c == 'O'
                    board[row, 2col-1] = '['
                    board[row, 2col] = ']'
                elseif c == '#'
                    board[row, 2col-1] = '#'
                    board[row, 2col] = '#'
                end
            end
            row += 1
        else
            push!(moves, line...)
        end
    end

    @assert !isnothing(board)
    @assert !isnothing(robot)
    board, moves, robot
end

function try_move_left!(board::Matrix{Char}, i::Int, j::Int)::Bool
    if board[i, j] == '#'
        return false
    elseif board[i, j] == '.'
        return true
    elseif board[i, j] == ']'
        @assert board[i, j-1] == '['
        if try_move_left!(board, i, j-2)
            @assert board[i, j-2] == '.'
            board[i, j-2] = '['
            board[i, j-1] = ']'
            board[i, j] = '.'
            return true
        else
            return false
        end
    elseif board[i, j] == '['
        @error "can't move left on left half of a box"
    elseif board[i, j] == '@'
        if try_move_left!(board, i, j-1)
            @assert board[i, j-1] == '.'
            board[i, j-1] = '@'
            board[i, j] = '.'
            return true
        else
            return false
        end
    else
        @error "unexpected board char $(board[i, j]) at $i, $j"
    end
end

function try_move_right!(board::Matrix{Char}, i::Int, j::Int)::Bool
    if board[i, j] == '#'
        return false
    elseif board[i, j] == '.'
        return true
    elseif board[i, j] == '['
        @assert board[i, j+1] == ']'
        if try_move_right!(board, i, j+2)
            @assert board[i, j+2] == '.'
            board[i, j] = '.'
            board[i, j+1] = '['
            board[i, j+2] = ']'
            return true
        else
            return false
        end
    elseif board[i, j] == ']'
        @error "can't move right on right half of a box"
    elseif board[i, j] == '@'
        if try_move_right!(board, i, j+1)
            @assert board[i, j+1] == '.'
            board[i, j] = '.'
            board[i, j+1] = '@'
            return true
        else
            return false
        end
    else
        @error "unexpected board char $(board[i, j]) at $i, $j"
    end
end

function can_move_vertically(board::Matrix{Char}, i::Int, j::Int, di::Int)::Bool
    if board[i, j] == '#'
        return false
    elseif board[i, j] == '.'
        return true
    elseif board[i, j] == '['
        @assert board[i, j+1] == ']'
        return can_move_vertically(board, i+di, j, di) && can_move_vertically(board, i+di, j+1, di)
    elseif board[i, j] == ']'
        @assert board[i, j-1] == '['
        return can_move_vertically(board, i+di, j-1, di) && can_move_vertically(board, i+di, j, di)
    elseif board[i, j] == '@'
        return can_move_vertically(board, i+di, j, di)
    else
        @error "unexpected board char $(board[i, j]) at $i, $j"
    end
end

function do_move_vertically!(board::Matrix{Char}, i::Int, j::Int, di::Int)::Nothing
    if board[i, j] == '#'
        @error "do_move_up! can't move up - hit a wall"
    elseif board[i, j] == '.'
    elseif board[i, j] == '['
        @assert board[i, j+1] == ']'
        do_move_vertically!(board, i+di, j, di)
        do_move_vertically!(board, i+di, j+1, di)
        @assert board[i+di, j] == '.'
        @assert board[i+di, j+1] == '.'
        board[i+di, j] = '['
        board[i+di, j+1] = ']'
        board[i, j] = '.'
        board[i, j+1] = '.'
    elseif board[i, j] == ']'
        @assert board[i, j-1] == '['
        do_move_vertically!(board, i+di, j-1, di)
        do_move_vertically!(board, i+di, j, di)
        @assert board[i+di, j-1] == '.'
        @assert board[i+di, j] == '.'
        board[i+di, j-1] = '['
        board[i+di, j] = ']'
        board[i, j-1] = '.'
        board[i, j] = '.'
    elseif board[i, j] == '@'
        do_move_vertically!(board, i+di, j, di)
        @assert board[i+di, j] == '.'
        board[i+di, j] = '@'
        board[i, j] = '.'
    else
        @error "unexpected board char $(board[i, j]) at $i, $j"
    end
    return nothing
end

function try_move_up!(board::Matrix{Char}, i::Int, j::Int)::Bool
    if can_move_vertically(board, i, j, -1)
        do_move_vertically!(board, i, j, -1)
        return true
    else
        return false
    end
end

function try_move_down!(board::Matrix{Char}, i::Int, j::Int)::Bool
    if can_move_vertically(board, i, j, 1)
        do_move_vertically!(board, i, j, 1)
        return true
    else
        return false
    end
end

function move!(board::Matrix{Char}, robot::Tuple{Int, Int}, m::Char)::Tuple{Int, Int}
    i, j = robot
    @assert board[i, j] == '@'
    if m == '^'
        try_move_up!(board, i, j) ? (i-1, j) : (i, j)
    elseif m == 'v'
        try_move_down!(board, i, j) ? (i+1, j) : (i, j)
    elseif m == '<'
        try_move_left!(board, i, j) ? (i, j-1) : (i, j)
    elseif m == '>'
        try_move_right!(board, i, j) ? (i, j+1) : (i, j)
    else
        @error "invalid move: $m"
    end
end

function main()
    board, moves, robot = read_input()
    for move in moves
        robot = move!(board, robot, move)
    end

    result = 0
    rows, cols = size(board)
    for i in 1:rows, j in 1:cols
        if board[i, j] == '['
            result += 100 * (i - 1) + j - 1
        end
    end
    display(result)
end

main()
