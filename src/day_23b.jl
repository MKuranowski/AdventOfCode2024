# © Copyright 2024 Mikołaj Kuranowski
# SPDX-License-Identifier: MIT

using Graphs
using MetaGraphsNext

function read_input()
    g = MetaGraph(SimpleGraph(), label_type=String)
    for line in eachline()
        a, b = split(line, '-', limit=2)
        add_vertex!(g, a)
        add_vertex!(g, b)
        add_edge!(g, a, b)
    end
    g
end

function main()
    g = read_input()
    # "a maximum (i.e., largest) clique is [...] maximal" (https://en.wikipedia.org/wiki/Clique_problem)
    # so we can use the "maximal_cliques" function to find it
    maximum_clique = argmax(length, maximal_cliques(g))
    vertices = [g.vertex_labels[i] for i in maximum_clique]
    sort!(vertices)
    println(join(vertices, ','))
end

main()
