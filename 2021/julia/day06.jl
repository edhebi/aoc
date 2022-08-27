include("common.jl")

function simulate(fishes, N)
    pop = mergewith(+, Dict.(fishes .=> 1)...)
    next((k, n)) = k > 0 ? Dict(k-1 => n) : Dict(6 => n, 8 => n)
    for _ = 1:N
        pop = mergewith(+, next.(collect(pop))...)
    end
    sum(values(pop))
end

part1() = simulate(parse.(Int, split(getinput(6), ',')), 80)
part2() = simulate(parse.(Int, split(getinput(6), ',')), 256)

println("Part 1: ", part1())
println("Part 2: ", part2())
