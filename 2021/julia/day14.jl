include("common.jl")

parserule(s) = ((a, b) = split(s, " -> "); Tuple(collect(a)) => first(b))

function parseinput(f)
    lines = readlines(f)
    (template = lines[1], rules = Dict(parserule.(lines[3:end])))
end

inc!(dict, key, count = 1) = dict[key] = get(dict, key, 0) + count

function solve((; template, rules), n)
    histo = Dict()

    for i ∈ 1:length(template)-1
        inc!(histo, (template[i], template[i+1]))
    end

    for _ ∈ 1:n
        next = Dict()
        for (pair, count) ∈ pairs(histo)
            if haskey(rules, pair)
                inc!(next, (pair[1], rules[pair]), count)
                inc!(next, (rules[pair], pair[2]), count)
            else
               inc!(next, pair, count)
            end
        end
        histo = next
    end

    counts = Dict()
    for (pair, count) ∈ histo
        inc!(counts, pair[1], count)
    end
    inc!(counts, last(template))

    maximum(values(counts)) - minimum(values(counts))
end

part1() = getinput(14) do f
    solve(parseinput(f), 10)
end

part2() = getinput(14) do f
    solve(parseinput(f), 40)
end

println("Part 1: ", part1())
println("Part 2: ", part2())
