# © Copyright 2024 Mikołaj Kuranowski
# SPDX-License-Identifier: MIT

@enum Operation AND XOR OR

struct Gate
    op::Operation
    lhs::String
    rhs::String
end

const Node = Union{Bool, Gate}
const Device = Dict{String, Node}

function solve!(device::Device, name::String)::Bool
    node = device[name]
    if node isa Bool
        node
    elseif node isa Gate
        lhs = solve!(device, node.lhs)
        rhs = solve!(device, node.rhs)
        value = if node.op == AND
            lhs && rhs
        elseif node.op == XOR
            lhs ⊻ rhs
        elseif node.op == OR
            lhs || rhs
        else
            error("unexpected Operation: $(node.op)")
        end
        device[name] = value
    else
        error("unexpected node type: $(typeof(node))")
    end
end

function read_input()::Device
    d = Device()
    for line in eachline()
        if contains(line, ':')
            node, value = split(line, ": ")
            d[node] = value == "1"
        elseif contains(line, '>')
            lhs, op_s, rhs, _, node = split(line, ' ')
            op = if op_s == "AND"
                AND
            elseif op_s == "XOR"
                XOR
            elseif op_s == "OR"
                OR
            else
                error("unrecognized operation: $op_s")
            end
            d[node] = Gate(op, lhs, rhs)
        end
    end
    d
end

function main()
    d = read_input()

    zs = [i for i in keys(d) if startswith(i, 'z')]
    sort!(zs, rev=true)

    result = Int64(0)
    for z in zs
        result <<= 1
        if solve!(d, z)
            result |= 1
        end
    end
    println(result)
end

main()
