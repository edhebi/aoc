using Combinatorics

include("common.jl")

function parseline(s)
    sortstr = String ∘ sort ∘ collect
    patterns, digits = split.(split(s, " | "), " ")
    (; patterns = sortstr.(patterns), digits)
end

# *-1-*
# 2   3
# |-4-|
# 5   6
# *-7-*

DIGITS = Dict(
    0 => [1, 2, 3, 5, 6, 7],
    1 => [3, 6],
    2 => [1, 3, 4, 5, 7],
    3 => [1, 3, 4, 6, 7],
    4 => [2, 3, 4, 6],
    5 => [1, 2, 4, 6, 7],
    6 => [1, 2, 4, 5, 6, 7],
    7 => [1, 3, 6],
    8 => [1, 2, 3, 4, 5, 6, 7],
    9 => [1, 2, 3, 4, 6, 7],
)

function issolution(sol, patterns)
    all(0:9) do d
        String(sort(map(i -> sol[i], DIGITS[d]))) ∈ patterns
    end
end

function decode(sol, digits)
    pattern = sort(Int64.(indexin(collect(digits), sol)))
    for (d, p) ∈ pairs(DIGITS)
        if pattern == p
            return d
        end
    end
end

function solve((; patterns, digits))
    for perm ∈ permutations('a':'g')
        if issolution(perm, patterns)
            return mapreduce(d -> decode(perm, d), (a, b) -> 10a + b, digits)
        end
    end
end

part1() = getinput(8) do f
    lines = parseline.(readlines(f))
    digits = mapreduce(l -> l.digits, vcat, lines)
    count(d -> length(d) ∈ [2, 3, 4, 7], digits)
end

part2() = getinput(8) do f
    lines = parseline.(readlines(f))
    sum(solve.(lines))
end

println("Part 1: ", part1())
println("Part 2: ", part2())
