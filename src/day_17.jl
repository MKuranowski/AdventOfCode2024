# © Copyright 2024 Mikołaj Kuranowski
# SPDX-License-Identifier: MIT

mutable struct Computer
    a::UInt64
    b::UInt64
    c::UInt64
    ip::UInt8
    prog::Vector{UInt8}
    output::Vector{UInt8}
end

Computer() = Computer(0, 0, 0, 1, UInt8[], UInt8[])
Base.copy(c::Computer) = Computer(c.a, c.b, c.c, c.ip, copy(c.prog), copy(c.output))

function read_input()::Computer
    c = Computer()
    for line in eachline()
        if startswith(line, "Register A:")
            c.a = parse(UInt64, match(r"-?[0-9]+", line).match)
        elseif startswith(line, "Register B:")
            c.b = parse(UInt64, match(r"-?[0-9]+", line).match)
        elseif startswith(line, "Register C:")
            c.c = parse(UInt64, match(r"-?[0-9]+", line).match)
        elseif startswith(line, "Program:")
            c.prog = eachmatch(r"[0-9]+", line) .|> (m -> parse(UInt8, m.match)) |> collect
        end
    end
    c
end

function combo(c::Computer, operand::UInt64)::UInt64
    if operand <= 3
        operand
    elseif operand == 4
        c.a
    elseif operand == 5
        c.b
    elseif operand == 6
        c.c
    else
        error("Invalid combo operand: $operand")
    end
end

function exec!(c::Computer)::Bool
    # IP past the end of program - halt
    if c.ip > length(c.prog)
        return false
    end

    instruction = c.prog[c.ip]
    operand = UInt64(c.prog[c.ip + 1])
    advance = true

    if instruction == 0
        # adv: a = a / 2^combo_operand
        c.a = c.a >> combo(c, operand)
    elseif instruction == 1
        # bxl: b = b ⊻ literal_operand
        c.b = c.b ⊻ operand
    elseif instruction == 2
        # bst: b = combo_operand % 8
        c.b = combo(c, operand) & 7
    elseif instruction == 3
        # jnz: ip = a == 0 ? ip+2 : literal_operand
        advance = false
        c.ip = c.a == 0 ? c.ip + 2 : UInt8(operand) + 1
    elseif instruction == 4
        # bxc: b = b ⊻ c
        c.b = c.b ⊻ c.c
    elseif instruction == 5
        # out: print(combo_operand % 8)
        push!(c.output, UInt8(combo(c, operand) & 7))
    elseif instruction == 6
        # bdv: b = a / 2^combo_operand
        c.b = c.a >> combo(c, operand)
    elseif instruction == 7
        # cdv: c = a / 2^combo_operand
        c.c = c.a >> combo(c, operand)
    else
        error("unexpected instruction: $instruction")
    end

    if advance
        c.ip += 2
    end
    return true
end

function run(c::Computer)::Computer
    c2 = copy(c)
    while exec!(c2)
    end
    c2
end

function print_output(c::Computer; io::IO = stdout)
    for (i, value) in enumerate(c.output)
        if i != 1
            print(io, ',')
        end
        print(io, value)
    end
    print(io, '\n')
end
