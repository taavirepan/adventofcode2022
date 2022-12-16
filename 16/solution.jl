function key(position1, position2, time, opened)
    ret = 0
    for o in opened
        ret += 2^(bits[o])
    end
    return ret, time, position1, position2
    ret += 2^16 * time
    ret += 2^24 * index[position1]
    ret += 2^32 * index[position2]
    return ret
end

function find_best_subsolution(p1, p2, time, opened)
    varying = p1 isa Array ? p1 : p2
    fixed = p1 isa Array ? p2 : p1
    ret = 0
    if flow_rates[fixed] == 0 || fixed in opened
        return 0
    end
    for move in varying
        opened2 = copy(opened)
        push!(opened2, fixed)
        ret = max(ret, 
            find_solution(min(fixed,move), max(fixed,move), time - 1, opened2)
        )
    end
    return ret + flow_rates[fixed] * (time - 1)
end

cache = Dict()
function find_solution(position1, position2, time, opened)
    if time == 0
        return 0
    end
    k = key(position1, position2, time, opened)
    if k in keys(cache)
        return cache[k]
    end
    ret = find_best_subsolution(position1, links[position2], time, opened)
    ret = min(ret, find_best_subsolution(links[position1], position2, time, opened))

    for link1 in links[position1]
        for link2 in links[position2]
            linkn = min(link1, link2)
            linkx = max(link1, link2)
            cur = find_solution(linkn, linkx, time - 1, copy(opened))
            ret = max(ret, cur)
        end
    end
    cache[k] = ret
    return ret
end

flow_rates = Dict()
links = Dict()
bits = Dict()
index = Dict()
for line in readlines(stdin)
    s1, s2 = split(line, ";")
    m = match(r"Valve (\w\w).*rate=(\d+)", s1)
    tunnel = m[1]
    flow_rates[tunnel] = parse(Int, m[2])
    tunnels = split(split(replace(s2, r"valves? " => s"::"), "::")[2], ", ")
    for t in tunnels
        links[tunnel] = tunnels
    end
    if flow_rates[tunnel] > 0
        bits[tunnel] = length(bits)
    end
    index[tunnel] = length(index)
end
@show find_solution("AA", "AA", 30, Set())
