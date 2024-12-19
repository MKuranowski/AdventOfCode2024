# © Copyright 2024 Mikołaj Kuranowski
# SPDX-License-Identifier: MIT

function read_input()
    available = split(readline(), ", ")
    _ = readline()
    todo = readlines()
    available, todo
end

function solvable!(cache, design, available)
    if design == ""
        return 1  # Base recursion case
    end

    cached = get(cache, design, nothing)
    if isnothing(cached)
        result = sum(
            solvable!(cache, design[length(towel)+1:end], available)
            for towel in available
            if startswith(design, towel);
            init=0,
        )
        cache[design] = result
    else
        result = cached
    end
    return result
end

function main()
    available, designs = read_input()
    cache = Dict{String, Int}()
    result = sum(solvable!(cache, design, available) for design in designs)
    println(result)
end

main()
