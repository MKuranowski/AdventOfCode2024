# © Copyright 2024 Mikołaj Kuranowski
# SPDX-License-Identifier: MIT

mutable struct Sector
    size::Int
    file_id::Union{Nothing, Int}
end

const Disk = Vector{Sector}

function load_input()::Disk
    disk = Disk()
    file_id = 0
    is_file = true

    for line in eachline(), c in line
        push!(disk, Sector(parse(Int, c), is_file ? file_id : nothing))
        file_id += is_file ? 1 : 0
        is_file = !is_file
    end

    disk
end

function compact!(disk::Disk)
    file = length(disk)
    while file >= 1
        # Flag to keep track whether we need to decrement `file`;
        # usually we do, unless the hole was bigger than a file,
        # replacing the 1 hole by 2 sectors (file and a hole).
        added_an_element = false

        # Check if d[file] is actually a file
        if !isnothing(disk[file].file_id)
            # Find the first hole that can fit the currently considered file
            hole = findfirst(
                s -> isnothing(s.file_id) && s.size >= disk[file].size,
                disk,
            )

            # Move the file to the hole, if one was found and is earlier on the disk
            if !isnothing(hole) && hole < file
                # Swap the file_ids
                disk[file].file_id, disk[hole].file_id = disk[hole].file_id, disk[file].file_id

                # Check if the hole was bigger than the file -
                # if that is the case, we need to add a smaller hole after the
                # newly moved file
                if disk[hole].size > disk[file].size
                    new_hole_size = disk[hole].size - disk[file].size
                    disk[hole].size = disk[file].size
                    insert!(disk, hole + 1, Sector(new_hole_size, nothing))
                    added_an_element = true
                end
            end
        end

        file -= added_an_element ? 0 : 1
    end
end

function checksum(disk::Disk)::Int
    result = 0
    i = 0
    for sector in disk
        for _ in 1:sector.size
            result += isnothing(sector.file_id) ? 0 : i * sector.file_id
            i += 1
        end
    end
    result
end

disk = load_input()
compact!(disk)
display(checksum(disk))
