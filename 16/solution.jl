function key(position1, position2, time, opened)
    ret = 0
    for o in opened
        ret += 2^(bits[o])
    end
    return ret, time, min(position1, position2), max(position1, position2)
end

function find_best_subsolution(p1, p2, time, opened)
    if !(p1 isa Array) && !(p2 isa Array)
        if flow_rates[p1] > 0 && flow_rates[p2] > 0 && p1 != p2 && !(p1 in opened) && !(p2 in opened)
            opened2 = copy(opened)
            push!(opened2, p1)
            push!(opened2, p2)
            ret = find_solution(p1, p2, time - 1, opened2)
            return Solution(ret.score + (flow_rates[p1]+flow_rates[p2]) * (time - 1), "$(27-time):$(p1)+$(p2);"*ret.valves)
        end
        return Solution(0, "")
    end

    varying = p1 isa Array ? p1 : p2
    fixed = p1 isa Array ? p2 : p1
    ret = Solution(0, "")
    if flow_rates[fixed] == 0 || fixed in opened
        return ret
    end
    for move in varying
        opened2 = copy(opened)
        push!(opened2, fixed)
        ret = max(ret, 
            find_solution(fixed, move, time - 1, opened2)
        )
    end
    return Solution(ret.score + flow_rates[fixed] * (time - 1), "$(27-time):$(fixed);"*ret.valves)
end

struct Solution
    score::Int
    valves::String
end
Base.isless(a::Solution,b::Solution) = a.score < b.score

function find_solution(position1, position2, time, opened)
    if time == 1
        return Solution(0, "")
    end
    k = key(position1, position2, time, opened)
    if k in keys(cache)
        return cache[k]
    end
    ret = find_best_subsolution(position1, position2, time, opened)
    ret = max(ret, find_best_subsolution(position1, links[position2], time, opened))
    ret = max(ret, find_best_subsolution(links[position1], position2, time, opened))
    for link1 in links[position1]
        for link2 in links[position2]
            cur = find_solution(link1, link2, time - 1, opened)
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

cache = Dict()
@show find_solution("AA", "AA", 26, Set())
