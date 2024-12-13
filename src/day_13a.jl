# © Copyright 2024 Mikołaj Kuranowski
# SPDX-License-Identifier: MIT

include("day_13.jl")

result = sum(read_input() .|> find_smallest_presses)
display(result)
