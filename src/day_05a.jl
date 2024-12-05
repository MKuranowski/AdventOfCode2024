# © Copyright 2024 Mikołaj Kuranowski
# SPDX-License-Identifier: MIT

include("day_05.jl")

function main()
    rules, updates = load_input()
    result = 0

    for update in updates
        if conforms(rules, update)
            result += find_middle(update)
        end
    end

    display(result)
end

main()
