compare(a::Integer, b::Integer) = a == b ? nothing : a < b
compare(a::Vector, b::Integer) = compare(a, [b])
compare(a::Integer, b::Vector) = compare([a], b)

function compare(a::Vector, b::Vector)
    pairs = Iterators.map(p->compare(p...), Iterators.zip(a, b))
    pairs = Iterators.filter(r->r!=nothing, pairs)
    return isempty(pairs) ? compare(length(a), length(b)) : first(pairs)
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

sort!(alldata, lt=compare)

task2 = 1
for (i,x) in enumerate(alldata)
    if x == [[2]] || x == [[6]]
        global task2 *= i
    end
end
@show task2
