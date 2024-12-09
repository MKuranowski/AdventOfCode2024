# © Copyright 2024 Mikołaj Kuranowski
# SPDX-License-Identifier: MIT

const Disk = Vector{Union{Nothing, Int}}

function load_input()::Disk
    disk = Disk()
    file_id = 0
    is_file = true

    for line in eachline(), c in line
        blocks = parse(Int, c)

        elem = is_file ? file_id : nothing
        for _ in 1:blocks
            push!(disk, elem)
        end

        file_id += is_file ? 1 : 0
        is_file = !is_file
    end

    disk
end

function compact!(d::Disk)
    l = findfirst(isnothing, d)
    r = findlast(!isnothing, d)
    while !isnothing(l) && !isnothing(r) && l < r
        d[l], d[r] = d[r], d[l]
        l = findnext(isnothing, d, l + 1)
        r = findprev(!isnothing, d, r - 1)
    end
end

disk = load_input()
compact!(disk)
result = sum(!isnothing(id) ? (idx - 1) * id : 0 for (idx, id) in enumerate(disk))
display(result)
