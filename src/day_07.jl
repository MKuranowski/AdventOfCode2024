# © Copyright 2024 Mikołaj Kuranowski
# SPDX-License-Identifier: MIT

function load_input_line(l::AbstractString)::Tuple{Int, Vector{Int}}
    numbers = eachmatch(r"[0-9]+", l) .|> m -> parse(Int, m.match)
    target = popat!(numbers, 1)
    return target, numbers
end

function load_input()::Vector{Tuple{Int, Vector{Int}}}
    eachline() .|> load_input_line
end
