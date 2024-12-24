# © Copyright 2024 Mikołaj Kuranowski
# SPDX-License-Identifier: MIT

# If the input is to perform addition, the gates must form a series of full adders.
# In general, the sequence must be as follows:
#
# This is a schematic of a full binary adder, with labeled gates:
#
#          ┌─(kN AND)───────────────────┐
#          │  │                         │
#   (xN) ─────┴─(iN XOR)──┬──(zN XOR)   │
#          │     │        │     │       │
#   (yN) ──┴─────┘   (jN AND)───│─────(cN OR)
#                         │     │
# (cN-1)──────────────────┴─────┘
#
# Analyzing the circuit, it is supposed to add two 44-bit numbers.
# Instead of "c44", we'll have "z45".
# There's also a difference at the beginning, as "c-1" doesn't exists;
# so instead of "i00" we'll immediately have "z00"; instead of "k00" we'll have "c00";
# and "j00" doesn't exist.
#
# The goal is to find 8 incorrectly wired gates.
# The algorithm here starts labelling gates, prints any inconsistencies, sometimes failing.
#
# One then needs to manually analyze the inconsistency in a graph
# (input-turned-into-mermaid with some text editor magic),
# figure which gates outputs need to be swapped, and run the script again.

using Printf: @sprintf

@enum Operation AND XOR OR

struct Gate
    name::String
    op::Operation
    lhs::String
    rhs::String
end

function Base.parse(::Type{Operation}, x::AbstractString)
    if x == "AND"
        AND
    elseif x == "XOR"
        XOR
    elseif x == "OR"
        OR
    else
        error("invalid Operation: $x")
    end
end

function read_input(swaps)::Vector{Gate}
    gates = Gate[]
    for line in eachline()
        m = match(r"(\w+) (\w+) (\w+) -> (\w+)", line)
        if isnothing(m)
            continue
        end

        push!(gates, Gate(
            get(swaps, m.captures[4], m.captures[4]),
            parse(Operation, m.captures[2]),
            m.captures[1],
            m.captures[3],
        ))
    end
    gates
end

function get_label(name, labels)
    if startswith(name, 'x') || startswith(name, 'y') || startswith(name, 'z')
        name
    elseif haskey(labels, name)
        labels[name]
    else
        missing
    end
end

function matches(got1, expected1, got2, expected2)
    (got1 == expected1 && got2 == expected2) || (got1 == expected2 || got2 == expected1)
end

function main()
    swaps = Dict(
        # Add the swaps necessary to this dict while fixing
        "z37"=>"rrn", "rrn"=>"z37",
        "z16"=>"fkb", "fkb"=>"z16",
        "rqf"=>"nnr", "nnr"=>"rqf",
        "z31"=>"rdn", "rdn"=>"z31",
    )

    gates = read_input(swaps)

    unlabeled = BitSet(1:length(gates))
    labels = Dict{String, String}()

    done = false
    while !done
        done = true
        for i in unlabeled
            g = gates[i]

            lhs = get_label(g.lhs, labels)
            if ismissing(lhs)
                continue
            end

            rhs = get_label(g.rhs, labels)
            if ismissing(rhs)
                continue
            end

            bit = if lhs[1] != 'c'
                lhs[2:end]
            elseif rhs[1] != 'c'
                rhs[2:end]
            else
                error("gate $g with two carry inputs")
            end

            previous_carry = @sprintf "c%02d" parse(Int, bit)-1

            label = missing

            if g.op == XOR && matches(lhs, "x00", rhs, "y00")
                # Special case for "z00"
                label = "z00"
            elseif g.op == AND && matches(lhs, "x00", rhs, "y00")
                # Special case for "c00"
                label = "c00"
            elseif g.op == OR && matches(lhs, "j44", rhs, "k44")
                # Special case for "z45"
                label = "z45"
            elseif g.op == XOR
                # iN or zN
                if matches(lhs, "x$bit", rhs, "y$bit")
                    label = "i$bit"
                elseif matches(lhs, "i$bit", rhs, previous_carry)
                    label = "z$bit"
                elseif lhs == "i$bit"
                    println("XOR with lhs=$rhs : $lhs <-> $previous_carry")
                    label = "z$bit"
                elseif rhs == "i$bit"
                    println("XOR with rhs=$rhs : $lhs <-> $previous_carry")
                    label = "z$bit"
                elseif lhs == previous_carry
                    println("XOR with lhs=$lhs : $rhs <-> i$bit")
                    label = "z$bit"
                elseif rhs == previous_carry
                    println("XOR with rhs=$rhs : $lhs <-> i$bit")
                    label = "z$bit"
                else
                    error("wtf $g (lhs=$lhs, rhs=$rhs)")
                end
            elseif g.op == AND
                # kN or jN
                if matches(lhs, "x$bit", rhs, "y$bit")
                    label = "k$bit"
                elseif matches(lhs, "i$bit", rhs, previous_carry)
                    label = "j$bit"
                elseif lhs == "i$bit"
                    println("AND with lhs=$lhs : $rhs <-> $previous_carry")
                    label = "j$bit"
                elseif rhs == "i$bit"
                    println("AND with rhs=$rhs : $lhs <-> $previous_carry")
                    label = "j$bit"
                elseif lhs == previous_carry
                    println("AND with lhs=$lhs : $rhs <-> i$bit")
                    label = "j$bit"
                elseif rhs == previous_carry
                    println("AND with rhs=$rhs : $lhs <-> i$bit")
                    label = "j$bit"
                else
                    error("wtf $g (lhs=$lhs, rhs=$rhs)")
                end
            elseif g.op == OR
                # cN
                if matches(lhs, "k$bit", rhs, "j$bit")
                    label = "c$bit"
                elseif lhs == "k$bit"
                    println("OR with lhs=$lhs : $rhs <-> j$bit")
                    label = "c$bit"
                elseif rhs == "k$bit"
                    println("OR with rhs=$rhs : $lhs <-> j$bit")
                    label = "c$bit"
                elseif lhs == "j$bit"
                    println("OR with lhs=$lhs : $rhs <-> k$bit")
                    label = "c$bit"
                elseif rhs == "j$bit"
                    println("OR with rhs=$rhs : $lhs <-> k$bit")
                    label = "c$bit"
                else
                    error("wtf $g (lhs=$lhs, rhs=$rhs)")
                end
            else
                error("unexpected operation: $(g.op)")
            end

            if !ismissing(label)
                # Check for mismatched z nodes - those indicate swaps
                if (startswith(label, 'z') || startswith(g.name, 'z')) && label != g.name
                    println("$label <-> $(g.name)")
                    error("mislabeled output, please fix")
                end

                pop!(unlabeled, i)
                done = false
                labels[g.name] = label
            end
        end
    end

    for i in unlabeled
        println(gates[i])
    end
end

main()
