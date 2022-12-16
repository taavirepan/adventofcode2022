using Profile

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
    # for k = 1:length(bits)
    #     b = 2^k
        if v.opened&b == 0
            # d1 = distance_map[v.player1 => k]
            # d2 = distance_map[v.player2 => k]
            # ret -= flow * (v.time - 1 - min(d1, d2))
            push!(flows, -flow_rates[k])
        end
    end
    sort!(flows)
    for (i,f) in enumerate(flows)
        i = max(1, i-1)
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
    global el -= time_ns()
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
    el += time_ns()
    return ret
end

function shortest_path(vertex)
    # max_score(x) = 0
    queue = [vertex]
    gScore = Dict(vertex => 0)
    fScore = Dict(vertex => max_score(vertex))
    visited = Set()
    ret = 0
    skipped = 0
    while length(queue) > 0
        current = popfirst!(queue)
        if key(current) in visited
            skipped += 1
            continue
        end
        push!(visited, key(current))
        if current.time == 0
            # if current.opened == fully_opened
            #     return gScore[current]
            # end
            ret = min(ret, gScore[current])
            empty!(queue)
            continue
        end
        for (cost, target) in edges(current)
            target = Vertex(min(target.player1, target.player2), max(target.player1, target.player2), target.time, target.opened)
            g = gScore[current] + cost
            if !(target in keys(gScore)) || g < gScore[target]
                gScore[target] = g
                fScore[target] = g + max_score(target)
                # i = searchsorted(queue, target; lt=(a,b)->fScore[a]<fScore[b])
                i = searchsorted(queue, target; by=(a)->fScore[a])
                insert!(queue, first(i), target)
            end
        end
    end
    @show length(visited)
    @show skipped
    ret
end

function full_search(graph)
    ret = Dict()
    for (k, edges) in graph
        ret[k=>k] = 0
        for e in edges
            ret[k=>e] = 1
        end
    end
    for k in keys(graph)
        for i in keys(graph)
            for j in keys(graph)
                if (i=>k) in keys(ret) && (k=>j) in keys(ret)
                    if !((i=>j) in keys(ret)) || ret[i=>j] > ret[i=>k] + ret[k=>j]
                        ret[i=>j] = ret[i=>k] + ret[k=>j]
                    end
                end
            end
        end
    end
    return ret
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

# distance_map = full_search(links)

# flow_rates = [flow_rates[i] for i=1:length(flow_rates)]

t = -time_ns()
el = 0
@show shortest_path(
    Vertex(index["AA"], index["AA"], 26, 0)
)
t += time_ns()

# Profile.print(mincount=1000)

@show 100*el/t
@show el*1e-9, t*1e-9
