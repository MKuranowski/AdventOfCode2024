# © Copyright 2024 Mikołaj Kuranowski
# SPDX-License-Identifier: MIT

# Looking at the program, it is essentially:
# while a != 0
#   out( something(a & 15) )
#   a >>= 3
# end
#
# Because the topmost 3 bits dictate what is printed (the 4th bit is enforced by the previous
# iteration, or must be zero for the last iteration),
# this solution brute-forces the top 3 bits until the correct output is seen, and then recurses
# to brute-force next 3 bits, and so on, until the correct a value is found.

include("day_17.jl")

function reverse_a(c::Computer, i::Int)::Union{UInt64, Nothing}
    # Base recursion case
    if i == 0
        return c.a
    end

    for chunk in 0:7
        nc = copy(c)
        nc.a = (c.a << 3) | chunk
        output = run(nc).output

        if nc.prog[i:end] == output
            result = reverse_a(nc, i - 1)
            if !isnothing(result)
                return result
            end
        end
    end
    return nothing
end

function reverse_a(c::Computer)::Union{UInt64, Nothing}
    nc = copy(c)
    nc.a = 0
    reverse_a(nc, length(nc.prog))
end

read_input() |> reverse_a |> println
