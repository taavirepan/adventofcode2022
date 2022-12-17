using DataStructures

struct Vertex
    player1::Int8
    player2::Int8
    time::Int8
    opened::Int16
end

Base.isless(a::Vertex, b::Vertex) = a.time > b.time

key(v::Vertex) = (v.player1, v.player2, v.time, v.opened)

function max_score(v::Vertex)
    ret = 0
    flows = []
    for (k,b) in bits
        if v.opened&b == 0
            push!(flows, -flow_rates[k])
        end
    end
    sort!(flows)
    for (i,f) in enumerate(flows)
        i = max(1, i-1) # bit hackish
        if v.time - i <= 0
            return ret
        end
        ret += f * (v.time - i)
    end
    return ret
end


function edges(v)
    ret = []
    if v.time <= 0
        return ret
    end
    global fully_opened
    if v.opened == fully_opened
        return [(0, Vertex(1, 1, 0, fully_opened))]
    end
    if flow_rates[v.player1] > 0 && flow_rates[v.player2] > 0 && 
        v.opened&bits[v.player1] == 0 && v.opened&bits[v.player2] == 0 && 
        v.player1 != v.player2
        push!(ret, (-(flow_rates[v.player1]+flow_rates[v.player2])*(v.time-1), Vertex(v.player1, v.player2, v.time - 1, v.opened|bits[v.player1]|bits[v.player2])))
    end
    for link in links[v.player1]
        if flow_rates[v.player2] != 0 && v.opened&bits[v.player2] == 0
            push!(ret, (-flow_rates[v.player2]*(v.time-1), Vertex(link, v.player2, v.time - 1, v.opened|bits[v.player2])))
        end
    end
    for link in links[v.player2]
        if flow_rates[v.player1] != 0 && v.opened&bits[v.player1] == 0
            push!(ret, (-flow_rates[v.player1]*(v.time-1), Vertex(link, v.player1, v.time - 1, v.opened|bits[v.player1])))
        end
    end

    for link1 in links[v.player1]
        for link2 in links[v.player2]
            push!(ret, (0, Vertex(link1, link2, v.time - 1, v.opened)))
        end
    end
    return ret
end

function shortest_path(vertex)
    # max_score(x) = 0
    queue = PriorityQueue{Vertex, Pair{Int, Vertex}}()
    gScore = Dict(vertex => 0)
    fScore = Dict(vertex => max_score(vertex))
    ret = 0
    skipped = 0
    enqueue!(queue, vertex, fScore[vertex] => vertex)
	it = 0
    while length(queue) > 0
        current = dequeue!(queue)
        if current.time == 0
            if gScore[current] < ret
                @show it, ret=>gScore[current]
            end
            ret = min(ret, gScore[current])
            empty!(queue) # yeah, let's just hope for the best
            continue
        end
        global el -= time_ns()
        for (cost, target) in edges(current)
            target = Vertex(min(target.player1, target.player2), max(target.player1, target.player2), target.time, target.opened)
            g = gScore[current] + cost
            if !(target in keys(gScore)) || g < gScore[target]
                gScore[target] = g
                fScore[target] = g + max_score(target)
                if target in keys(queue)
                    delete!(queue, target)
                end
                enqueue!(queue, target, fScore[target] => target)
            end
        end
        el += time_ns()
        it += 1
    end
    @show  it
    ret
end

flow_rates = Dict()
links = Dict()
bits = Dict()
fully_opened = 0
index = Dict()
for line in readlines(stdin)
    s1, s2 = split(line, ";")
    m = match(r"Valve (\w\w).*rate=(\d+)", s1)
    tunnel = m[1]
    tunnels = split(split(replace(s2, r"valves? " => s"::"), "::")[2], ", ")
    index[tunnel] = 1+length(index)
    flow_rates[index[tunnel]] = parse(Int, m[2])
    links[index[tunnel]] = tunnels
    if flow_rates[index[tunnel]] > 0
        global fully_opened |= bits[index[tunnel]] = 2^length(bits)
    end
end

for i in keys(links)
    links[i] = [index[t] for t in links[i]]
end

t = -time_ns()
el = 0
@show shortest_path(
    Vertex(index["AA"], index["AA"], 26, 0)
)
t += time_ns()

@show 100*el/t
@show el*1e-9, t*1e-9
