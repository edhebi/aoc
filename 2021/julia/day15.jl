include("common.jl")

parseinput(f) = parse.(Int, reduce(hcat, split.(readlines(f), "")))

function minby(f::Function, itr)
    m, fm = nothing, Inf
    for x ∈ itr
        fx = f(x)
        fx < fm && (m = x; fm = fx)
    end
    m
end

function neighbors(grid, pos)
    offsets = CartesianIndex.([(-1, 0), (1, 0), (0, 1), (0, -1)])
    filter(i -> checkbounds(Bool, grid, i), map(off -> pos + off, offsets))
end

function find_path(grid)
    start = CartesianIndex(1, 1)
    target = CartesianIndex(size(grid))

    gscore = fill(Inf, axes(grid))
    gscore[start] = 0.

    fscore = fill(Inf, axes(grid))
    fscore[start] = 0.

    source = Dict()
    openset = Set([start])

    while !isempty(openset)
        current = minby(i -> fscore[i], openset)
        if current == target
            path = [current]
            while haskey(source, last(path))
                push!(path, source[last(path)])
            end
            return reverse!(path)
        end
        setdiff!(openset, [current])

        for i ∈ neighbors(grid, current)
            candidate = gscore[current] + grid[i]
            if candidate < gscore[i]
                gscore[i] = candidate
                fscore[i] = candidate + sum(Tuple(i - start))
                source[i] = current
                push!(openset, i)
            end
        end
    end
end

part1() = getinput(15) do f
    grid = parseinput(f)
    sum(grid[find_path(grid)[2:end]])
end

part2() = getinput(15) do f
    g = parseinput(f)
    row = hcat(map(i -> g .+ i, (0:4))...)
    grid = vcat(map(i -> row .+ i, (0:4))...)
    map!(x -> x > 9 ? x - 9 : x, grid, grid)
    sum(grid[find_path(grid)[2:end]])
end

println("Part 1: ", part1())
println("Part 2: ", part2())
