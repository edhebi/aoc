function getinput(f::Function, day)
    n = lpad(day, 2, '0')
    fname = joinpath(dirname(Base.source_dir()), "inputs", "day$n.txt")
    open(f, fname, "r")
end

function getinput(day)
    getinput(day) do f
        read(f, String)
    end
end
