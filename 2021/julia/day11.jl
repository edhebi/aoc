include("common.jl")

using Base.Iterators: product

MOCK = split("5483143223
2745854711
5264556173
6141336146
6357385478
4167524645
2176841721
6882881134
4846848554
5283751526", "\n")

parse_grid(f) = parse.(Int, reduce(hcat, split.(readlines(f), "")))

function neighbors(grid, pos)
    offsets = CartesianIndex.(product([-1, 0, 1], [-1, 0, 1]))
    filter(map(off -> pos + off, offsets)) do i
        i != pos && checkbounds(Bool, grid, i)
    end
end

indices(x) = eachindex(view(x, axes(x)...))

function step(grid)
    next = grid .+ 1
    mask = fill(false, axes(next))
    done = false
    while !done
        flashes = filter(i -> next[i] > 9 && !mask[i], indices(grid))
        done = isempty(flashes)
        for i ∈ flashes
            mask[i] = true
            for j ∈ neighbors(next, i)
                next[j] += 1
            end
        end
    end
    fill!(view(next, filter(i -> mask[i], indices(mask))), 0)
    (next, count(mask))
end

part1() = getinput(11) do f
    grid = parse_grid(f)
    total = 0
    for _ ∈ 1:100
        next, flashes = step(grid)
        total += flashes
        grid = next
    end
    total
end

part2() = getinput(11) do f
    grid = parse_grid(f)
    n = 0
    while true
        next, flashes = step(grid)
        n += 1
        flashes == length(grid) && return n
        grid = next
    end
end

println("Part 1: ", part1())
println("Part 2: ", part2())
