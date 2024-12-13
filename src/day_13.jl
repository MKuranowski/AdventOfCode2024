# © Copyright 2024 Mikołaj Kuranowski
# SPDX-License-Identifier: MIT

# Imagine buttons as the following matrix:
# [ button_a_dx button_b_dx ]
# [ button_a_dy button_b_dy ]
#
# Thus: buttons * [a_presses b_presses]ᵀ = [prize_a prize_b]ᵀ
#
# It's now possible to solve for [a_presses b_presses]ᵀ:
# buttons⁻¹ * [prize_a prize_b]ᵀ = [a_presses b_presses]ᵀ

struct Claw
    buttons::Matrix{Float64}
    prize::Vector{Float64}
end

function read_input()::Vector{Claw}
    claws = Vector{Claw}()
    buttons = zeros(Float64, 2, 2)
    for line in eachline()
        if line == ""
            continue
        end

        x, y = eachmatch(r"[0-9]+", line) .|> m -> parse(Float64, m.match)
        if startswith(line, "Button A")
            buttons[1, 1] = x
            buttons[2, 1] = y
        elseif startswith(line, "Button B")
            buttons[1, 2] = x
            buttons[2, 2] = y
        elseif startswith(line, "Prize")
            push!(claws, Claw(copy(buttons), [x; y]))
        end
    end
    claws
end

near_integer(x; precision=1e-3) = abs(x - round(x)) <= precision

function find_smallest_presses(c::Claw)
    a, b = inv(c.buttons) * c.prize
    near_integer(a) && near_integer(b) ? round(3a + b) : 0
end
