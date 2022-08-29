include("common.jl")

function parseinput(hex)
    reduce(vcat, map(collect(chomp(hex))) do h
        parse(Int, h, base = 16) .>> (3:-1:0) .& 1
    end)
end

noop(x = ()) = bin -> (x, bin)
then(g) = f -> bin -> ((a, bin) = f(bin); (g(a), bin))
and_then(g) = f -> bin -> ((a, bin) = f(bin); g(a)(bin))

greedy(f) = bin -> begin
    acc = []
    while !isempty(bin)
        a, bin = f(bin)
        push!(acc, a)
    end
    acc, bin
end

times(n, f) = bin -> begin
    acc = []
    for _ ∈ 1:n
        a, bin = f(bin)
        push!(acc, a)
    end
    acc, bin
end

be(bin) = reduce((a, b) -> a << 1 + b, bin)

bits(n) = bin -> (bin[1:n], bin[n+1:end])

imm(n) = bits(n) |> then(be)
bool() = imm(1) |> then(Bool)

tup() = noop()
tup(f::Function, fs::Function...) = f |>
    and_then(t -> tup(fs...) |> then(ts -> (t, ts...)))

header() = tup(imm(3), imm(3)) |> then(h -> (version = h[1], type = h[2]))

function lit()
    blocks = tup(bool(), bits(4)) |>
        and_then(b -> b[1] ? blocks |> then(bs -> vcat(b[2], bs)) : noop(b[2]))
    blocks |> then(be)
end

sub(op, lit_) = bool() |> and_then(b -> begin
    p = packet(op, lit_)
    b ?
        imm(11) |> and_then(n -> times(n, p)) :
        imm(15) |> and_then(l -> bits(l) |> then(b -> greedy(p)(b)[1]))
end)

packet(op, lit_) = header() |> and_then() do h
    h.type == 4 && return lit() |> then(l -> lit_(h, l))
    sub(op, lit_) |> then(s -> op(h, s))
end

eval(op, bin; lit = ((_, l) -> l)) = packet(op, lit)(bin)[1]

part1() = eval(parseinput(getinput(16)), lit = (h, _) -> h.version) do h, s
    h.version + sum(s)
end

part2() = eval(parseinput(getinput(16))) do h, s
    h.type == 0 && return sum(s)
    h.type == 1 && return reduce(*, s)
    h.type == 2 && return minimum(s)
    h.type == 3 && return maximum(s)
    h.type == 5 && return s[1] > s[2]
    h.type == 6 && return s[1] < s[2]
    h.type == 7 && return s[1] == s[2]
end

println("Part 1: ", part1())
println("Part 2: ", part2())
