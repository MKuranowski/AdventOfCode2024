# © Copyright 2024 Mikołaj Kuranowski
# SPDX-License-Identifier: MIT

function number(d; base = 10)::Int
    sum(d[i] * base^(i - 1) for i in eachindex(d))
end

function load_input()::Vector{Int}
    readchomp(stdin) |> split .|> x -> parse(Int, x)
end

function step!(s::Vector{Int})
    i = 1
    while i <= length(s)
        new_stone = false
        d = digits(s[i])
        if s[i] == 0
            s[i] = 1
        elseif length(d) % 2 == 0
            new_stone = true
            middle = length(d) ÷ 2
            s[i] = number(d[middle+1:end])
            insert!(s, i + 1, number(d[begin:middle]))
        else
            s[i] *= 2024
        end
        i += new_stone ? 2 : 1
    end
end

function main()
    s = load_input()
    for _ in 1:75
        step!(s)
    end
    display(length(s))
end

main()
