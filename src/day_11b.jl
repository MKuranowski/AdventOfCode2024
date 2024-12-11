# © Copyright 2024 Mikołaj Kuranowski
# SPDX-License-Identifier: MIT

function number(d; base = 10)::Int
    sum(d[i] * base^(i - 1) for i in eachindex(d))
end

function load_input()::Vector{Int}
    readchomp(stdin) |> split .|> x -> parse(Int, x)
end

function length_after_steps!(n::Int, steps::Int, cache::Dict{Tuple{Int, Int}, Int})::Int
    # Base recursion case
    if steps == 0
        return 1
    end

    # Check if result was cached
    cached = get(cache, (n, steps), nothing)
    if !isnothing(cached)
        return cached
    end

    # Calculate the length
    d = digits(n)
    result = if n == 0
        length_after_steps!(1, steps - 1, cache)
    elseif length(d) % 2 == 0
        middle = length(d) ÷ 2
        left = number(d[middle+1:end])
        right = number(d[begin:middle])
        length_after_steps!(left, steps - 1, cache) + length_after_steps!(right, steps - 1, cache)
    else
        length_after_steps!(n * 2024, steps - 1, cache)
    end

    # Insert result to cache
    cache[(n, steps)] = result

    return result
end

function main()
    s = load_input()
    cache = Dict{Tuple{Int, Int}, Int}()
    result = sum(length_after_steps!(n, 75, cache) for n in s)
    display(result)
end

main()
