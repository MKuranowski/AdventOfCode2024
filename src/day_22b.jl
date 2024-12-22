# © Copyright 2024 Mikołaj Kuranowski
# SPDX-License-Identifier: MIT

const STEPS = 2000

function next(secret)
    # x % 16777216 = x % 0x1000000 = x & 0xffffff
    # x * 64 = x * 2^6 = x << 6
    # x / 32 = x / 2^5 = x >> 5
    # x * 2048 = x * 2^11 = x << 11
    secret ⊻= (secret << 6) & 0xffffff
    secret ⊻= (secret >> 5) & 0xffffff
    secret ⊻= (secret << 11) & 0xffffff
    secret
end

function main()
    sum_by_seq = Dict{NTuple{4, Int8}, Int}()

    for line in eachline()
        seen_seq = Set{NTuple{4, Int8}}()
        changes = (zero(Int8), zero(Int8), zero(Int8), zero(Int8))
        secret = parse(Int, line)

        for i in 1:2000
            last_price = secret % 10
            secret = next(secret)
            price = secret % 10
            change = Int8(price - last_price)
            changes = (changes[2], changes[3], changes[4], change)

            if i >= 4 && changes ∉ seen_seq
                push!(seen_seq, changes)
                sum_by_seq[changes] = get(sum_by_seq, changes, 0) + price
            end
        end
    end

    result = maximum(values(sum_by_seq))
    println(result)
end

main()
