include("common.jl")

frombits(m) = reduce((a, b) -> 2a+b, m)

part1() = getinput(3) do f
  bits = map(line -> collect(line) .== '1', readlines(f))
  repr = sum(bits) .> length(bits) / 2
  prod(frombits.((repr, .~repr)))
end

part2() = getinput(3) do f
  bits = map(line -> collect(line) .== '1', readlines(f))

  function criterion(op, indices, i)
    if length(indices) == 1
      return frombits(bits[only(indices)])
    end
    bit = op(sum(x[i] for x in view(bits, indices)), length(indices) / 2)
    indices = filter(j -> bits[j][i] == bit, indices)
    criterion(op, indices, i+1)
  end
  criterion(op) = criterion(op, 1:length(bits), 1)

  prod(criterion.((≥, <)))
end


println("Part 1: ", part1())
println("Part 1: ", part2())
