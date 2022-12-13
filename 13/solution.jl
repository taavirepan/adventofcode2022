function compare(a::Integer, b::Integer)
    if a != b
        return a < b
    end
end

function compare(a::Vector, b::Vector)
    for (x,y) in Iterators.zip(a, b)
        r = compare(x, y)
        if r != nothing
            return r
        end
    end
    if length(a) != length(b)
        return length(a) < length(b)
    end
end

compare(a::Vector, b::Integer) = compare(a, [b])
compare(a::Integer, b::Vector) = compare([a], b)

task1 = 0
for (i, data) in enumerate(Iterators.partition(readlines(stdin), 3))
    a = eval(Meta.parse(data[1]))
    b = eval(Meta.parse(data[2]))
    if compare(a,b)
        global task1 += i
    end
end
@show task1
