# © Copyright 2024 Mikołaj Kuranowski
# SPDX-License-Identifier: MIT

function do_instruction(instruction::RegexMatch)::Int
    a = parse(Int, instruction.captures[1])
    b = parse(Int, instruction.captures[2])
    a * b
end

content = read(stdin, String)
result = sum(eachmatch(r"mul\((\d{1,3}),(\d{1,3})\)", content) .|> do_instruction)
display(result)
