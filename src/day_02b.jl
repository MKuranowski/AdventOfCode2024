# © Copyright 2024 Mikołaj Kuranowski
# SPDX-License-Identifier: MIT

include("day_02.jl")

result = sum(eachline() .|> parse_report .|> is_report_safe_with_dampener)
println("$result")
