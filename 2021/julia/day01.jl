include("common.jl")

function part1()
  getinput(1) do f
    data = parse.(Int, readlines(f))
    count(>(0), diff(data))
  end
end

function part2()
  getinput(1) do f
    data = parse.(Int, readlines(f))
    window = data[1:end-2] + data[2:end-1] + data[3:end]
    count(>(0), diff(window))
  end
end

println("Part 1: ", part1())
println("Part 2: ", part2())
