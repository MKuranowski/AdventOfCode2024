# © Copyright 2024 Mikołaj Kuranowski
# SPDX-License-Identifier: MIT

left = Dict{Int, Int}()
right = Dict{Int, Int}()

for line in eachline()
    x = split(line, " ", keepempty=false)

    a = parse(Int, x[1])
    get!(left, a, 0)
    left[a] += 1

    b = parse(Int, x[2])
    get!(right, b, 0)
    right[b] += 1
end

result = sum(
    number * left_count * get(right, number, 0)
    for (number, left_count) in pairs(left)
)
display(result)
