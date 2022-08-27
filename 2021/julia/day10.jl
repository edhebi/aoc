include("common.jl")

OPEN = Dict(')' => '(', ']' => '[', '}' => '{', '>' => '<')
CLOSE = Dict('(' => ')', '[' => ']', '{' => '}', '<' => '>')

function solve(line)
    stack = []
    for c ∈ line
        if c ∈ ['(', '[', '{', '<']
            push!(stack, c)
        elseif last(stack) == OPEN[c]
            pop!(stack)
        else
            return (ok = false, bad = c)
        end
    end
    return (ok = true, complete = reverse(map(c -> CLOSE[c], stack)))
end

isok((; ok)) = ok

part1() = getinput(10) do f
    SCORES = Dict(')' => 3, ']' => 57, '}' => 1197, '>' => 25137)
    sum(s -> SCORES[s.bad], filter(!(isok), solve.(readlines(f))))
end

part2() = getinput(10) do f
    SCORES = Dict(')' => 1, ']' => 2, '}' => 3, '>' => 4)
    scores = map(filter(isok, solve.(readlines(f)))) do (; complete)
        mapreduce(c -> SCORES[c], (a, b) -> 5a + b, complete)
    end
    sort(scores)[length(scores) ÷ 2 + 1]
end

println("Part 1: ", part1())
println("Part 2: ", part2())
