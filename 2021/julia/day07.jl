include("common.jl")

function part1()
  crabs = parse.(Int, split(getinput(7), ','))
  a,b = extrema(crabs)
  minimum(n -> sum(abs.(crabs .- n)), a:b)
end

function part2()
  crabs = parse.(Int, split(getinput(7), ','))
  a,b = extrema(crabs)
  minimum(n -> sum(∑ⁿ.(crabs .- n)), a:b)
end

∑ⁿ(n) = abs(n) |> m -> m*(m+1) ÷ 2 

println("Part 1: ", part1())
println("Part 2: ", part2())