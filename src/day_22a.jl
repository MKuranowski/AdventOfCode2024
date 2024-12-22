# © Copyright 2024 Mikołaj Kuranowski
# SPDX-License-Identifier: MIT

function next(secret)
    # x % 16777216 = x % 0x1000000 = x & 0xffffff
    # x * 64 = x * 2^6 = x << 6
    # x / 32 = x / 2^5 = x >> 5
    # x * 2048 = x * 2^11 = x << 1
    secret ⊻= (secret << 6) & 0xffffff
    secret ⊻= (secret >> 5) & 0xffffff
    secret ⊻= (secret << 11) & 0xffffff
    secret
end

function next(secret, steps)
    for _ in 1:steps
        secret = next(secret)
    end
    secret
end

result = eachline() .|> (line -> parse(UInt32, line)) .|> (n -> next(n, 2000)) |> sum
println(result)
