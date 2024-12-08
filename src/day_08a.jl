# © Copyright 2024 Mikołaj Kuranowski
# SPDX-License-Identifier: MIT

include("day_08.jl")

function main()
    antennas, bound = load_input()
    antinodes = Set{Tuple{Int, Int}}()

    for (frequency, points) in pairs(antennas)
        for i in 1:length(points), j in (i + 1):length(points)
            if points[i][1] < points[j][1]
                x1, y1 = points[i]
                x2, y2 = points[j]
            else
                x1, y1 = points[j]
                x2, y2 = points[i]
            end

            a, b = line_from_points(x1, y1, x2, y2)
            dx = x2 - x1

            ax1 = x1 - dx
            ay1 = round(Int, a * ax1 + b)
            if ax1 >= 1 && ax1 <= bound && ay1 >= 1 && ay1 <= bound
                push!(antinodes, (ax1, ay1))
            end

            ax2 = x2 + dx
            ay2 = round(Int, a * ax2 + b)
            if ax2 >= 1 && ax2 <= bound && ay2 >= 1 && ay2 <= bound
                push!(antinodes, (ax2, ay2))
            end
        end
    end

    display(length(antinodes))
end

main()
