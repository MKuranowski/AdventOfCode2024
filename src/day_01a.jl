# © Copyright 2024 Mikołaj Kuranowski
# SPDX-License-Identifier: MIT

left = Vector{Int}()
right = Vector{Int}()

for line in eachline(ARGS[1])
    x = split(line, " ", keepempty=false)
    push!(left, parse(Int, x[1]))
    push!(right, parse(Int, x[2]))
end

sort!(left)
sort!(right)

result = sum(abs(a - b) for (a, b) in zip(left, right))
display(result)
