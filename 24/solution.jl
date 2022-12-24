wrap(x, a, b) = x > b ? a : (x < a ? b : x)

function step(map)
    ret = copy(map)
    for (blizzard, di, dj) in [
        [2, 0, 1],
        [4, 0, -1],
        [8, 1, 0],
        [16, -1, 0],
    ]
        for I in findall((map .& blizzard) .== blizzard)
            i, j = I[1] + di, I[2] + dj
            i = wrap(i, 2, size(map, 1) - 1)
            j = wrap(j, 2, size(map, 2) - 1)
            ret[I] ⊻= blizzard
            ret[i,j] ⊻= blizzard
        end
    end
    return ret
end

cache = Dict()
function simulate(time)
    if !(time in keys(cache))
        cache[time] = step(simulate(time - 1))
    end
    return cache[time]
end

function search(start, stop)
    queue = [[0, start]]
    mt = 0
    visited = Set()
    while length(queue) > 0
        t, pos = popfirst!(queue)
        if [t, pos] in visited
            continue
        end
        push!(visited, [t, pos])
        if pos == stop
            return t
        end
        tmap = simulate(t)
        if tmap[pos...] != 0 || t > 1000
            continue
        end

        for direction in [[0,1],[0,-1],[1,0],[-1,0]]
            npos = pos .+ direction
            if checkbounds(Bool, tmap, npos...)
                push!(queue, [t + 1, npos])
            end
        end
        push!(queue, [t + 1, pos])
    end
end

data = []
for line in readlines(stdin)
    global data
    push!(data, Vector{Char}(line))
end
data = hcat(data...)
data = permutedims(data, (2,1))
map = zeros(Int8, size(data))
map[data.=='.'] .= 0
map[data.=='#'] .= 1
map[data.=='>'] .= 2
map[data.=='<'] .= 4
map[data.=='v'] .= 8
map[data.=='^'] .= 16
cache[0] = map

start = findfirst(map[1,:] .== 0)
stop = findfirst(map[end,:] .== 0)

@show search([1, start], [size(map, 1), stop])

function display(map)
    for row in eachrow(map)
        out = fill('.', length(row))
        out[row .!= 0] .= '?'
        out[row .== 1] .= '#'
        out[row .== 2] .= '>'
        out[row .== 4] .= '<'
        out[row .== 8] .= 'v'
        out[row .== 16] .= '^'
        out[count_ones.(row) .== 2] .= '2'
        out[count_ones.(row) .== 3] .= '3'
        println(join(out, ""))
    end
    println()
end
