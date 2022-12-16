function key(position, time, opened)
    ret = 0
    for o in opened
        ret += 2^(bits[o])
    end
    ret += 2^16 * time
    ret += 2^32 * index[position]
    return ret
end

cache = Dict()
function find_solution(position, time, opened)
    if time == 0
        return 0
    end
    k = key(position, time, opened)
    if k in keys(cache)
        return cache[k]
    end
    if position in opened || flow_rates[position] == 0
        ret = 0
    else
        opened2 = copy(opened)
        push!(opened2, position)
        ret = flow_rates[position] * (time - 1) + find_solution(position, time - 1, opened2)
    end
    for link in links[position]
        cur = find_solution(link, time - 1, copy(opened))
        ret = max(ret, cur)
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
@show find_solution("AA", 30, Set())