# © Copyright 2024 Mikołaj Kuranowski
# SPDX-License-Identifier: MIT

function read_input()
    locks = Vector{UInt8}[]
    keys = Vector{UInt8}[]

    for image in split(read(stdin, String), "\n\n")
        lines = split(image, '\n', keepempty=false)
        @assert all(length(line) == 5 for line in lines) "sus $lines"
        is_lock = lines[1][1] == '#'
        heights = zeros(Int8, 5)
        for col in 1:5
            for h in 5:-1:1
                row = is_lock ? h+1 : 7-h
                if lines[row][col] == '#'
                    heights[col] = UInt8(h)
                    break
                end
            end
        end
        push!(is_lock ? locks : keys, heights)
    end

    locks, keys
end

function main()
    locks, keys = read_input()
    fits = sum(
        all(lock .+ key .<= 5)
        for lock in locks, key in keys
    )
    println(fits)
end

main()
