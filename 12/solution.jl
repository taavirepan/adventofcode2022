function search(graph, from, to)
    next = []
    visited = Set()
    push!(next, (from, 0))
    graph[from] = 'a'
    graph[to] = 'z'
    while true
        sort!(next, lt=(a,b)->a[2] > b[2])
        current, distance = pop!(next)
        while current in visited
            current, distance = pop!(next)
        end
        push!(visited, current)
        if current == to
            return distance
        end
        for (dx,dy) in [[1, 0], [-1, 0], [0, 1], [0, -1]]
            idx = CartesianIndex(current[1] + dx, current[2] + dy)
            if checkbounds(Bool, graph, idx) && (graph[idx] <= graph[current] + 1) && !(idx in visited)
                push!(next, (idx, distance + 1))
            end
        end
    end
    return distance
end

N = 0
for (i,line) in enumerate(readlines(stdin))
    global N, data
    if N == 0
        N = length(line)
        data = zeros(Int, N, 0)
    end
    data = hcat(data, collect(line))
end

@show search(data, findfirst(data .== 'S'), findfirst(data .== 'E'))
