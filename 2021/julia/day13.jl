include("common.jl")

parsedot(s) = Tuple(parse.(Int, split(s, ",")))
parsefold(s) = ((a, b) = split(s, "="); (last(a), parse(Int, b)))

mirror(x, n) = x ≤ n ? x : 2n - x

function repr(dots)
    w, h = maximum(p -> p[1], dots), maximum(p -> p[2], dots)
    join('\n' * join((x, y) ∈ dots ? "##" : "  " for x ∈ 0:w) for y ∈ 0:h)
end

function fold(dots, (axis, n))
    m = if axis == 'x'
        p -> (mirror(p[1], n), p[2])
    else
        p -> (p[1], mirror(p[2], n))
    end
    Set(map(m, collect(dots)))
end

function parseinput(f)
    lines = readlines(f)
    n = findfirst(isempty, lines)
    dots = Set(parsedot.(lines[begin:n-1]))
    (; dots, folds = parsefold.(lines[n+1:end]))
end

part1() = getinput(13) do f
    dots, folds = parseinput(f)
    length(fold(dots, first(folds)))
end

part2() = getinput(13) do f
    dots, folds = parseinput(f)
    repr(reduce(fold, folds, init = dots))
end

println("Part 1: ", part1())
println("Part 2: ", part2())
