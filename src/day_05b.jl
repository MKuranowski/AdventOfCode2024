# © Copyright 2024 Mikołaj Kuranowski
# SPDX-License-Identifier: MIT

using Base.Threads
include("day_05.jl")

function put_in_order(rules::Rules, pages::Set{Int32}, so_far::Update)::Union{Nothing, Update}
    # Base recursive case
    if length(pages) == 0
        return conforms(rules, so_far) ? so_far : nothing
    end

    # Try to put every possible page next and see if that works
    for page in pages
        new_so_far = copy(so_far)
        new_so_far[page] = length(so_far) + 1

        new_pages = copy(pages)
        delete!(new_pages, page)

        # Check if the new thing conforms to all rules, pruning the search tree
        if conforms(rules, new_so_far)
            # Try to recurse downloads
            complete_update = put_in_order(rules, new_pages, new_so_far)
            if !isnothing(complete_update)
                return complete_update
            end
        end
    end

    # Nothing worked - impossible to put in order
    return nothing
end

function main()
    rules, updates = load_input()
    result = Atomic{Int}(0)

    Threads.@threads for update in updates
        if !conforms(rules, update)
            fixed_update = put_in_order(rules, Set(keys(update)), Update())
            @assert !isnothing(fixed_update)
            atomic_add!(result, Int(find_middle(fixed_update)))
        end
    end

    display(result)
end

main()
