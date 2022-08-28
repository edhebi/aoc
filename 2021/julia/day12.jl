include("common.jl")

function graph(f)
    g = Dict{String, Set{String}}()
    for (a, b) ∈ split.(readlines(f), "-")
        push!(get!(g, a, Set()), b)
        push!(get!(g, b, Set()), a)
    end
    g
end

big(n) = all(isuppercase, n)
small(n) = all(islowercase, n) && n ∉ ["start", "end"]

npaths(g; visited = Set(), dup = "") = npaths("start", g; visited, dup)

function npaths(node, g; visited = Set(), dup = "")
    node == "end" && return Int(dup == "")
    visited = visited ∪ [node]
    visit = filter(n -> n ∉ visited || big(n) || n == dup, g[node])
    paths = sum(visit; init = 0) do n
        if n ∈ visited && n == dup
            npaths(n, g; visited, dup = "")
        else
            npaths(n, g; visited, dup)
        end
    end
    paths
end

part1() = getinput(12) do f
    npaths(graph(f))
end

part2() = getinput(12) do f
    g = graph(f)
    npaths(g) + sum(n -> npaths(g, dup = n), filter(small, keys(g)))
end

println("Part 1: ", part1())
println("Part 2: ", part2())
