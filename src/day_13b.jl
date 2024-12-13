# © Copyright 2024 Mikołaj Kuranowski
# SPDX-License-Identifier: MIT

include("day_13.jl")

move_prize(c) = Claw(c.buttons, c.prize .+ 1e13)

result = sum(read_input() .|> move_prize .|> find_smallest_presses)
display(Int64(result))
