include("common.jl")

neighbors(pos) = map(off -> pos + CartesianIndex(off), ((0, 1), (0, -1), (1, 0), (-1, 0)))

part1() = getinput(9) do f
    grid = parse.(Int, reduce(hcat, split.(readlines(f), "")))
    spots = filter(pairs(IndexCartesian(), grid)) do (pos, val)
        all(>(val), get(grid, n, 10) for n = neighbors(pos))
    end
    sum(values(spots) .+ 1), (; grid, spots = keys(spots))
end

part2((; grid, spots)) = getinput(9) do f
    regions = map(collect(spots)) do spot
        region = Set()
        candidates = Set([spot])
        while !isempty(candidates)
            curr = pop!(candidates)
			toappend = filter(n -> get(grid, n, 9) < 9, neighbors(curr))
            union!(candidates, filter(p -> p ∉ region, toappend))
            push!(region, curr)
        end
        length(region)
    end
    partialsort!(regions, 3, rev=true)
    prod(regions[begin:3])
end

println("Part 1: ", ((score, context) = part1(); score))
println("Part 2: ", part2(context))
