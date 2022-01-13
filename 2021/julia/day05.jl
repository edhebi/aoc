include("common.jl")

function parseline(line)
  x1, y1, x2, y2 = parse.(Int, split(line, r",|->"))
  (; x1, y1, x2, y2)
end

indices(a, b) = a == b ? a : a:sign(b-a):b
getpoints(l) = (Tuple ∘ vcat).(indices(l.x1, l.x2), indices(l.y1, l.y2))

function intersections(lines)
  counted = mergewith(+, Dict.(map(pts -> pts .=> 1, getpoints.(lines)))...)
  count(>(1), values(counted))
end

part1() = getinput(5) do f
  lines = parseline.(readlines(f))
  aligned = filter(l -> l.x1 == l.x2 || l.y1 == l.y2, lines)
  intersections(aligned)
end

part2() = getinput(5) do f
  lines = parseline.(readlines(f))
  intersections(lines)
end

println("Part 1: ", part1())
println("Part 2: ", part2())