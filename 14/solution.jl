function draw!(cave, xy1, xy2)
    d = clamp.(xy2 .- xy1, -1, 1)
    while xy1 != xy2
        cave[xy1...] = 1
        xy1 += d
    end
    cave[xy2...] = 1
end

function fallingsand!(cave, x, _)
    for y = 1:size(cave, 2)-1
        nx = filter(z->cave[z,y+1]==0, [x, x-1, x+1])
        if length(nx) == 0
            cave[x,y] = 2
            return false
        else
            x = first(nx)
        end
    end
    return true
end

cave = zeros(1000, 500)
floor = 0
for line in readlines(stdin)
    global floor
    data = map(x->map(y->parse(Int,y), split(x, ",")), split(line, " -> "))
    for i = 2:length(data)
        floor = max(floor, data[i-1][2])
        floor = max(floor, data[i][2])
        draw!(cave, data[i-1] + [0, 1], data[i] + [0, 1])
    end
end
task1 = copy(cave)
cave[:,floor + 3] .= 1

for i = 0:1000
    if fallingsand!(task1, 500, 1)
        println("task1 = ", i)
        break
    end
end

for i = 0:100000
    fallingsand!(cave, 500, 1)
    if cave[500, 1] != 0
        println("task2 = ", i + 1)
        break
    end
end
