include("common.jl")

function parseline(l)
    a, b = split(l, ' ')
    a, parse(Int, b)
end

part1() = getinput(2) do f
    pos = [0, 0]
    for (dir, val) = parseline.(readlines(f))
        pos .+= if dir == "forward"
            [val, 0]
        elseif dir == "up"
            [0, -val]
        else
            [0, val]
        end
    end
    prod(pos)
end

part2() = getinput(2) do f
    pos = [0, 0]
    aim = 0
    for (dir, val) = parseline.(readlines(f))
        if dir == "forward"
            pos .+= [val, aim * val]
        elseif dir == "up"
            aim -= val
        else
            aim += val
        end
    end
    prod(pos)
end

println("Part 1: ", part1())
println("Part 2: ", part2())
