function search(graph, from, to)
    next = []
    visited = Set()
    push!(next, (from, 0))
    graph[from] = 'a'
    graph[to] = 'z'
    while !isempty(next)
        current, distance = pop!(next)
        if current in visited
            continue
        end
        push!(visited, current)
        if current == to
            return distance
        end
        for (dx,dy) in [[1, 0], [-1, 0], [0, 1], [0, -1]]
            idx = CartesianIndex(current[1] + dx, current[2] + dy)
            if checkbounds(Bool, graph, idx) && (graph[idx] <= graph[current] + 1) && !(idx in visited)
                pushfirst!(next, (idx, distance + 1))
            end
        end
    end
    return 99999
end

data = hcat([collect(line) for line in readlines(stdin)]...)

to = findfirst(data .== 'E')
@show search(data, findfirst(data .== 'S'), to)
best = 9999999
for idx in findall(data .== 'a')
    global best = min(best, search(data, idx, to))
end
@show best