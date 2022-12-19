function parsebp(data)
    costs = Dict()
    for r in data
        if r[4] == nothing
            c = Dict(names[r[3]]=>parse(Int, r[2]))
            costs[names[r[1]]] = [0, 0, 0, 0]
            for (k,v) in c
                costs[names[r[1]]][k] = v
            end
        else
            c = Dict(names[r[3]]=>parse(Int, r[2]), names[r[5]]=>parse(Int, r[4]))
            costs[names[r[1]]] = [0, 0, 0, 0]
            for (k,v) in c
                costs[names[r[1]]][k] = v
            end
        end
    end
    return costs
end

function solve(blueprint, target, magic)
    production = [1,0,0,0]
    surplus = [0,0,0,0]
    for t = 1:24
        canbuild = [all(surplus .>= blueprint[i]) && production[i]<target[i] for i=1:4]
        i = findlast(canbuild)

        if i != nothing
            if magic%2 == 1
                canbuild[findlast(canbuild)] = false
            end
            i = findlast(canbuild)
            magic = div(magic, 2)
        end

        if i != nothing
            production[i] += 1
            surplus[i] -= 1
            surplus .-= blueprint[i]
        end
        surplus .+= production
    end
    surplus[4], magic!=0
end

# 22232344
function solve(blueprint)
    best = 0
    for r1 = 1:24
        for r2 = 1:24
            for r3 = 1:24
                for r4 = 1:24
                    if r1+r2+r3+r4 >= 24
                        break
                    end
                    for magic = 0:2^6
                        cur, toofar = solve(blueprint, [r1, r2, r3, r4], magic)
                        best = max(best, cur)
                        if toofar
                            break
                        end
                    end
                end
            end
        end
    end
    best
end

names = Dict("ore"=>1, "clay"=>2, "obsidian"=>3, "geode"=>4)
task1 = 0
for (i,line) in enumerate(readlines(stdin))
    global cutoff = 0
    data = collect(eachmatch(r"(\w+) robot costs (\d+) (\w+)(?: and (\d+) (\w+))?", line))
    blueprint = parsebp(data)
    best = solve(blueprint)
    global task1 += i*best
    @show i,best
end
@show task1
@show task1 == 1144
