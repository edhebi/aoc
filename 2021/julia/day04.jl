include("common.jl")

function parseinput(lines)
  numbers = parse.(Int, split(first(lines), ','))
  grids = [parsegrid(lines[i:i+4]) for i in 3:6:length(lines)]
  return numbers, grids
end

function parsegrid(lines)
  map(lines) do line
    [parse(Int, s) for s in split(line, ' ') if s != ""]'
  end |> v -> (grid=vcat(v...), mask=zeros(Bool, 5, 5))
end

updategrid(g, n) = (grid = g.grid, mask = (g.grid .== n) .| g.mask)

function checkgrid(g)
  indices = [(i,j) for i = 1:5, j = 1:5]
  rows = map(i -> (t -> t[1]==i).(indices), 1:5)
  cols = map(i -> (t -> t[2]==i).(indices), 1:5)
  any(mask .& g.mask == mask for mask in vcat(rows, cols))
end

score(n, g) = n * sum(g.grid .* .~g.mask)

part1() = getinput(4) do f
  numbers, grids = parseinput(readlines(f))
  for n = numbers
    grids = updategrid.(grids, n)
    for grid = grids
      checkgrid(grid) && return score(n, grid)
    end
  end
end

part2() = getinput(4) do f
  numbers, grids = parseinput(readlines(f))
  last = nothing
  for n = numbers
    grids = filter(updategrid.(grids, n)) do g
      !(checkgrid(g) && (last = (n, g); true))
    end
    isempty(grids) && break
  end
  score(last...)
end

println("Part 1: ", part1())
println("Part 2: ", part2())
