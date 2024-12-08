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

            # Go towards decreasing x
            for ax in range(x1, 1, step=-dx)
                ay = round(Int, a * ax + b)
                if ax >= 1 && ax <= bound && ay >= 1 && ay <= bound
                    push!(antinodes, (ax, ay))
                end
            end

            # Go towards increasing x
            for ax in range(x2, bound, step=dx)
                ay = round(Int, a * ax + b)
                if ax >= 1 && ax <= bound && ay >= 1 && ay <= bound
                    push!(antinodes, (ax, ay))
                end
            end
        end
    end

    display(length(antinodes))
end

main()
