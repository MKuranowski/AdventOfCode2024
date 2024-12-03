# © Copyright 2024 Mikołaj Kuranowski
# SPDX-License-Identifier: MIT

function main()
    content = read(stdin, String)
    enabled = true
    result = 0
    for m in eachmatch(r"do\(\)|don't\(\)|mul\((\d{1,3}),(\d{1,3})\)", content)
        if m.match == "don't()"
            enabled = false
        elseif m.match == "do()"
            enabled = true
        elseif startswith(m.match, "mul(") && enabled
            a = parse(Int, m.captures[1])
            b = parse(Int, m.captures[2])
            result += a * b
        end
    end
    result
end

display(main())
