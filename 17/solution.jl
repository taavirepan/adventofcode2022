mutable struct Window
    y1
    y2
end

function move!(rocks, window, dx, dy)
    slice = rocks[window.y1:window.y2,:]
    for (i,y) in enumerate(window.y1:window.y2)
        for x = 1:7
            if rocks[y,x] == 2
                if !checkbounds(Bool, rocks, y+dy,x+dx)
                    return false
                end
                if rocks[y+dy,x+dx] == 1
                    return false
                end
            end
        end
    end
    cleared = copy(slice)
    cleared[cleared .== 2] .= 0
    rocks[window.y1:window.y2,:] = cleared
    for (i,y) in enumerate(window.y1:window.y2)
        for x = 1:7
            if slice[i,x] == 2
                rocks[y+dy,x+dx] = slice[i,x]
            end
        end
    end
    window.y1 += dy
    window.y2 += dy
    return true
end

function simulate(rocks, kind)
    y0 = 0
    for y = size(rocks, 1):-1:1
        if maximum(rocks[y,:]) != 0
            y0 = y
            break
        end
    end
    y0 += 3
    h = maximum(t for (b,t) in kind)
    if y0 + h - size(rocks,1) > 0
        rocks = vcat(rocks, zeros(Int8, y0 + h - size(rocks,1), 7))
    end
    for (i,(b,t)) in enumerate(kind)
        rocks[y0+b:y0+t,2+i] .= 2
    end
    # draw(rocks)
    window = Window(y0+1, y0+h)
    c = -1
    for i = 1:4*size(rocks,1)
        wind = jetpatterns[(i-1)%length(jetpatterns)+1]
        dx = wind == '<' ? -1 : 1;
        move!(rocks, window, dx, 0)
        if !move!(rocks, window, 0, -1)
            c = (i)%length(jetpatterns)+1
            break
        end
    end
    njetpatterns = jetpatterns[c:end] * jetpatterns[1:c-1]
    slice = rocks[window.y1:window.y2,:]
    slice[slice .== 2] .= 1
    rocks[window.y1:window.y2,:] = slice
    return rocks, njetpatterns
end

function draw(rocks)
    for y=size(rocks,1):-1:1
        line = collect(".......")
        line[rocks[y,:].==1] .= '#'
        line[rocks[y,:].==2] .= '@'
        println(join(line,""))
    end
    println("=======")
end

function height(rocks)
    for y = size(rocks, 1):-1:1
        if maximum(rocks[y,:]) != 0
            return y
        end
    end
    return 0
end

rocktypes = [
    [(1, 1), (1, 1), (1, 1), (1, 1)],
    [(2, 2), (1, 3), (2, 2)],
    [(1, 1), (1, 1), (1, 3)],
    [(1, 4)],
    [(1, 2), (1, 2)]
]
jetpatterns = readchomp(stdin)
jp = jetpatterns

rocks = zeros(Int8, 4, 7)
# added = zeros(Int, 5)
# for i = 1:5
#     global rocks, jetpatterns
#     rocks, jetpatterns = simulate(rocks, rocktypes[i])
#     added[i] = height(rocks)
# end
# @show added

reps = Dict()
rmap = Dict()
pattern = []
for n = 1:2000
    row = zeros(Int,5)
    h0 = height(rocks)
    for i = 1:5
        global rocks, jetpatterns
        rocks, jetpatterns = simulate(rocks, rocktypes[i])
        row[i] = height(rocks) - h0
    end
    if !(row in keys(reps))
        reps[row] = length(reps) + 1
        rmap[reps[row]] = row
    end
    push!(pattern, reps[row])
end
@show length(reps)
#@show pattern
i = findfirst(pattern .== length(reps))
j = findfirst(pattern[i+1:end] .== length(reps))
start = pattern[1:i]
loop = pattern[i+1:i+j]

@show length(start)
@show length(loop)

assembled = vcat(start, loop, loop)
# @show assembled
# @show assembled == pattern[1:length(start)+length(loop)*2]

target = div(1000000000000, 5)
target -= length(start)
n = div(target, length(loop))
m = target - length(loop)*n
@show n

task2 = 0
for x in start
    global task2
    task2 += rmap[x][end]
end
for x in loop
    global task2
    task2 += rmap[x][end] * n
end
for i in 1:m
    global task2
    task2 += rmap[loop[i]][end]
end

@show m
@show task2
