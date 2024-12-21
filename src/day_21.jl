# © Copyright 2024 Mikołaj Kuranowski
# SPDX-License-Identifier: MIT

# Let's say that dist[start, finish, layer] is the minimal
# number of presses we need to take to move robot from start to finish
# and to activate finish at a specific layer.
# Layer 1 is the numpad, while layer `L` is the user input.
# dist[s, f, L] = 1 (the user can press any button in one step)
# Otherwise, we can recursively determine the best distance:
# dist[s, f, l] = min(sum(dist[a, b, l+1] for (a, b) in pairwise(p))
#                     for p in all_paths_between(s, f))

const Cache = Dict{Tuple{Char, Char, Int}, Int}

const PART_B = true
const USER_LAYER = PART_B ? 27 : 4

pairwise(x) = zip(x[1:end-1], x[2:end])

const NUMPAD_POS = Dict(
    '7' => (1, 1), '8' => (1, 2), '9' => (1, 3),
    '4' => (2, 1), '5' => (2, 2), '6' => (2, 3),
    '1' => (3, 1), '2' => (3, 2), '3' => (3, 3),
    '0' => (4, 2), 'A' => (4, 3)
)

const VALID_NUMPAD_POS = Set(values(NUMPAD_POS))

const KEYPAD_POS = Dict(
    '^' => (1, 2), 'A' => (1, 3),
    '<' => (2, 1), 'v' => (2, 2), '>' => (2, 3)
)

const VALID_KEYPAD_POS = Set(values(KEYPAD_POS))

function all_paths_by_pos(s::Tuple{Int, Int}, f::Tuple{Int, Int}, valid_positions::Set{Tuple{Int, Int}})::Vector{String}
    if s ∉ valid_positions
        return String[]
    elseif s == f
        return ["A"]
    end

    result = String[]

    # Try to move up
    if s[1] > f[1]
        for p in all_paths_by_pos((s[1] - 1, s[2]), f, valid_positions)
            push!(result, "^"*p)
        end
    end

    # Try to move down
    if s[1] < f[1]
        for p in all_paths_by_pos((s[1] + 1, s[2]), f, valid_positions)
            push!(result, "v"*p)
        end
    end

    # Try to move left
    if s[2] > f[2]
        for p in all_paths_by_pos((s[1], s[2] - 1), f, valid_positions)
            push!(result, "<"*p)
        end
    end

    # Try to move right
    if s[2] < f[2]
        for p in all_paths_by_pos((s[1], s[2] + 1), f, valid_positions)
            push!(result, ">"*p)
        end
    end

    return result
end

all_paths_on_numpad(s, f) = all_paths_by_pos(NUMPAD_POS[s], NUMPAD_POS[f], VALID_NUMPAD_POS)
all_paths_on_keypad(s, f) = all_paths_by_pos(KEYPAD_POS[s], KEYPAD_POS[f], VALID_KEYPAD_POS)

function calc_path_len(p, l, cache)
    total = 0
    at = 'A'
    for to in p
        total += get_dist(at, to, l, cache)
        at = to
    end
    total
end

function get_dist(s::Char, f::Char, l::Int, cache::Cache)::Int
    # Base recursion case
    if l == USER_LAYER
        return 1
    end

    # Check if result was memoized
    if haskey(cache, (s, f, l))
        return cache[(s, f, l)]
    end

    # Compute the result
    all_paths = l == 1 ? all_paths_on_numpad : all_paths_on_keypad
    result = minimum(calc_path_len(p, l + 1, cache) for p in all_paths(s, f))
    cache[(s, f, l)] = result
    return result
end

function main()
    cache = Cache()
    result = 0
    for code in eachline()
        d = calc_path_len(code, 1, cache)
        c = parse(Int, code[1:end-1])
        result += c * d
    end
    println(result)
end

main()
