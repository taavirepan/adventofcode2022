function move(rocks, rock, y, dx, dy)
    h = length(rock) - 1
    if y + dy < 1 || !all(rocks[y+dy:y+dy+h] .& (rock.<<dx) .== 0)
        return rock, y, false
    end

    if dx == -1 && all(x&1 == 0 for x in rock)
        return rock .>> 1, y, true
    elseif dx == 1 && all(x&64 == 0 for x in rock)
        return rock .<< 1, y, true
    elseif dx == 0
        return rock, y + dy, true
    end
    return rock, y, false
end

function simulate(rocks, kind)
    y = height(rocks) + 4
    h = length(kind) - 1
    if y + h - length(rocks) > 0
        rocks = vcat(rocks, zeros(UInt8, y + h - length(rocks)))
    end

    x = 2
    c = -1
    rock = kind .<< 2
    for i = 1:4*size(rocks,1)
        wind = jetpatterns[(i-1)%length(jetpatterns)+1]
        dx = wind == '<' ? -1 : 1;
        rock, y, _ = move(rocks, rock, y, dx, 0)
        rock, y, moved = move(rocks, rock, y, 0, -1)
        if !moved
            c = (i)%length(jetpatterns)+1
            break
        end
    end
    njetpatterns = jetpatterns[c:end] * jetpatterns[1:c-1]
    rocks[y:y+h] .|= rock
    return rocks, njetpatterns
end

function draw(rocks)
    for y=size(rocks,1):-1:1
        line = collect(".......")
        rocksline = [rocks[y]&2^i != 0 for i=0:6]
        line[rocksline] .= '#'
        println(join(line,""))
    end
    println("=======")
end

function height(rocks)
    for y = size(rocks, 1):-1:1
        if rocks[y] != 0
            return y
        end
    end
    return 0
end

rocktypes = [
    [0b1111],
    [0b010, 0b111, 0b010],
    [0b111, 0b100, 0b100],
    [1, 1, 1, 1],
    [0b11, 0b11]
]
jetpatterns = readchomp(stdin)
jp = jetpatterns

rocks = zeros(UInt8, 4)
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
        if (n-1)*5 + i == 2022
            println("task1 = ", height(rocks))
        end
    end
    if !(row in keys(reps))
        reps[row] = length(reps) + 1
        rmap[reps[row]] = row
    end
    push!(pattern, reps[row])
end
@show length(reps)
i = findfirst(pattern .== length(reps))
j = findfirst(pattern[i+1:end] .== length(reps))
start = pattern[1:i]
loop = pattern[i+1:i+j]

@show length(start)
@show length(loop)

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
