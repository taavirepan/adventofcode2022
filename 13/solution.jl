compare(a::Integer, b::Integer) = a == b ? nothing : a < b
compare(a::Vector, b::Integer) = compare(a, [b])
compare(a::Integer, b::Vector) = compare([a], b)

function compare(a::Vector, b::Vector)
    for (x,y) in Iterators.zip(a, b)
        r = compare(x, y)
        if r != nothing
            return r
        end
    end
    return compare(length(a), length(b))
end


task1 = 0
alldata = Vector{Any}()
push!(alldata, [[2]])
push!(alldata, [[6]])
for (i, data) in enumerate(Iterators.partition(readlines(stdin), 3))
    a = eval(Meta.parse(data[1]))
    b = eval(Meta.parse(data[2]))
    push!(alldata, a)
    push!(alldata, b)
    if compare(a,b)
        global task1 += i
    end
end
@show task1

function lt(a,b)
    r = compare(a,b)
    if r == nothing
        return false
    end
    return r
end
sort!(alldata, lt=lt)

task2 = 1
for (i,x) in enumerate(alldata)
    if x == [[2]] || x == [[6]]
        global task2 *= i
    end
end
@show task2
